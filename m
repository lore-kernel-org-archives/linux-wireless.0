Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbYICDbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:02 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/39] iwlwifi: allow consecutive scans in unassociated state
Date: Wed,  3 Sep 2008 11:26:25 +0800
Message-Id: <1220412419-15404-6-git-send-email-yi.zhu@intel.com> (sfid-20080903_053107_134882_91788B65)
In-Reply-To: <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
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
index 1073fa0..08ca2a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3205,12 +3205,14 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
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

