Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYHOCEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/15] iwlwifi: allow consecutive scans in unassociated state
Date: Fri, 15 Aug 2008 10:01:10 +0800
Message-Id: <1218765680-8378-6-git-send-email-yi.zhu@intel.com> (sfid-20080815_040452_037211_CC7D5721)
In-Reply-To: <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch allows consecutive scans requests when driver is in
unassociated state.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9798883..bf855c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3206,12 +3206,14 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 	/* we don't schedule scan within next_scan_jiffies period */
 	if (priv->next_scan_jiffies &&
 	    time_after(priv->next_scan_jiffies, jiffies)) {
+		IWL_DEBUG_SCAN("scan rejected: within next scan period\n");
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
 	/* if we just finished scan ask for delay */
-	if (priv->last_scan_jiffies &&
+	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
 	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
+		IWL_DEBUG_SCAN("scan rejected: within previous scan period\n");
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
-- 
1.5.3.6

