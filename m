Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYKLWWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:20 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/10] iwlwifi: enable custom fw regulatory solution
Date: Wed, 12 Nov 2008 14:22:04 -0800
Message-ID: <1226528524-32678-11-git-send-email-lrodriguez@atheros.com> (sfid-20081112_233858_008065_58ABF7DA)
In-Reply-To: <1226528524-32678-10-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-3-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-5-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-6-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-7-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-8-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-9-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables the custom firmware regulatory solution option
on iwlwifi drivers. These devices are uncapable of mapping their
EEPROM regulatory domain to a specific ISO / IEC alpha2.
Although the new 11n devices (>= iwl 5000) have only
3 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
devices (3945 and 4965) have a more complex SKU arrangement
and therefore its not practical to move this to the driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8bd4d08..fccd150 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -832,6 +832,9 @@ int iwl_setup_mac(struct iwl_priv *priv)
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
+
+	hw->wiphy->fw_handles_regulatory = true;
+
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 	/* queues to support 11n aggregation */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index dec9e04..208d88a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7861,6 +7861,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
+	hw->wiphy->fw_handles_regulatory = true;
+
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-- 
1.5.6.3

