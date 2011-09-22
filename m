Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1IVPCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:02:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: remove warning in iwl_rx_handle
Date: Thu, 22 Sep 2011 07:15:36 -0700
Message-Id: <1316700937-22240-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110922_170217_317817_4C9C1F41)
In-Reply-To: <1316700937-22240-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316700937-22240-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Txid was used without being initialized.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 3ef9eac..b4eff55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -401,7 +401,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 	while (i != r) {
 		int len, err;
-		u16 txq_id, sequence;
+		u16 sequence;
 
 		rxb = rxq->queue[i];
 
@@ -452,8 +452,11 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 		/* warn if this is cmd response / notification and the uCode
 		 * didn't set the SEQ_RX_FRAME for a frame that is
-		 * uCode-originated*/
-		WARN(txq_id == trans->shrd->cmd_queue && reclaim == false &&
+		 * uCode-originated
+		 * If you saw this code after the second half of 2012, then
+		 * please remove it
+		 */
+		WARN(pkt->hdr.cmd != REPLY_TX && reclaim == false &&
 		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
 		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
 		     get_cmd_string(pkt->hdr.cmd));
-- 
1.7.0.4

