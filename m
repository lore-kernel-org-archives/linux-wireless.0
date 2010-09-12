Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52184 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0ILUfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 16:35:19 -0400
Message-ID: <4C8D397F.4000608@hauke-m.de>
Date: Sun, 12 Sep 2010 22:35:11 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 6/8] compat-wireless: Add warning if wext is deactivated
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de> <1284221913-22455-8-git-send-email-hauke@hauke-m.de> <aaefd6f9a498968940884abef19c81bf@localhost>
In-Reply-To: <aaefd6f9a498968940884abef19c81bf@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12.09.2010 22:20, Johannes Berg wrote:
> 
> On Sat, 11 Sep 2010 18:18:31 +0200, Hauke Mehrtens <hauke@hauke-m.de>
> wrote:
>> ++#ifdef CONFIG_WIRELESS_EXT
>>  +		if (!dev->wireless_handlers)
>>  +			dev->wireless_handlers = &cfg80211_wext_handler;
>> ++#else
>> ++		printk(KERN_WARNING "cfg80211: wext will not work because "
>> ++			"kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools "
>> ++			"using wext interface like iwconfig will not work.\n");
>> ++#endif
> 
> This could use printk_once :-)

Yes that will be better. I will resend a new patch.

> Also, if the kernel you're compiling against is new enough and was built
> with cfg80211, this isn't necessary, but the normal code could be used
> (which I believe this patch currently removes, rather than ifdeffing it)

Using the normal code does not work because the kernel accesses the wext
handler through struct wiphy which is shipped with compat-wireless.
struct wiphy used in e.g. kernel 2.6.33 is different from the struct
used in compat-wireless. The wext attribute is at a different position
and the kernel would dereference a wrong pointer or something else.

Hauke
