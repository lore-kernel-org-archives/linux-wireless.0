Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZL1GXR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 01:23:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	stable@kernel.org
Subject: [PATCH] iwmc3200wifi: fix array out-of-boundary access
Date: Mon, 28 Dec 2009 14:23:11 +0800
Message-Id: <1261981391-25481-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().

Cc: stable@kernel.org
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
This is for .33 and stable.

 drivers/net/wireless/iwmc3200wifi/iwm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 79ffa3b..8428111 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -268,7 +268,7 @@ struct iwm_priv {
 
 	struct sk_buff_head rx_list;
 	struct list_head rx_tickets;
-	struct list_head rx_packets[IWM_RX_ID_HASH];
+	struct list_head rx_packets[IWM_RX_ID_HASH + 1];
 	struct workqueue_struct *rx_wq;
 	struct work_struct rx_worker;
 
-- 
1.6.3.3

