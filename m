Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34367 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:00 -0500
Received: by gxk8 with SMTP id 8so301676gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:18:59 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52102.386489.422538@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:48:46 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 08/23] ath9k_htc: Set the BSSID mask for multiple interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    5 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   35 +++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index eecb42b..11d028f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -210,6 +210,11 @@ struct ath9k_htc_vif {
 	u8 index;
 };
 
+struct ath9k_vif_iter_data {
+	const u8 *hw_macaddr;
+	u8 mask[ETH_ALEN];
+};
+
 #define ATH9K_HTC_MAX_STA 8
 #define ATH9K_HTC_MAX_TID 8
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5ef0769..9620f45 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -133,6 +133,39 @@ static void ath9k_htc_vif_reconfig(struct ath9k_htc_priv *priv)
 	}
 }
 
+static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath9k_vif_iter_data *iter_data = data;
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+}
+
+static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
+				     struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_vif_iter_data iter_data;
+
+	/*
+	 * Use the hardware MAC address as reference, the hardware uses it
+	 * together with the BSSID mask when matching addresses.
+	 */
+	iter_data.hw_macaddr = common->macaddr;
+	memset(&iter_data.mask, 0xff, ETH_ALEN);
+
+	if (vif)
+		ath9k_htc_bssid_iter(&iter_data, vif->addr, vif);
+
+	/* Get list of all active MAC addresses */
+	ieee80211_iterate_active_interfaces_atomic(priv->hw, ath9k_htc_bssid_iter,
+						   &iter_data);
+
+	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+	ath_hw_setbssidmask(common);
+}
+
 void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
@@ -1200,6 +1233,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	ath9k_htc_set_bssid_mask(priv, vif);
+
 	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
-- 
1.7.4.1

