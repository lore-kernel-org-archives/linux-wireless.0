Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751366AbZISMVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 08:21:35 -0400
Message-ID: <4AB4CCD0.5080003@gmx.de>
Date: Sat, 19 Sep 2009 14:21:36 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ar9170: implement frequency calibration for one-stage/openfw
References: <200909032025.31260.chunkeey@googlemail.com> <20090918170211.8acce2cc.akpm@linux-foundation.org>
In-Reply-To: <20090918170211.8acce2cc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2009 02:02 AM, Andrew Morton wrote:
> On Thu, 3 Sep 2009 20:25:31 +0200
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> 
>> This patch ports some code from the vendor driver, which is
>> supposed to upload the right calibration values for the
>> chosen frequency.
>>
>> In theory, this should give a better range and throughput
>> for all users with the open, or one-stage firmware.
>>
>> ...
>>
>> +		for (i = 0; i < 76; i++) {
>> +			u32 phy_data;
>> +			u8 tmp;
>> +
>> +			if (i < 25) {
>> +				tmp = ar9170_interpolate_val(i, &pwrs[0][0],
>> +							     &vpds[0][0]);
>> +			} else {
>> +				tmp = ar9170_interpolate_val(i - 12,
>> +							     &pwrs[1][0],
>> +							     &vpds[1][0]);
>> +			}
>> +
>> +			phy_data |= tmp << ((i & 3) << 3);
> 
> Clearly buggy and the compiler warns.  The value of phy_data is unknown
> here.
> 
> How did this get all the way into mainline?

Strangely it compiles without any warning for me with the latest linux-wireless:

 joerg@nc10:~/src/wireless.gits/wireless-testing$ gcc --version
gcc (Ubuntu 4.3.3-5ubuntu4) 4.3.3
joerg@nc10:~/src/wireless.gits/wireless-testing$ git describe
v2.6.31-38258-g389ce02
joerg@nc10:~/src/wireless.gits/wireless-testing/drivers/net/wireless/ath/ar9170$ grep phy_data phy.c
                        u32 phy_data;
                        phy_data |= tmp << ((i & 3) << 3);
                                                (i & ~3), phy_data);
                                phy_data = 0;

joerg@nc10:~/src/wireless.gits/wireless-testing$ make modules
...
  CC [M]  drivers/net/wireless/ath/ar9170/mac.o
  CC [M]  drivers/net/wireless/ath/ar9170/phy.o
  CC [M]  drivers/net/wireless/ath/ar9170/led.o

make V=1 says:

  gcc -Wp,-MD,drivers/net/wireless/ath/ar9170/.phy.o.d  -nostdinc -isystem 
/usr/lib/gcc/i486-linux-gnu/4.3.3/include -Iinclude  
-I/home/joerg/src/wireless.gits/wireless-testing/arch/x86/include -include 
include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 
-freg-struct-return -mpreferred-stack-boundary=2 -march=i686 -mtune=pentium3 
-mtune=generic -Wa,-mtune=generic32 -ffreestanding -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -g 
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow  -DMODULE 
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(phy)"  
-D"KBUILD_MODNAME=KBUILD_STR(ar9170usb)"  -c -o 
drivers/net/wireless/ath/ar9170/.tmp_phy.o drivers/net/wireless/ath/ar9170/phy.c


Adding "-Wuninitialized" didn't help, acc. to the doc it is switched on
with -Wall for -O2.
Is this a regression of gcc?

Regards,
Jörg.
