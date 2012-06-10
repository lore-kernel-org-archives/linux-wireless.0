Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3288 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2FJE5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 00:57:41 -0400
Message-ID: <4FD42939.2020404@broadcom.com> (sfid-20120610_065745_729302_5E015B0C)
Date: Sun, 10 Jun 2012 06:57:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] brcmfmac: introduce checkdied debugfs
 functionality
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
 <1339275105-3593-6-git-send-email-arend@broadcom.com>
 <CA+XFjioPG4aT-umi1BD+RH0q0a3AEY=QXTAFapGhz3x25cLdSw@mail.gmail.com>
In-Reply-To: <CA+XFjioPG4aT-umi1BD+RH0q0a3AEY=QXTAFapGhz3x25cLdSw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 04:13 AM, Gábor Stefanik wrote:
> On Sat, Jun 9, 2012 at 10:51 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> The checkdied functionality provides useful information for analyzing
>> firmware crashes. By exposing this information to a debugfs file users
>> can easily provide its content in bug reports. The functionality is
>> available only when CONFIG_BRCMDBG is selected.
>>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  332 +++++++++++++++++++-
>>  1 file changed, 331 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> index a07fb01..5a33b42 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/firmware.h>
>>  #include <linux/module.h>
>>  #include <linux/bcma/bcma.h>
>> +#include <linux/debugfs.h>
>>  #include <asm/unaligned.h>
>>  #include <defs.h>
>>  #include <brcmu_wifi.h>
>> @@ -48,6 +49,9 @@
>>
>>  #define CBUF_LEN       (128)
>>
>> +/* Device console log buffer state */
>> +#define CONSOLE_BUFFER_MAX     2024
> 
> Just out of curiosity; what is the significance of this number?

It is used in the code fragment below. I have to admit the comment is
not explaining its significance.

>> +       /* allocate buffer for console data */
>> +       if (console_size <= CONSOLE_BUFFER_MAX)
>> +               conbuf = kzalloc(console_size+1, GFP_ATOMIC);
>> +
>> +       if (!conbuf)
>> +               return -ENOMEM;

Probably would be better to use vmalloc() here or at least use
GFP_KERNEL here.

John, any recommendations?

Gr. AvS

