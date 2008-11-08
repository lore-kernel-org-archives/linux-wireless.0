Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24643 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYKHCBN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 21:01:13 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 18:01:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <yi.zhu@intel.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] iwlwifi: enable custom fw regulatory solution
Date: Fri, 7 Nov 2008 18:01:08 -0800
Message-ID: <1226109668-13778-3-git-send-email-lrodriguez@atheros.com> (sfid-20081108_030118_190090_9782F13A)
In-Reply-To: <1226109668-13778-2-git-send-email-lrodriguez@atheros.com>
References: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
 <1226109668-13778-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables the custom firmware regulatory solution option
on iwlwifi drivers. These devices are uncapable of mapping their
EEPROM regulatory domain to a specific ISO / IEC alpha2.
Although the new 11n devices (>= iwl 50000) have only
3 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
devices (3945 and 4965) have a more complex SKU arrangement
and therefore its not practical to move this to the driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8eb0203..053ac55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -879,6 +879,9 @@ int iwl_setup_mac(struct iwl_priv *priv)
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
index 7222d7c..624a884 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7839,6 +7839,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
+	hw->wiphy->fw_handles_regulatory = true;
+
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-- 
1.5.6.3

