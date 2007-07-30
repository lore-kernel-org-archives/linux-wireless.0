Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbXG3C7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/8] iwlwifi: workaround uCode REPLY_4965_RX cmd bug
Date: Mon, 30 Jul 2007 10:57:05 +0800
Message-Id: <11857642463341-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642444000-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
 <1185764238442-git-send-email-yi.zhu@intel.com>
 <11857642401149-git-send-email-yi.zhu@intel.com>
 <11857642421391-git-send-email-yi.zhu@intel.com>
 <11857642444000-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch workarounds iwl4965 uCode bug that it doesn't set the
SEQ_RX_FRAME flag for command REPLY_4965_RX, which will trigger
a driver BUG_ON assertion.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a1dc3d9..a98ad77 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -4576,6 +4576,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
 #if IWL == 4965
 			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
+			(pkt->hdr.cmd != REPLY_4965_RX) &&
 #endif
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
-- 
1.5.2
