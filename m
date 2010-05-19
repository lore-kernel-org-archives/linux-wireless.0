Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:7837 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753549Ab0ESBdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:33:37 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-098012816
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:33:36 +0900 (JST)
Subject: [PATCH v2 20/20] ath5k: no need to save/restore the default antenna
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:32:24 +0900
Message-ID: <20100519013224.22206.85364.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ath5k_hw_set_antenna_mode() always writes the default antenna register
and is called at the end of reset, there is no need to separately save and
restore the default antenna.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/reset.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index cf8fd48..3f24d46 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -880,12 +880,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
-	u32 s_seq[10], s_ant, s_led[3], staid1_flags, tsf_up, tsf_lo;
+	u32 s_seq[10], s_led[3], staid1_flags, tsf_up, tsf_lo;
 	u32 phy_tst1;
 	u8 mode, freq, ee_mode;
 	int i, ret;
 
-	s_ant = 0;
 	ee_mode = 0;
 	staid1_flags = 0;
 	tsf_up = 0;
@@ -982,9 +981,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			}
 		}
 
-		/* Save default antenna */
-		s_ant = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
-
 		if (ah->ah_version == AR5K_AR5212) {
 			/* Restore normal 32/40MHz clock operation
 			 * to avoid register access delay on certain
@@ -1144,8 +1140,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 				ath5k_hw_reg_write(ah, tsf_lo, AR5K_TSF_L32);
 			}
 		}
-
-		ath5k_hw_reg_write(ah, s_ant, AR5K_DEFAULT_ANTENNA);
 	}
 
 	/* Ledstate */

