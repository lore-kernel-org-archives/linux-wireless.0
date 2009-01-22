Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42520 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803AbZAVXGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:48 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] cfg80211: rename fw_handles_regulatory to custom_regulatory
Date: Thu, 22 Jan 2009 15:05:49 -0800
Message-ID: <1232665554-26132-8-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000706_369623_A61FA643)
In-Reply-To: <1232665554-26132-7-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers without firmware can also have custom regulatory maps
which do not map to a specific ISO / IEC alpha2 country code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 include/net/wireless.h                      |    6 +++---
 net/wireless/reg.c                          |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d2ef3e1..1d568ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -811,7 +811,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->fw_handles_regulatory = true;
+	hw->wiphy->custom_regulatory = true;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c9f6f8e..b48ee3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7039,7 +7039,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
-	hw->wiphy->fw_handles_regulatory = true;
+	hw->wiphy->custom_regulatory = true;
 
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
diff --git a/include/net/wireless.h b/include/net/wireless.h
index a8971f6..438cba9 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -181,8 +181,8 @@ struct ieee80211_supported_band {
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
- * @fw_handles_regulatory: tells us the firmware for this device
- * 	has its own regulatory solution and cannot identify the
+ * @custom_regulatory: tells us the driver for this device
+ * 	has its own custom regulatory domain and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
  * 	we will disregard the first regulatory hint (when the
  * 	initiator is %REGDOM_SET_BY_CORE).
@@ -201,7 +201,7 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
-	bool fw_handles_regulatory;
+	bool custom_regulatory;
 
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 421c5b3..2a94dc0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -935,7 +935,7 @@ static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 	if (!last_request)
 		return true;
 	if (setby == REGDOM_SET_BY_CORE &&
-		  wiphy->fw_handles_regulatory)
+		  wiphy->custom_regulatory)
 		return true;
 	return false;
 }
-- 
1.6.1.rc3.51.g5832d

