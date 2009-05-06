Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbZEFU0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 16:26:54 -0400
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
 on 802.11a capable card
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1241640751.3289.2.camel@mj>
References: <1241626486.30590.13.camel@mj>
	 <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
	 <20090506172513.GB30070@tuxdriver.com>  <1241640751.3289.2.camel@mj>
Content-Type: text/plain
Date: Wed, 06 May 2009 22:26:45 +0200
Message-Id: <1241641605.4029.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-06 at 16:12 -0400, Pavel Roskin wrote:

> > > > If I scan by "iw dev wlan0 scan" while sending data through the
> > > > interface, I get a BUG in net/mac80211/tx.c:
> > > 
> > > Agreed... Also I think the same thing happens for rx for ath5k,
> > > explaining the 'unknown rate index' warnings (sc->curband changes
> > > during scan but we process a beacon from 2ghz band, that one at
> > > least just needs some synchronization in the driver).
> > 
> > Ah, that could be -- I sure am tired of reading bug reports about
> > that...
> 
> I've bisected it.  The problem is introduced by the commit
> 2038ccfbb5f7fc7d8bca26bf53bdd6c7778136ff:
> 
> Author:     Johannes Berg <johannes@sipsolutions.net>
> AuthorDate: Wed Apr 29 12:26:17 2009 +0200
> Commit:     John W. Linville <linville@tuxdriver.com>
> CommitDate: Thu Apr 30 15:06:34 2009 -0400
> 
>     mac80211: tell driver when idle

Huh? That's confusing. Also, you say you get a BUG but point out a
WARN_ON_ONCE, was that an oversight or does something crash there?

OTOH, I can see one thing happening -- it would access scan_channel.
Patch should fix that, does it help?

johannes

--- wireless-testing.orig/net/mac80211/iface.c	2009-05-06 22:25:45.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-05-06 22:25:53.000000000 +0200
@@ -964,5 +964,6 @@ void ieee80211_recalc_idle(struct ieee80
 	mutex_lock(&local->iflist_mtx);
 	chg = __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->iflist_mtx);
-	ieee80211_hw_config(local, chg);
+	if (chg)
+		ieee80211_hw_config(local, chg);
 }


