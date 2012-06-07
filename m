Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38098 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752111Ab2FGHYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:24:12 -0400
Message-ID: <1339053852.6009.13.camel@joe2Laptop> (sfid-20120607_092415_546950_7ABBFB35)
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Jun 2012 00:24:12 -0700
In-Reply-To: <4FD0540C.5060808@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:41 +0530, Mohammed Shafi Shajakhan wrote:
> Hi Joe,

Hello Mohammed.

> On Thursday 07 June 2012 11:55 AM, Joe Perches wrote:
> > On Thu, 2012-06-07 at 11:32 +0530, Mohammed Shafi Shajakhan wrote:
> >> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> >>
> >> ratelimit few aggregation related messages, these messages
> >> floods the log when aggregation is disabled in the AP(for some
> >> wifi testcases) and we run traffic between STA and AP.
> >
> > I looked at all of the #ifdef CONFIG_MAC80211_HT_DEBUG uses.
> >
> > I think it's better simply to define a mac80211_ht_dbg
> > macro for each of the !CONFIG and CONFIG cases and convert
> > all of the other #ifdef CONFIG_MAC80211_HT_DEBUG logging
> > messages.
> 
> oh, ok.
> 
> >
> > #ifdef CONFIG_MAC80211_HT_DEBUG
> > #define mac80211_ht_dbg(fmt, ...)				\
> > 	net_dbg_ratelimited(fmt, ##__VA_ARGS__)
> > #else
> > #define mac80211_ht_dbg(fmt, ...)				\
> > do {								\
> > 	if (0)							\
> > 		net_dbg_ratelimited(fmt, ##__VA_ARGS__);	\
> > } while (0)
> >
> > etc...
> >
> > I think there's one use of wiphy_dbg that could be a
> > mac80211_ht_dbg without much loss.
> >
> > Maybe add "%s", wiphy_name() to the args there.
> >
> 
> sorry, i could not understand with wiphy_debug, with mac80211_ht_debug. 
> the later is for HT and aggregation related messages.

It was an automatic conversion.

Might as well unconvert it back too.

$ git grep -E -A4 -n "ifdef CONFIG_MAC80211_HT_DEBUG" net/mac80211/rx.c
net/mac80211/rx.c:635:#ifdef CONFIG_MAC80211_HT_DEBUG
net/mac80211/rx.c-636-                  if (net_ratelimit())
net/mac80211/rx.c-637-                          wiphy_debug(hw->wiphy,
net/mac80211/rx.c-638-                                      "release an RX reorder frame due to timeout on earlier frames\n");
net/mac80211/rx.c-639-#endif

$ git blame -L635,+4 net/mac80211/rx.c
aa0c8636 (Christian Lamparter 2010-08-05 01:36:04 +0200 635) #ifdef CONFIG_MAC80211_HT_DEBUG
aa0c8636 (Christian Lamparter 2010-08-05 01:36:04 +0200 636)                    if (net_ratelimit())
0fb9a9ec (Joe Perches         2010-08-20 16:25:38 -0700 637)                            wiphy_debug(hw->wiphy,
0fb9a9ec (Joe Perches         2010-08-20 16:25:38 -0700 638)                                        "release an RX reorder fram

$ git log -1 0fb9a9ec
commit 0fb9a9ec27718fbf7fa3153bc94becefb716ceeb
Author: Joe Perches <joe@perches.com>
Date:   Fri Aug 20 16:25:38 2010 -0700

    net/mac80211: Use wiphy_<level>
    
    Standardize logging messages from
        printk(KERN_<level> "%s: " fmt , wiphy_name(foo), args);
    to
        wiphy_<level>(foo, fmt, args);
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


