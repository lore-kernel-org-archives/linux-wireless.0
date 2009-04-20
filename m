Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbZDTV2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:28:36 -0400
Subject: Re: [PATCH 0/4] mac80211 powersave work
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50904201419v291b2ccpc208b642d1c25f29@mail.gmail.com> (sfid-20090420_232102_765090_A76401E2)
References: <20090416111723.904720021@sipsolutions.net>
	 <20090420194430.GG3369@tuxdriver.com>
	 <1240257188.4632.19.camel@johannes.local>
	 <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com>
	 <1240259450.4632.20.camel@johannes.local>
	 <2da21fe50904201419v291b2ccpc208b642d1c25f29@mail.gmail.com>
	 (sfid-20090420_232102_765090_A76401E2)
Content-Type: text/plain
Date: Mon, 20 Apr 2009 23:28:03 +0200
Message-Id: <1240262883.4632.24.camel@johannes.local> (sfid-20090420_232840_160297_A6EFACC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-04-20 at 23:19 +0200, Davide Pesavento wrote:

> >> As I've already reported [1][2], ath9k is currently broken when power
> >> saving is enabled, at least on AR5418 hardware. So please don't turn
> >> it on by default yet.
> >
> > But if that's just a hardware/driver bug shouldn't the driver disable PS
> > for that combination? It seems wrong to disable PS in the stack by
> > default just because one driver has a problem with it, when that driver
> > could just unset the PS support bit.
> >
> 
> You're right. It makes perfect sense.
> Unfortunately I don't know how to do it... :-(

Something like this.

johannes

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-04-20 23:27:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-04-20 23:27:54.000000000 +0200
@@ -1537,8 +1537,6 @@ void ath_set_hw_capab(struct ath_softc *
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)


