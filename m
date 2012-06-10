Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47229 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2FJFOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 01:14:48 -0400
Received: by eeit10 with SMTP id t10so1515254eei.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 22:14:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD42939.2020404@broadcom.com>
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
 <1339275105-3593-6-git-send-email-arend@broadcom.com> <CA+XFjioPG4aT-umi1BD+RH0q0a3AEY=QXTAFapGhz3x25cLdSw@mail.gmail.com>
 <4FD42939.2020404@broadcom.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 10 Jun 2012 07:14:27 +0200
Message-ID: <CA+XFjioaw4Bmxd_Wy_hjWO4G+LWWx4YmRAMFEgU4H_hFdoRVuw@mail.gmail.com> (sfid-20120610_071451_519647_3FBB0E7F)
Subject: Re: [PATCH 5/5] brcmfmac: introduce checkdied debugfs functionality
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 10, 2012 at 6:57 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/10/2012 04:13 AM, Gábor Stefanik wrote:
>> On Sat, Jun 9, 2012 at 10:51 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> The checkdied functionality provides useful information for analyzing
>>> firmware crashes. By exposing this information to a debugfs file users
>>> can easily provide its content in bug reports. The functionality is
>>> available only when CONFIG_BRCMDBG is selected.
>>>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  332 +++++++++++++++++++-
>>>  1 file changed, 331 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>>> index a07fb01..5a33b42 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
>>> @@ -31,6 +31,7 @@
>>>  #include <linux/firmware.h>
>>>  #include <linux/module.h>
>>>  #include <linux/bcma/bcma.h>
>>> +#include <linux/debugfs.h>
>>>  #include <asm/unaligned.h>
>>>  #include <defs.h>
>>>  #include <brcmu_wifi.h>
>>> @@ -48,6 +49,9 @@
>>>
>>>  #define CBUF_LEN       (128)
>>>
>>> +/* Device console log buffer state */
>>> +#define CONSOLE_BUFFER_MAX     2024
>>
>> Just out of curiosity; what is the significance of this number?
>
> It is used in the code fragment below. I have to admit the comment is
> not explaining its significance.

But why this particular number? Did you mean 2048?

>
>>> +       /* allocate buffer for console data */
>>> +       if (console_size <= CONSOLE_BUFFER_MAX)
>>> +               conbuf = kzalloc(console_size+1, GFP_ATOMIC);
>>> +
>>> +       if (!conbuf)
>>> +               return -ENOMEM;
>
> Probably would be better to use vmalloc() here or at least use
> GFP_KERNEL here.
>
> John, any recommendations?
>
> Gr. AvS
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
