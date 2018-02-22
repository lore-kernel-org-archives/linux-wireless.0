Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19889 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbeBVJXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 04:23:07 -0500
Subject: Re: [PATCH 2/4] staging: wilc1000: modified wilc_spi_read_int() by
 using GENMASK macro
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Ajay Singh <ajay.kathat@microchip.com>
CC: <devel@driverdev.osuosl.org>, <venkateswara.kaja@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1519229532-11265-1-git-send-email-ajay.kathat@microchip.com>
 <1519229532-11265-3-git-send-email-ajay.kathat@microchip.com>
 <20180222073731.ambug44zxpmwm76w@mwanda>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <8a20dcf4-8cfd-93bd-539e-e30e01f2a3b1@microchip.com> (sfid-20180222_102310_872354_896D2FB8)
Date: Thu, 22 Feb 2018 11:23:03 +0200
MIME-Version: 1.0
In-Reply-To: <20180222073731.ambug44zxpmwm76w@mwanda>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On 22.02.2018 09:37, Dan Carpenter wrote:
> On Wed, Feb 21, 2018 at 09:42:10PM +0530, Ajay Singh wrote:
>> Use existing macro GENMASK to get the bitmask value. Moved the code to
>> get the bitmask value outside the loop, as its only required one time.
>>
>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
>> ---
>>  drivers/staging/wilc1000/wilc_spi.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
>> index 131d2b7..c63f534 100644
>> --- a/drivers/staging/wilc1000/wilc_spi.c
>> +++ b/drivers/staging/wilc1000/wilc_spi.c
>> @@ -955,6 +955,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>>  	tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
>>  
>>  	j = 0;
>> +	unknown_mask = GENMASK(g_spi.nint - 1, 0);
>>  	do {
>>  		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
>>  		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
>> @@ -964,8 +965,6 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
>>  			tmp |= (((irq_flags >> 0) & 0x7) << k);
>>  		}
>>  
>> -		unknown_mask = ~((1ul << g_spi.nint) - 1);
>> -
> 
> This isn't right at all...  Say g_spi.nint is zero, then we're doing
> GENMASK(-1, 0) which seems like it should be undefined.  If g_spi.nint
> is 1 then "GENMASK(1 - 1, 0)" is 0x1 but "~((1 < 1) - 1)" is ~0x1.
> 

Even in this driver g_spi.nint is always constant and equal with NUM_INT_EXT
(which is 3), it seems that enabling interrupts before initializing g_spi.nint
may lead to the state where g_spi.nint = 0, as Dan pointed.

int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
{
		// ...
                if (wl->gpio >= 0 && init_irq(dev)) {
                        ret = -EIO;
                        goto _fail_locks_;
                }

		// ...
                ret = linux_wlan_start_firmware(dev); -> calls
linux_wlan_start_firmware which in turn calls wilc->hif_func->hif_sync_ext(wilc,
NUM_INT_EXT);

	
}

Thank you,
Claudiu Beznea

> I'm done reviewing this patch series...  You need to be more careful.
> Create a small test program to test your patches.  As a reviewer,
> creating test programs is how I review your patches.
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <limits.h>
> #include <string.h>
> #include "/home/dcarpenter/progs/smatch/devel/check_debug.h"
> #include "kernel.h"
> #include <assert.h>
> #include <fcntl.h>
> #include <sys/time.h>
> #include <sys/ioctl.h>
> #include <linux/blktrace_api.h>
> #include <linux/fs.h>
> 
> #define BITS_PER_LONG 64
> #define GENMASK(h, l) \
>         (((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
> 
> int main(void)
> {
>         int i;
>         u32 mask1, mask2;
> 
>         for (i = 0; i < 32; i++) {
>                 mask1 = ~((1ul << i) - 1);
>                 mask2 = GENMASK(i - 1, 0);
>                 if (mask1 == mask2)
>                         continue;
>                 printf("ONE 0x%x %d\n", mask1, i);
>                 printf("TWO 0x%x\n", mask2);
>         }
>         return 0;
> }
> 
> regards,
> dan carpenter
> 
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
