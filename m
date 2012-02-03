Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab2BCNaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 08:30:14 -0500
Date: Fri, 3 Feb 2012 14:30:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/25 v2] iwlegacy: remove ctx interface_modes
Message-ID: <20120203133003.GB2213@redhat.com> (sfid-20120203_143018_631618_67330C2F)
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
 <1328270845-16891-15-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328270845-16891-15-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2 does not contain rt2x00 changes
  
 drivers/net/wireless/iwlegacy/3945-mac.c |    6 ++----
 drivers/net/wireless/iwlegacy/4965-mac.c |    6 ++----
 drivers/net/wireless/iwlegacy/common.c   |   29 ++++-------------------------
 drivers/net/wireless/iwlegacy/common.h   |    2 --
 4 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 52cac0c..7c81f5a 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3557,7 +3557,8 @@ il3945_setup_mac(struct il_priv *il)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SPECTRUM_MGMT;
 
-	hw->wiphy->interface_modes = il->ctx.interface_modes;
+	hw->wiphy->interface_modes =
+	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |=
 	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS |
@@ -3617,9 +3618,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->cmd_queue = IL39_CMD_QUEUE_NUM;
 
-	il->ctx.interface_modes =
-	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
-
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan.
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 35d868c..1dd0014 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5454,8 +5454,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->sta_data_size = sizeof(struct il_station_priv);
 	hw->vif_data_size = sizeof(struct il_vif_priv);
 
-	hw->wiphy->interface_modes |= il->ctx.interface_modes;
-	hw->wiphy->interface_modes |= il->ctx.exclusive_interface_modes;
+	hw->wiphy->interface_modes =
+	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->flags |=
 	    WIPHY_FLAG_CUSTOM_REGULATORY | WIPHY_FLAG_DISABLE_BEACON_HINTS;
@@ -6141,8 +6141,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->ctx.is_active = true;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
-	il->ctx.exclusive_interface_modes = BIT(NL80211_IFTYPE_ADHOC);
-	il->ctx.interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index ac26985..7f4c6bf 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4566,7 +4566,6 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct il_priv *il = hw->priv;
 	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int err;
-	u32 modes;
 
 	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
 
@@ -4578,15 +4577,7 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	/* check if busy context is exclusive */
-	if (il->ctx.vif &&
-	    (il->ctx.exclusive_interface_modes & BIT(il->ctx.vif->type))) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	modes = il->ctx.interface_modes | il->ctx.exclusive_interface_modes;
-	if (!(modes & BIT(vif->type))) {
+	if (il->ctx.vif) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4979,10 +4970,10 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct il_priv *il = hw->priv;
 	struct il_rxon_context *ctx = il_rxon_ctx_from_vif(vif);
-	u32 modes;
 	int err;
 
-	newtype = ieee80211_iftype_p2p(newtype, newp2p);
+	if (newp2p)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&il->mutex);
 
@@ -4995,22 +4986,10 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
-	modes = ctx->interface_modes | ctx->exclusive_interface_modes;
-	if (!(modes & BIT(newtype))) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if ((il->ctx.exclusive_interface_modes & BIT(il->ctx.vif->type)) ||
-	    (il->ctx.exclusive_interface_modes & BIT(newtype))) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	/* success */
 	il_teardown_interface(il, vif, true);
 	vif->type = newtype;
-	vif->p2p = newp2p;
+	vif->p2p = false;
 	err = il_setup_interface(il, ctx);
 	WARN_ON(err);
 	/*
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index a872175..eddf22d 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1165,8 +1165,6 @@ struct il_rxon_context {
 	 */
 	bool always_active, is_active;
 
-	u32 interface_modes, exclusive_interface_modes;
-
 	struct il_qos_info qos_data;
 
 	struct {
-- 
1.7.1

