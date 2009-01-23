Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1215 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZAWQ0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:26:45 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Keir <keirlawson@gmail.com>,
	andrey@cozybit.com
Subject: Re: ath5k mesh in 2.6.28?
Date: Fri, 23 Jan 2009 11:26:15 -0500
Message-Id: <20090123153305.M33802@bobcopeland.com> (sfid-20090123_172702_491880_EE3D5FA0)
In-Reply-To: <e27b78a40901230725r4dc40975t8e4cb9f481df1702@mail.gmail.com>
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com> <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com> <e27b78a40901230725r4dc40975t8e4cb9f481df1702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2009/1/23 Bob Copeland <me@bobcopeland.com>:
> > On Fri, Jan 23, 2009 at 8:30 AM, Keir <keirlawson@gmail.com> wrote:
> >> Hi,
> >>
> >> According to the 802.11s website it seems to claim that mesh
> >> networking is supported for ath5k devices in kernel 2.6.28, however,
> >> upon running ifconfig mesh0 up (having previously created the mesh
> >> device using iw) I get "SIOCSIFFLAGS: Operation not supported".
[...]
> >
> > Mesh was enabled for 2.6.29 via b706e65b40417e03c2451bb3f92488f3736843fa,
> > so if you need it in 2.6.28 you can ask Greg to pick it up for stable.
>
> I would really like support in 2.6.28, but I don't want to
> inconvenience anyone... who's Greg?  What I would really like is ath5k
> mesh support in a stable kernel, the wireless-testing kernel I'm
> currently using is too unstable for my testing.

Your other option is to use compat-wireless with 2.6.28.  That might
be easier.  However, fixing mesh in 2.6.28 isn't a huge change and it
doesn't change any paths for any other opmode, so we might as well
ask...

Hi stable hackers,

Would you consider taking b706e65b40417e03c2451bb3f92488f3736843fa,
"ath5k: fix mesh point operation" for 2.6.28-stable?  It's a new feature 
compared to 2.6.27, so not a regression per se; however, ath5k advertises
mesh support in wiphy->interface_modes but doesn't make good on that 
promise when it comes to actually setting up such an interface.

Here's a rebased patch on top of 2.6.28:

>From 8569edccf7c900aecfaa32ccd4e84c56fb0460c4 Mon Sep 17 00:00:00 2001
From: Andrey Yurovsky <andrey@cozybit.com>
Date: Mon, 13 Oct 2008 18:23:07 -0700
Subject: [PATCH] ath5k: fix mesh point operation

This patch fixes mesh point operation (thanks to YanBo for pointing
out the problem): make mesh point interfaces start beaconing when
they come up and configure the RX filter in mesh mode so that mesh
beacons and action frames are received.  Add mesh point to the check
in ath5k_add_interface.  Tested with multiple AR5211 cards.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 2d14255..e521555 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2157,7 +2157,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 	if (sc->opmode == NL80211_IFTYPE_STATION) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
+		   sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2748,6 +2749,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
 		sc->opmode = conf->type;
 		break;
@@ -2819,7 +2821,8 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct
ieee80211_vif *vif,
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+	    (vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
@@ -2951,6 +2954,9 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		sc->opmode == NL80211_IFTYPE_ADHOC) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
+	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
+		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
+			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
 
 	/* Set filters */
 	ath5k_hw_set_rx_filter(ah,rfilt);
-- 
1.6.0.6


-- 
Bob Copeland %% www.bobcopeland.com


