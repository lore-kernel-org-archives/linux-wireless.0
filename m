Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934209Ab1IOTcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/27] iwlagn: warn about buggy fw that doesn't set SEQ_RX_FRAME
Date: Thu, 15 Sep 2011 11:46:28 -0700
Message-Id: <1316112414-6341-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213325_113619_C2A36007)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The way we check if there is host command that should be reclaimed is
way too complicated. We should have a clear indication from the fw.
The fw is expected to set the SEQ_RX_FRAME bit if the frame was
originated by the fw which indicates to the driver that there is no
host command to free.
Somehow, there seem to have been buggy fw out there, hence the very
old comment.

This code checks if we have still buggy fw out there.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 126e5a4..2308177 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -398,6 +398,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 	while (i != r) {
 		int len;
+		u16 txq_id, sequence;
 
 		rxb = rxq->queue[i];
 
@@ -437,6 +438,17 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
 
+		sequence = le16_to_cpu(pkt->hdr.sequence);
+		txq_id = SEQ_TO_QUEUE(le16_to_cpu(pkt->hdr.sequence));
+
+		/* warn if this is cmd response / notification and the uCode
+		 * didn't set the SEQ_RX_FRAME for a frame that is
+		 * uCode-originated*/
+		WARN(txq_id == trans->shrd->cmd_queue && reclaim == false &&
+		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
+		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
+		     get_cmd_string(pkt->hdr.cmd));
+
 		iwl_rx_dispatch(priv(trans), rxb);
 
 		/*
-- 
1.7.0.4

