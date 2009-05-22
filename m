Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbZEVRzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/10] iwlcore: Set rb_timeout to 0x10 for devices with ICT
Date: Fri, 22 May 2009 11:01:53 -0700
Message-Id: <1243015315-13848-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-8-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

 rb value should be 0x10 for devices using ICT.
 RX interrupt was not performing well with
 0 value

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c845089..2b8d40b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -412,7 +412,10 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
-	const u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT why this stalls RX */
+	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
+
+	if (!priv->cfg->use_isr_legacy)
+		rb_timeout = RX_RB_TIMEOUT;
 
 	if (priv->cfg->mod_params->amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-- 
1.5.6.3

