Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbZLNWMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 3/6] iwl3945: disable power save
Date: Mon, 14 Dec 2009 14:12:10 -0800
Message-Id: <1260828733-22726-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
References: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

we see from http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2125
that power saving does not work well on 3945. Since then power saving has
also been connected with association problems where an AP deathenticates a
3945 after it is unable to transmit data to it - this happens when 3945
enters power savings mode.

Disable power save support until issues are resolved.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
This fix is needed in 2.6.32 but does not apply in this form.
A rebased version will be provided after this
patch has been merged into 2.6.33.

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4609323..e413bd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2835,6 +2835,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
+	.broken_powersave = true,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2851,6 +2852,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
+	.broken_powersave = true,
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4c0e475..c322d6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3932,9 +3932,11 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+		    IEEE80211_HW_SPECTRUM_MGMT;
+
+	if (!priv->cfg->broken_powersave)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-- 
1.5.6.3

