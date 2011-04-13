Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60417 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437Ab1DMT4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 5/5] ath5k: disable 5 GHz support for the dualband PHY chip on dual-radio AR5312
Date: Wed, 13 Apr 2011 21:56:46 +0200
Message-Id: <1302724606-10190-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302724606-10190-4-git-send-email-nbd@openwrt.org>
References: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
 <1302724606-10190-2-git-send-email-nbd@openwrt.org>
 <1302724606-10190-3-git-send-email-nbd@openwrt.org>
 <1302724606-10190-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two variants of AR5312 dual-band devices, one single-radio
and the other one dual-radio. On the dual-radio board, the first MAC
only supports 5 GHz, even though it has a dual-band PHY. The 2.4 GHz
part of this phy is used in pass-through mode, connecting the second
MAC with the second PHY.
Disable 2.4 GHz for the first MAC on an AR5312, but only if the board
configuration indicates a dual-radio device.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ahb.c    |   10 ++++++++++
 drivers/net/wireless/ath/ath5k/attach.c |    5 +++++
 drivers/net/wireless/ath/ath5k/base.h   |    3 ++-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 1374e64..ea99827 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -160,6 +160,16 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		else
 			reg |= AR5K_AR5312_ENABLE_WLAN1;
 		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+
+		/*
+		 * On a dual-band AR5312, the multiband radio is only
+		 * used as pass-through. Disable 2 GHz support in the
+		 * driver for it
+		 */
+		if (to_platform_device(sc->dev)->id == 0 &&
+		    (bcfg->config->flags & (BD_WLAN0|BD_WLAN1)) ==
+		     (BD_WLAN1|BD_WLAN0))
+			__set_bit(ATH_STAT_2G_DISABLED, sc->status);
 	}
 
 	ret = ath5k_init_softc(sc, &ath_ahb_bus_ops);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 326d7c8..1588401 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -313,6 +313,11 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 		goto err;
 	}
 
+	if (test_bit(ATH_STAT_2G_DISABLED, sc->status)) {
+		__clear_bit(AR5K_MODE_11B, ah->ah_capabilities.cap_mode);
+		__clear_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode);
+	}
+
 	/* Crypto settings */
 	common->keymax = (sc->ah->ah_version == AR5K_AR5210 ?
 			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 4c4e360..b294f33 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -193,12 +193,13 @@ struct ath5k_softc {
 	dma_addr_t		desc_daddr;	/* DMA (physical) address */
 	size_t			desc_len;	/* size of TX/RX descriptors */
 
-	DECLARE_BITMAP(status, 5);
+	DECLARE_BITMAP(status, 6);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
 #define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
 #define ATH_STAT_PROMISC	2
 #define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
 #define ATH_STAT_STARTED	4		/* opened & irqs enabled */
+#define ATH_STAT_2G_DISABLED	5		/* multiband radio without 2G */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
-- 
1.7.3.2

