Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60606 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1GWN3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 09:29:04 -0400
Subject: [PATCH 2 2/3] ath5k: remove most references to XR
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 23 Jul 2011 09:29:03 -0400
Message-ID: <20110723132903.10739.29781.stgit@mj.roinet.com> (sfid-20110723_152908_997944_4267C9ED)
In-Reply-To: <20110723132856.10739.42301.stgit@mj.roinet.com>
References: <20110723132856.10739.42301.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

XR is a proprietary feature of the chipset.  It's not supported and
should not be supported.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    4 ----
 drivers/net/wireless/ath/ath5k/eeprom.c |    1 -
 drivers/net/wireless/ath/ath5k/phy.c    |    2 --
 drivers/net/wireless/ath/ath5k/qcu.c    |    7 -------
 drivers/net/wireless/ath/ath5k/reset.c  |    8 --------
 5 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index be7b8c0..a8a7db4 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -416,7 +416,6 @@ enum ath5k_driver_mode {
 	AR5K_MODE_11A		=	0,
 	AR5K_MODE_11B		=	1,
 	AR5K_MODE_11G		=	2,
-	AR5K_MODE_XR		=	0,
 	AR5K_MODE_MAX		=	3
 };
 
@@ -694,12 +693,10 @@ struct ath5k_gain {
 #define	CHANNEL_5GHZ	0x0100	/* 5GHz channel */
 #define	CHANNEL_PASSIVE	0x0200	/* Only passive scan allowed */
 #define	CHANNEL_DYN	0x0400	/* Dynamic CCK-OFDM channel (for g operation) */
-#define	CHANNEL_XR	0x0800	/* XR channel */
 
 #define	CHANNEL_A	(CHANNEL_5GHZ | CHANNEL_OFDM)
 #define	CHANNEL_B	(CHANNEL_2GHZ | CHANNEL_CCK)
 #define	CHANNEL_G	(CHANNEL_2GHZ | CHANNEL_OFDM)
-#define	CHANNEL_X	(CHANNEL_5GHZ | CHANNEL_OFDM | CHANNEL_XR)
 
 #define	CHANNEL_ALL	(CHANNEL_OFDM | CHANNEL_CCK | \
 			 CHANNEL_2GHZ | CHANNEL_5GHZ)
@@ -710,7 +707,6 @@ struct ath5k_gain {
  * Used internally for ath5k_hw_reset_tx_queue().
  * Also see struct struct ieee80211_channel.
  */
-#define IS_CHAN_XR(_c)	((_c->hw_value & CHANNEL_XR) != 0)
 #define IS_CHAN_B(_c)	((_c->hw_value & CHANNEL_B) != 0)
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 9068b91..56cb9d4 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1782,7 +1782,6 @@ ath5k_eeprom_mode_from_channel(struct ieee80211_channel *channel)
 {
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_XR:
 		return AR5K_EEPROM_MODE_11A;
 	case CHANNEL_G:
 		return AR5K_EEPROM_MODE_11G;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 81e465e..b9ada88 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2408,8 +2408,6 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 	case CHANNEL_B:
 		ctl_mode |= AR5K_CTL_11B;
 		break;
-	case CHANNEL_XR:
-		/* Fall through */
 	default:
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 65f1039..1d37675 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -185,13 +185,6 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 		case AR5K_TX_QUEUE_CAB:
 			queue = AR5K_TX_QUEUE_ID_CAB;
 			break;
-		case AR5K_TX_QUEUE_XR_DATA:
-			if (ah->ah_version != AR5K_AR5212)
-				ATH5K_ERR(ah,
-					"XR data queues only supported in"
-					" 5212!\n");
-			queue = AR5K_TX_QUEUE_ID_XR_DATA;
-			break;
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 0686c5d..5d6d3bd 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1108,14 +1108,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 		mode = AR5K_MODE_11B;
 		break;
-	case CHANNEL_XR:
-		if (ah->ah_version == AR5K_AR5211) {
-			ATH5K_ERR(ah,
-				"XR mode not available on 5211");
-			return -EINVAL;
-		}
-		mode = AR5K_MODE_XR;
-		break;
 	default:
 		ATH5K_ERR(ah,
 			"invalid channel: %d\n", channel->center_freq);
