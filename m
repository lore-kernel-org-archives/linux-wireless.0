Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55261 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1GWHVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 03:21:22 -0400
Subject: [PATCH 2/3] ath5k: remove most references to XR
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 23 Jul 2011 03:21:20 -0400
Message-ID: <20110723072120.17363.56122.stgit@mj.roinet.com> (sfid-20110723_092125_612923_55DDF4CE)
In-Reply-To: <20110723072113.17363.59871.stgit@mj.roinet.com>
References: <20110723072113.17363.59871.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

XR is a proprietary feature of the chipset.  It's not supported and
should not be supported.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |   26 --------------------------
 drivers/net/wireless/ath/ath5k/eeprom.c |    1 -
 drivers/net/wireless/ath/ath5k/phy.c    |    2 --
 drivers/net/wireless/ath/ath5k/qcu.c    |    7 -------
 drivers/net/wireless/ath/ath5k/reset.c  |    8 --------
 5 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index be7b8c0..c3a008d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -356,23 +356,6 @@ struct ath5k_srev_name {
 /* TODO add support to mac80211 for vendor-specific rates and modes */
 
 /*
- * Some of this information is based on Documentation from:
- *
- * http://madwifi-project.org/wiki/ChipsetFeatures/SuperAG
- *
- * Modulation for Atheros' eXtended Range - range enhancing extension that is
- * supposed to double the distance an Atheros client device can keep a
- * connection with an Atheros access point. This is achieved by increasing
- * the receiver sensitivity up to, -105dBm, which is about 20dB above what
- * the 802.11 specifications demand. In addition, new (proprietary) data rates
- * are introduced: 3, 2, 1, 0.5 and 0.25 MBit/s.
- *
- * Please note that can you either use XR or TURBO but you cannot use both,
- * they are exclusive.
- *
- */
-#define MODULATION_XR		0x00000200
-/*
  * Modulation for Atheros' Turbo G and Turbo A, its supposed to provide a
  * throughput transmission speed up to 40Mbit/s-60Mbit/s at a 108Mbit/s
  * signaling rate achieved through the bonding of two 54Mbit/s 802.11g
@@ -416,7 +399,6 @@ enum ath5k_driver_mode {
 	AR5K_MODE_11A		=	0,
 	AR5K_MODE_11B		=	1,
 	AR5K_MODE_11G		=	2,
-	AR5K_MODE_XR		=	0,
 	AR5K_MODE_MAX		=	3
 };
 
@@ -694,12 +676,10 @@ struct ath5k_gain {
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
@@ -710,7 +690,6 @@ struct ath5k_gain {
  * Used internally for ath5k_hw_reset_tx_queue().
  * Also see struct struct ieee80211_channel.
  */
-#define IS_CHAN_XR(_c)	((_c->hw_value & CHANNEL_XR) != 0)
 #define IS_CHAN_B(_c)	((_c->hw_value & CHANNEL_B) != 0)
 
 /*
@@ -772,11 +751,6 @@ struct ath5k_athchan_2ghz {
 #define ATH5K_RATE_CODE_36M	0x0D
 #define ATH5K_RATE_CODE_48M	0x08
 #define ATH5K_RATE_CODE_54M	0x0C
-/* XR */
-#define ATH5K_RATE_CODE_XR_500K	0x07
-#define ATH5K_RATE_CODE_XR_1M	0x02
-#define ATH5K_RATE_CODE_XR_2M	0x06
-#define ATH5K_RATE_CODE_XR_3M	0x01
 
 /* adding this flag to rate_code enables short preamble */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
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
