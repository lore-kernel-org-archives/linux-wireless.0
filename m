Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYHDID4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler
Date: Mon,  4 Aug 2008 16:00:46 +0800
Message-Id: <1217836848-24288-9-git-send-email-yi.zhu@intel.com> (sfid-20080804_100404_471284_282DA263)
In-Reply-To: <1217836848-24288-8-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-7-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch decrements rx skb counter in scan abort handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5a00ac2..9bb6adb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -202,6 +202,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 	}
 
+	priv->alloc_rxb_skb--;
 	dev_kfree_skb_any(cmd.meta.u.skb);
 
 	return ret;
-- 
1.5.3.6

