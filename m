Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1458 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZCWDEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 23:04:36 -0400
Date: Sun, 22 Mar 2009 23:04:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090323030419.GA5803@hash.localnet> (sfid-20090323_040448_431371_B9D97201)
References: <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet> <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet> <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 03, 2009 at 06:31:05AM +0200, Nick Kossifidis wrote:
> and i don't believe i've ever seen them, so we can warn on them too
> and print something like "Reserved rate code: %x", also it would be
> nice to warn on XR rates (1,2,3,6,7) in case we want to debug this in
> the future.

Nick, are you ok with taking this patch as-is and adding the other stuff
in later?  It does fix a warning in mac80211 for unknown rates and 
instead warns with the actual hw rate code we get.

Here's a repost (rebased, if it matters):

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 2 Mar 2009 21:55:18 -0500
Subject: [PATCH] ath5k: warn and correct rate for unknown hw rate indexes

ath5k sets up a mapping table from the hardware rate index to
the rate index used by mac80211; however, we have seen some
received frames with incorrect rate indexes.  Such frames
normally get dropped with a warning in __ieee80211_rx(),
but it doesn't include enough information to track down the
error.

This patch adds a warning to hw_to_driver_rix for any lookups
that result in a rate index of -1, then returns a valid rate so
the frame can be processed.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   15 ++++++++++++---
 drivers/net/wireless/ath5k/base.h |    2 +-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index f28b86c..6580df2 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1088,9 +1088,18 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 static inline int
 ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 {
-	WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
-			"hw_rix out of bounds: %x\n", hw_rix);
-	return sc->rate_idx[sc->curband->band][hw_rix];
+	int rix;
+
+	/* return base rate on errors */
+	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
+			"hw_rix out of bounds: %x\n", hw_rix))
+		return 0;
+
+	rix = sc->rate_idx[sc->curband->band][hw_rix];
+	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
+		rix = 0;
+
+	return rix;
 }
 
 /***************\
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 20e0d14..8229561 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -112,7 +112,7 @@ struct ath5k_softc {
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
 	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	u8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
 	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
-- 
1.6.0.6


-- 
Bob Copeland %% www.bobcopeland.com

