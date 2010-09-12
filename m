Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0ILUVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 16:21:00 -0400
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 6/8] compat-wireless: Add warning if wext is deactivated
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Sun, 12 Sep 2010 22:20:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <lrodriguez@atheros.com>, <linux-wireless@vger.kernel.org>,
	<mcgrof@infradead.org>
In-Reply-To: <1284221913-22455-8-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de> <1284221913-22455-8-git-send-email-hauke@hauke-m.de>
Message-ID: <aaefd6f9a498968940884abef19c81bf@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 11 Sep 2010 18:18:31 +0200, Hauke Mehrtens <hauke@hauke-m.de>
wrote:
> ++#ifdef CONFIG_WIRELESS_EXT
>  +		if (!dev->wireless_handlers)
>  +			dev->wireless_handlers = &cfg80211_wext_handler;
> ++#else
> ++		printk(KERN_WARNING "cfg80211: wext will not work because "
> ++			"kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools "
> ++			"using wext interface like iwconfig will not work.\n");
> ++#endif

This could use printk_once :-)

Also, if the kernel you're compiling against is new enough and was built
with cfg80211, this isn't necessary, but the normal code could be used
(which I believe this patch currently removes, rather than ifdeffing it)

johannes
