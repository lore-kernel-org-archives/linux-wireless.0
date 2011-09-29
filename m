Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61488 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1I2CdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 22:33:22 -0400
Received: by eya28 with SMTP id 28so83676eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 19:33:21 -0700 (PDT)
Message-ID: <4E83D8B1.1080002@gmail.com> (sfid-20110929_043326_224211_1EEEBA30)
Date: Thu, 29 Sep 2011 04:32:17 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: 'Chaoming_Li' <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com> <4E823976.2090407@lwfinger.net> <4E824D75.1070509@gmail.com> <4E82A8E9.60409@lwfinger.net> <4E83AD85.8050005@gmail.com>
In-Reply-To: <4E83AD85.8050005@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 01:28 AM, Stefan Zwanenburg wrote:
> I had some time on my hands, so I tried to figure out how to dump the
> EEPROM data myself, and have done so using the following patch (based on
> linux-3.0.4):
>
> --- drivers/net/wireless/rtlwifi/rtl8192se/hw.c    2011-07-22
> 04:17:23.000000000 +0200
> +++ /home/psychotic/Desktop/rtl8192se_hw.c    2011-09-29
> 01:16:09.361978051 +0200
> @@ -1645,6 +1645,13 @@
>      RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, ("MAP\n"),
>                hwinfo, HWSET_MAX_SIZE_92S);
>  
> +    printk("RTL8192SE - got EEPROM data:");
> +    for (i = 0; i < HWSET_MAX_SIZE_92S; i++) {
> +        if (i % 6 == 0)
> +            printk("\n  ");
> +        printk("%02X ", hwinfo[i]);
> +    }
> +
>      eeprom_id = *((u16 *)&hwinfo[0]);
>      if (eeprom_id != RTL8190_EEPROM_ID) {
>          RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
For posterity's sake, there was a slightly smaller workaround here, and
it would be as in the following patch:

--- drivers/net/wireless/rtlwifi/rtl8192se/hw.c    2011-09-29
04:20:14.660831861 +0200
+++ drivers/net/wireless/rtlwifi/rtl8192se/hw.c    2011-09-29
04:20:05.303831474 +0200
@@ -1642,7 +1642,7 @@
             HWSET_MAX_SIZE_92S);
     }
 
-    RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, ("MAP\n"),
+    RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_EMERG, ("MAP\n"),
               hwinfo, HWSET_MAX_SIZE_92S);
 
     eeprom_id = *((u16 *)&hwinfo[0]);

It's rather nasty though, as it pretends that dumping the EEPROM data is
happening right before a fatal error has occurred. But there's really no
other way, as using sysfs to set the "global_debuglevel" is not good
enough because the EEPROM data is read right after the module is loaded
(making it hard to set the debuglevel in time).

If this info is useless to you, disregard it!

Stefan Zwanenburg

PS: the EEPROM data I mentioned in my previous message is still the same
though, so I won't bother to repost it.
