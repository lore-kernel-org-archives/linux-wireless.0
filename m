Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:16895 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349Ab0ELJkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:23 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0393937222
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:22 +0900 (JST)
Subject: [PATCH 08/12] ath5k: clarify logic when to enable spur mitigation
	filter
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:23 +0900
Message-ID: <20100512094023.6575.80390.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code logically did not make sense and seems to have been confused by
the fact that we could have newer EEPROMs on older hardware. In any case the
spur mitigation filter was set if the srev was >= AR5K_SREV_AR5424.

Spur info is available only from EEPROM versions bigger than 5.3 but but the
EEPOM routines will use static values for older versions, so that should be
o.k.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/reset.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 5e23e61..2890a7f 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1090,22 +1090,17 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		/* Write OFDM timings on 5212*/
 		if (ah->ah_version == AR5K_AR5212 &&
 			channel->hw_value & CHANNEL_OFDM) {
-			struct ath5k_eeprom_info *ee =
-					&ah->ah_capabilities.cap_eeprom;
 
 			ret = ath5k_hw_write_ofdm_timings(ah, channel);
 			if (ret)
 				return ret;
 
-			/* Note: According to docs we can have a newer
-			 * EEPROM on old hardware, so we need to verify
-			 * that our hardware is new enough to have spur
-			 * mitigation registers (delta phase etc) */
-			if (ah->ah_mac_srev >= AR5K_SREV_AR5424 ||
-			(ah->ah_mac_srev >= AR5K_SREV_AR5424 &&
-			ee->ee_version >= AR5K_EEPROM_VERSION_5_3))
+			/* Spur info is available only from EEPROM versions
+			 * bigger than 5.3 but but the EEPOM routines will use
+			 * static values for older versions */
+			if (ah->ah_mac_srev >= AR5K_SREV_AR5424)
 				ath5k_hw_set_spur_mitigation_filter(ah,
-								channel);
+								    channel);
 		}
 
 		/*Enable/disable 802.11b mode on 5111

