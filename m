Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61468 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2FGHhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:37:19 -0400
Message-ID: <4FD05A27.80102@qca.qualcomm.com> (sfid-20120607_093723_811304_CA07EF34)
Date: Thu, 7 Jun 2012 13:07:11 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com> <1339053852.6009.13.camel@joe2Laptop>
In-Reply-To: <1339053852.6009.13.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

>>>
>>> I think there's one use of wiphy_dbg that could be a
>>> mac80211_ht_dbg without much loss.
>>>
>>> Maybe add "%s", wiphy_name() to the args there.
>>>
>>
>> sorry, i could not understand with wiphy_debug, with mac80211_ht_debug.
>> the later is for HT and aggregation related messages.
>
> It was an automatic conversion.
>
> Might as well unconvert it back too.
>
> $ git grep -E -A4 -n "ifdef CONFIG_MAC80211_HT_DEBUG" net/mac80211/rx.c
> net/mac80211/rx.c:635:#ifdef CONFIG_MAC80211_HT_DEBUG
> net/mac80211/rx.c-636-                  if (net_ratelimit())
> net/mac80211/rx.c-637-                          wiphy_debug(hw->wiphy,
> net/mac80211/rx.c-638-                                      "release an RX reorder frame due to timeout on earlier frames\n");
> net/mac80211/rx.c-639-#endif
>
> $ git blame -L635,+4 net/mac80211/rx.c
> aa0c8636 (Christian Lamparter 2010-08-05 01:36:04 +0200 635) #ifdef CONFIG_MAC80211_HT_DEBUG
> aa0c8636 (Christian Lamparter 2010-08-05 01:36:04 +0200 636)                    if (net_ratelimit())
> 0fb9a9ec (Joe Perches         2010-08-20 16:25:38 -0700 637)                            wiphy_debug(hw->wiphy,
> 0fb9a9ec (Joe Perches         2010-08-20 16:25:38 -0700 638)                                        "release an RX reorder fram
>
> $ git log -1 0fb9a9ec
> commit 0fb9a9ec27718fbf7fa3153bc94becefb716ceeb
> Author: Joe Perches<joe@perches.com>
> Date:   Fri Aug 20 16:25:38 2010 -0700
>
>      net/mac80211: Use wiphy_<level>
>
>      Standardize logging messages from
>          printk(KERN_<level>  "%s: " fmt , wiphy_name(foo), args);
>      to
>          wiphy_<level>(foo, fmt, args);
>
>      Signed-off-by: Joe Perches<joe@perches.com>
>      Signed-off-by: John W. Linville<linville@tuxdriver.com>
>
>

thanks(and brilliant!), in that rx.c we can convert it to 
mac80211_ht_debug. what about the other wiphy_debug messages, we would 
still retain them know

-- 
thanks,
shafi
