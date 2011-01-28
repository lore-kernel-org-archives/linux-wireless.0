Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab1A1PsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:48:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/8] iwlwifi: remove unneeded disable_hw_scan check
Date: Fri, 28 Jan 2011 16:47:48 +0100
Message-Id: <1296229671-3041-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never set STATUS_SCANNING in softwre scanning mode, disable_hw_scan
check is unneeded. Correct debug message while at it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-legacy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
index 927fe37..e1ace3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -85,10 +85,9 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
 					channel->hw_value, changed);
 
-	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
-			test_bit(STATUS_SCANNING, &priv->status))) {
+	if (unlikely(test_bit(STATUS_SCANNING, &priv->status))) {
 		scan_active = 1;
-		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
+		IWL_DEBUG_MAC80211(priv, "scan active\n");
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_SMPS |
-- 
1.7.1

