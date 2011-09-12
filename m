Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5898 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1ILTxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 15:53:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH_3.1] iwlagn: fix command queue timeout
Date: Mon, 12 Sep 2011 12:09:10 -0700
Message-Id: <1315854550-30478-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110912_215355_065666_764B637F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the command queue is constantly busy,
which can happen in P2P, the hangcheck
timer will frequently find a command in
it and will eventually reset the device
because nothing sets the timestamp for
this queue when commands are processed.

Fix this by setting the timestamp when
a command completes.

Cc: stable@kernel.org #2.6.39, #3.0.0 #3.1.0
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
SIgned-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index c0def8e..49431ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -928,6 +928,8 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
+	txq->time_stamp = jiffies;
+
 	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
 			 DMA_BIDIRECTIONAL);
 
-- 
1.7.0.4

