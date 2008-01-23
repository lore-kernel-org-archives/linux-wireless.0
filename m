Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYAWSPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: initialize geo/channel information during probe
Date: Wed, 23 Jan 2008 10:15:18 -0800
Message-Id: <1201112121-22340-4-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181531_112741_57EC1093)
In-Reply-To: <1201112121-22340-3-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The geo/channel information is obtained from the EEPROM, which is read
during probe. We can thus set up channel information at this time. This
helps us to support ioctl commands that rely on this before the interface
is brought up.

Clearly matches _init_channel_map with _free_channel_map and _init_geos
with _free_geos to ensure functions calling these routines can also call
their cleanup routines.

Fixes a few bugs:
- if channel information is not available when ioctl commands are
  issued then we get a NULL pointer oops. Having channel information
  set up during probe we can deal with ioctl commands without requiring
  interface to be brought up.
  This fixes bug: http://www.bughost.org/bugzilla/show_bug.cgi?id=1552
- Fix potential problem if user triggers probe/remove/probe sequence. The
  value of priv->channel_count was used to determine if channel map is
  set up. This value was never reset when channel map was removed.
- Fix memory leak: priv->modes need to be freed when device removed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   54 ++++++++++++++++++++-------
 2 files changed, 80 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c9f2ce5..5afc578 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5146,6 +5146,15 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 	return 0;
 }
 
+/*
+ * iwl3945_free_channel_map - undo allocations in iwl3945_init_channel_map
+ */
+static void iwl3945_free_channel_map(struct iwl3945_priv *priv)
+{
+	kfree(priv->channel_info);
+	priv->channel_count = 0;
+}
+
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
  * from more than one AP.  */
@@ -5471,6 +5480,17 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 	return 0;
 }
 
+/*
+ * iwl3945_free_geos - undo allocations in iwl3945_init_geos
+ */
+static void iwl3945_free_geos(struct iwl3945_priv *priv)
+{
+	kfree(priv->modes);
+	kfree(priv->ieee_channels);
+	kfree(priv->ieee_rates);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
+}
+
 /******************************************************************************
  *
  * uCode download functions
@@ -6130,15 +6150,6 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	/* Clear out the uCode error bit if it is set */
 	clear_bit(STATUS_FW_ERROR, &priv->status);
 
-	rc = iwl3945_init_channel_map(priv);
-	if (rc) {
-		IWL_ERROR("initializing regulatory failed: %d\n", rc);
-		return;
-	}
-
-	iwl3945_init_geos(priv);
-	iwl3945_reset_channel_flag(priv);
-
 	if (iwl3945_is_rfkill(priv))
 		return;
 
@@ -8614,11 +8625,24 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
+	err = iwl3945_init_channel_map(priv);
+	if (err) {
+		IWL_ERROR("initializing regulatory failed: %d\n", err);
+		goto out_remove_sysfs;
+	}
+
+	err = iwl3945_init_geos(priv);
+	if (err) {
+		IWL_ERROR("initializing geos failed: %d\n", err);
+		goto out_free_channel_map;
+	}
+	iwl3945_reset_channel_flag(priv);
+
 	iwl3945_rate_control_register(priv->hw);
 	err = ieee80211_register_hw(priv->hw);
 	if (err) {
 		IWL_ERROR("Failed to register network device (error %d)\n", err);
-		goto out_remove_sysfs;
+		goto out_free_geos;
 	}
 
 	priv->hw->conf.beacon_int = 100;
@@ -8628,6 +8652,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	return 0;
 
+ out_free_geos:
+	iwl3945_free_geos(priv);
+ out_free_channel_map:
+	iwl3945_free_channel_map(priv);
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
@@ -8702,10 +8730,8 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	kfree(priv->channel_info);
-
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
+	iwl3945_free_channel_map(priv);
+	iwl3945_free_geos(priv);
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 13fe5a1..bb2d4f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5576,6 +5576,15 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 	return 0;
 }
 
+/*
+ * iwl4965_free_channel_map - undo allocations in iwl4965_init_channel_map
+ */
+static void iwl4965_free_channel_map(struct iwl4965_priv *priv)
+{
+	kfree(priv->channel_info);
+	priv->channel_count = 0;
+}
+
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
  * from more than one AP.  */
@@ -5909,6 +5918,17 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	return 0;
 }
 
+/*
+ * iwl4965_free_geos - undo allocations in iwl4965_init_geos
+ */
+static void iwl4965_free_geos(struct iwl4965_priv *priv)
+{
+	kfree(priv->modes);
+	kfree(priv->ieee_channels);
+	kfree(priv->ieee_rates);
+	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
+}
+
 /******************************************************************************
  *
  * uCode download functions
@@ -6560,15 +6580,6 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	/* Clear out the uCode error bit if it is set */
 	clear_bit(STATUS_FW_ERROR, &priv->status);
 
-	rc = iwl4965_init_channel_map(priv);
-	if (rc) {
-		IWL_ERROR("initializing regulatory failed: %d\n", rc);
-		return;
-	}
-
-	iwl4965_init_geos(priv);
-	iwl4965_reset_channel_flag(priv);
-
 	if (iwl4965_is_rfkill(priv))
 		return;
 
@@ -9198,11 +9209,24 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
+	err = iwl4965_init_channel_map(priv);
+	if (err) {
+		IWL_ERROR("initializing regulatory failed: %d\n", err);
+		goto out_remove_sysfs;
+	}
+
+	err = iwl4965_init_geos(priv);
+	if (err) {
+		IWL_ERROR("initializing geos failed: %d\n", err);
+		goto out_free_channel_map;
+	}
+	iwl4965_reset_channel_flag(priv);
+
 	iwl4965_rate_control_register(priv->hw);
 	err = ieee80211_register_hw(priv->hw);
 	if (err) {
 		IWL_ERROR("Failed to register network device (error %d)\n", err);
-		goto out_remove_sysfs;
+		goto out_free_geos;
 	}
 
 	priv->hw->conf.beacon_int = 100;
@@ -9212,6 +9236,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	return 0;
 
+ out_free_geos:
+	iwl4965_free_geos(priv);
+ out_free_channel_map:
+	iwl4965_free_channel_map(priv);
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 
@@ -9286,10 +9314,8 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	kfree(priv->channel_info);
-
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
+	iwl4965_free_channel_map(priv);
+	iwl4965_free_geos(priv);
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
-- 
1.5.3.4

