Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935317Ab1KJPtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 20/27] iwlwifi: fix unused label in iwl_send_cmd_sync
Date: Thu, 10 Nov 2011 06:55:20 -0800
Message-Id: <1320936927-9078-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165041_956237_AB898514)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Warning introduced by c847474b7dfdda304d0d8ffcc5a9db546b1cb3e9

iwlwifi: check status before send command

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 09a31dc..a6d898b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1075,7 +1075,7 @@ cancel:
 		trans_pcie->txq[trans->shrd->cmd_queue].meta[cmd_idx].flags &=
 							~CMD_WANT_SKB;
 	}
-fail:
+
 	if (cmd->reply_page) {
 		iwl_free_pages(trans->shrd, cmd->reply_page);
 		cmd->reply_page = 0;
-- 
1.7.0.4

