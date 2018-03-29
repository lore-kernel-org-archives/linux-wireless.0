Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42498 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeC2OsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 10:48:11 -0400
Date: Thu, 29 Mar 2018 11:48:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: nested structs parsing
Message-ID: <20180329114806.3e7a9a45@vento.lan> (sfid-20180329_164814_271926_333B3DD7)
In-Reply-To: <1522333593.24162.12.camel@sipsolutions.net>
References: <1522316775.5932.10.camel@sipsolutions.net>
        <1522316827.5932.11.camel@sipsolutions.net>
        <20180329112209.5c0e0320@vento.lan>
        <1522333593.24162.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thu, 29 Mar 2018 16:26:33 +0200
Johannes Berg <johannes@sipsolutions.net> escreveu:

> Hi,
> 
> > The original patchset for nested structs was supporting it only 
> > when not inlined. This should be fixed on this patchset:
> > 
> > 	https://lkml.org/lkml/2018/2/19/387
> > 
> > Do you have those patches on your tree?  
> 
> No, looks like I don't have those yet. I'll wait for those then.
> 
> > With regards to duplicated warnings, that use to happen if the same header
> > is included several times (with is a common pratice at the net subsystem).  
> 
> Yeah, doesn't really matter anyway. I think I have to, in a sense,
> because I'm getting lots of functions separately from the headers.
> 
> > Could you please merge from docs-next and see if those problems
> > get solved?  
> 
> No, that doesn't seem to address it fully:
> 
> net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
> net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
> net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
> net/mac80211/sta_info.h:586: warning: Function parameter or member 'msdu' not described in 'sta_info'
> 
> You can reproduce this in
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> 
> (merging with docs-next) and running
> 
>   make SPHINXDIRS=driver-api/80211 htmldocs

No need to run it for checking the errors... you can run just:

	./scripts/kernel-doc -none net/mac80211/sta_info.h 

Applying the enclosed patch seems to work:

<patch>
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f64eb86ca64b..d81cb6155e8d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -477,6 +477,10 @@ struct ieee80211_sta_rx_stats {
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
  * @tx_stats: TX statistics
+ * @tx_stats.packets: foo
+ * @tx_stats.last_rate: bar
+ * @tx_stats.bytes: foobar
+ * @tx_stats.msdu: foo
  * @rx_stats: RX statistics
  * @pcpu_rx_stats: per-CPU RX statistics, assigned only if the driver needs
  *	this (by advertising the USES_RSS hw flag)
</patch>

What's weird is that tx_stats.msdu field seems to be parsed wrong.
I'll take a look on it.

Thanks,
Mauro
