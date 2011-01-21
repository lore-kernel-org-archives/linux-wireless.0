Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44780 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1AUDAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:00:52 -0500
Received: by mail-pz0-f46.google.com with SMTP id 35so218028pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:00:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63158.422160.915834@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:30:06 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 07/33] ath9k_htc: Set the BSSID mask for multiple interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    5 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   35 +++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 425c8d0..4e646fb 100644
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
index 04b1609..6bd7e25 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -144,6 +144,39 @@ static void ath9k_htc_vif_reconfig(struct ath9k_htc_priv *priv)
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
@@ -1198,6 +1231,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	ath9k_htc_set_bssid_mask(priv, vif);
+
 	priv->ah->opmode = vif->type;
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
-- 
1.7.3.5

