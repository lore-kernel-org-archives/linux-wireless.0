Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32286 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbZLADp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 22:45:29 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] iwmc3200wifi: fix NULL pointer dereference in pmkid update
Date: Tue,  1 Dec 2009 11:48:50 +0800
Message-Id: <1259639330-8291-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handling IWM_CMD_PMKID_FLUSH command, the bssid and
pmkid in pmksa are all NULL. Check it before memcpy.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index bd06307..89b33fa 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -970,8 +970,10 @@ int iwm_send_pmkid_update(struct iwm_priv *iwm,
 	memset(&update, 0, sizeof(struct iwm_umac_pmkid_update));
 
 	update.command = cpu_to_le32(command);
-	memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
-	memcpy(&update.pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+	if (pmksa->bssid)
+		memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
+	if (pmksa->pmkid)
+		memcpy(&update.pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
 
 	ret = iwm_send_wifi_if_cmd(iwm, &update,
 				   sizeof(struct iwm_umac_pmkid_update), 0);
-- 
1.6.0.4

