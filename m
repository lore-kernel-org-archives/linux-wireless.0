Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXI0Der (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: workaournd REPLY_COMPRESSED_BA command in iwl_rx_handle
Date: Thu, 27 Sep 2007 11:27:31 +0800
Message-Id: <11908636683204-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636662994-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9ad68b0..8ae7c30 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4613,6 +4613,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
 			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
 			(pkt->hdr.cmd != REPLY_4965_RX) &&
+			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
-- 
1.5.1
