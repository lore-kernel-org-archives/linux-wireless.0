Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892AbZKXDaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:18 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/8] iwmc3200wifi: Set wireless mode correctly
Date: Tue, 24 Nov 2009 11:33:30 +0800
Message-Id: <1259033613-25600-6-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the wireless mode with regard to both the driver's configuration
and the device's EEPROM result.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index e61265a..92e4eaf 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -701,12 +701,12 @@ static int __iwm_up(struct iwm_priv *iwm)
 
 	/*
 	 * Read our SKU capabilities.
-	 * If it's valid, we overwrite the wireless mode conf entry and the
-	 * current profile one.
+	 * If it's valid, we AND the configured wireless mode with the
+	 * device EEPROM value as the current profile wireless mode.
 	 */
 	wireless_mode = iwm_eeprom_wireless_mode(iwm);
 	if (wireless_mode) {
-		iwm->conf.wireless_mode = wireless_mode;
+		iwm->conf.wireless_mode &= wireless_mode;
 		if (iwm->umac_profile)
 			iwm->umac_profile->wireless_mode =
 					iwm->conf.wireless_mode;
-- 
1.6.0.4

