Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3972 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab1DURKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 13:10:41 -0400
To: "Roland Vossen" <rvossen@broadcom.com>,
	"Joe Perches" <joe@perches.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] staging: brcm80211: replaced WL_NONE with
 no_printk
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
 <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
 <1303403680.24766.55.camel@Joe-Laptop>
Date: Thu, 21 Apr 2011 19:10:26 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vuasnofu3ri7v4@arend-laptop>
In-Reply-To: <1303403680.24766.55.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Apr 2011 18:34:40 +0200, Joe Perches <joe@perches.com> wrote:

> On Thu, 2011-04-21 at 13:02 +0200, Roland Vossen wrote:
> []
>> diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h  
>> b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
>> index 54af257..8705b40 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
>> +++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
>> @@ -20,8 +20,6 @@
>>  /* wl_msg_level is a bit vector with defs in wlioctl.h */
>>  extern u32 wl_msg_level;
>>
>> -#define WL_NONE(fmt, args...) no_printk(fmt, ##args)
>> -
>
> I think you misunderstand the purpose of no_printk.
> no_printk is used simply to validate format arguments
> and not emit anything.
>
> It's typically used for debugging like
>
> #ifndef DEBUG
> #define FOO_DBG(fmt, ...)	printk(fmt, ##__VA_ARGS__)
> #else
> #define FOO_DBG(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> #endif
>
> What you've got here is effectively a comment.
>

If you want to debug a specific source file you could do following in that  
particular source file:

#undef no_printk
#define no_printk  printk

Not sure whether that is the intended use here.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

