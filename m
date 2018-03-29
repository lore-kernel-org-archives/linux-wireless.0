Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56030 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbeC2OWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 10:22:21 -0400
Date: Thu, 29 Mar 2018 11:22:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: nested structs parsing
Message-ID: <20180329112209.5c0e0320@vento.lan> (sfid-20180329_162224_620844_49469442)
In-Reply-To: <1522316827.5932.11.camel@sipsolutions.net>
References: <1522316775.5932.10.camel@sipsolutions.net>
        <1522316827.5932.11.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thu, 29 Mar 2018 11:47:07 +0200
Johannes Berg <johannes@sipsolutions.net> escreveu:

> On Thu, 2018-03-29 at 11:46 +0200, Johannes Berg wrote:
> > Hi,
> > 
> > For a while I haven't looked at my documentation for 802.11, and now I
> > noticed I'm getting warnings due to the nested parsing.
> > 
> > However, something seems to be wrong? I have, for example, this (in
> > net/mac80211/sta_info.h)
> > 
> > struct sta_info {
> > 	...
> >         struct {
> >                 u64 packets[IEEE80211_NUM_ACS];
> >                 u64 bytes[IEEE80211_NUM_ACS];
> >                 struct ieee80211_tx_rate last_rate;
> >                 u64 msdu[IEEE80211_NUM_TIDS + 1];
> >         } tx_stats;
> > };
> > 
> > but I'm getting the following warnings now, with only "@tx_stats" being
> > described in the documentation:
> > 
> > net/mac80211/sta_info.h:590: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
> > net/mac80211/sta_info.h:590: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
> > net/mac80211/sta_info.h:590: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
> > net/mac80211/sta_info.h:590: warning: Function parameter or member 'msdu' not described in 'sta_info'
> > 
> > I can understand the first three of those, but not the last one? Why is
> > the last one not qualified?
> > 
> > If I change it to this:
> > 
> >         struct {
> >                 u64 packets[IEEE80211_NUM_ACS];
> >                 u64 bytes[IEEE80211_NUM_ACS];
> >                 /**
> >                  * @last_rate: last TX rate
> >                  */
> >                 struct ieee80211_tx_rate last_rate;
> >                 /**
> >                  * @msdu: # of MSDUs per TID
> >                  */
> >                 u64 msdu[IEEE80211_NUM_TIDS + 1];
> >         } tx_stats;
> > 
> > I still get a warning on "tx_stats.last_rate", but not on "msdu", which
> > is sort of obvious from the warning text, but also rather unexpected.
> > 
> > Normally I'd say that the "msdu" warning is originally wrong
> > 
> > However, I'd also argue that if I'm using inline declarations, I
> > shouldn't have to write it like this:
> > 
> >         struct {
> >                 u64 packets[IEEE80211_NUM_ACS];
> >                 u64 bytes[IEEE80211_NUM_ACS];
> >                 /**
> >                  * @tx_stats.last_rate: last TX rate
> >                  */
> >                 struct ieee80211_tx_rate last_rate;
> > 	...
> > 	} tx_stats;  
> 
> Whoops, sent a fraction of a second too early - this actually causes a
> warning too (no idea why four times):
> 
> net/mac80211/sta_info.h:560: warning: Incorrect use of kernel-doc format:                  * @tx_stats.last_rate: last TX rate
> net/mac80211/sta_info.h:560: warning: Incorrect use of kernel-doc format:                  * @tx_stats.last_rate: last TX rate
> net/mac80211/sta_info.h:560: warning: Incorrect use of kernel-doc format:                  * @tx_stats.last_rate: last TX rate
> net/mac80211/sta_info.h:560: warning: Incorrect use of kernel-doc format:                  * @tx_stats.last_rate: last TX rate

The original patchset for nested structs was supporting it only 
when not inlined. This should be fixed on this patchset:

	https://lkml.org/lkml/2018/2/19/387

Do you have those patches on your tree?

With regards to duplicated warnings, that use to happen if the same header
is included several times (with is a common pratice at the net subsystem).

I also submitted some patches to linux-next addressing it.

Could you please merge from docs-next and see if those problems
get solved?

It is located at:

	git://git.lwn.net/linux.git docs-next

Thanks,
Mauro
