Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38314 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753867Ab1ASJUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:21 -0500
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0960678820
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:20 +0900 (JST)
Subject: [PATCH 3/8] ath5k: Rename ath5k_copy_channels
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:47 +0900
Message-ID: <20110119092047.19628.99228.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename ath5k_copy_channels() to ath5k_setup_channels() - nothing is copied
here.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0387acb..9e8b1f4 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -256,7 +256,7 @@ static bool ath5k_is_standard_channel(short chan)
 }
 
 static unsigned int
-ath5k_copy_channels(struct ath5k_hw *ah,
+ath5k_setup_channels(struct ath5k_hw *ah,
 		struct ieee80211_channel *channels,
 		unsigned int mode,
 		unsigned int max)
@@ -356,7 +356,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		sband->n_bitrates = 12;
 
 		sband->channels = sc->channels;
-		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11G, max_c);
 
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
@@ -382,7 +382,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		}
 
 		sband->channels = sc->channels;
-		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11B, max_c);
 
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
@@ -402,7 +402,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		sband->n_bitrates = 8;
 
 		sband->channels = &sc->channels[count_c];
-		sband->n_channels = ath5k_copy_channels(ah, sband->channels,
+		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11A, max_c);
 
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;

