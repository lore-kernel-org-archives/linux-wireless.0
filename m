Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:15284 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751385Ab0FGELZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:25 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0996923883
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:23 +0900 (JST)
Subject: [PATCH 4/5] ath5k: no need to save/restore the default antenna
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:35 +0900
Message-ID: <20100607041135.18667.97545.stgit@tt-desk>
In-Reply-To: <20100607041012.18667.6859.stgit@tt-desk>
References: <20100607041012.18667.6859.stgit@tt-desk>
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
index d561f7c..498aa28 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -877,12 +877,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
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
@@ -979,9 +978,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			}
 		}
 
-		/* Save default antenna */
-		s_ant = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
-
 		if (ah->ah_version == AR5K_AR5212) {
 			/* Restore normal 32/40MHz clock operation
 			 * to avoid register access delay on certain
@@ -1141,8 +1137,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 				ath5k_hw_reg_write(ah, tsf_lo, AR5K_TSF_L32);
 			}
 		}
-
-		ath5k_hw_reg_write(ah, s_ant, AR5K_DEFAULT_ANTENNA);
 	}
 
 	/* Ledstate */

