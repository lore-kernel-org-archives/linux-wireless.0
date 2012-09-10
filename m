Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2IJROz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/6] iwlwifi: don't access the HW when it is not available
Date: Mon, 10 Sep 2012 19:15:29 +0200
Message-Id: <1347297330-23338-6-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191512_466518_3817D734)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we kill the radio with the RF kill button we could access
the HW after having stopped the APM which would result in the
warning below.

The flow goes like this:
* RF kill
	iwlwifi notifies the stack which stops the driver
	fw sends CARD_STATE_NOTIFICATION
* iwl_trans_pcie_stop_device stops the APM
* the tasklet runs and calls to iwl_rx_handle
* iwl_rx_handle calls iwl_rx_queue_restock
* iwl_rx_queue_restock tries to access the HW...

[255908.543823] ------------[ cut here ]------------
[255908.543843] WARNING: at drivers/net/wireless/iwlwifi/iwl-io.c:150 iwl_grab_nic_access+0x79/0xb0 [iwlwifi]()
[255908.543849] Hardware name: Latitude E6410
[255908.543852] Timeout waiting for hardware access (CSR_GP_CNTRL 0x000003d8)
[255908.543856] Modules linked in: iwlmvm iwlwifi mac80211 [...]
[255908.543935] Pid: 0, comm: swapper Tainted: G        W   3.1.0 #1
[255908.543939] Call Trace:
[255908.543950]  [<c1046e42>] warn_slowpath_common+0x72/0xa0
[255908.543980]  [<c1046f13>] warn_slowpath_fmt+0x33/0x40
[255908.543992]  [<fa4bb3b9>] iwl_grab_nic_access+0x79/0xb0 [iwlwifi]
[255908.544004]  [<fa4bb9eb>] iwl_write_direct32+0x2b/0xa0 [iwlwifi]
[255908.544018]  [<fa4c0ff9>] iwl_rx_queue_update_write_ptr+0x89/0x1d0 [iwlwifi]
[255908.544054]  [<fa4c1250>] iwlagn_rx_queue_restock+0x110/0x140 [iwlwifi]
[255908.544067]  [<fa4c234d>] iwl_irq_tasklet+0x82d/0xf40 [iwlwifi]
[255908.544096]  [<c104e11e>] tasklet_action+0xbe/0x100
[255908.544102]  [<c104d91e>] __do_softirq+0xae/0x1f0
[255908.544227] ---[ end trace d150f49345d85009 ]---

Prevent this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 7fc3821..6d71f51 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -203,6 +203,17 @@ static void iwl_rx_queue_restock(struct iwl_trans *trans)
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
 
+	/*
+	 * If the device isn't enabled - not need to try to add buffers...
+	 * This can happen when we stop the device and still have an interrupt
+	 * pending. We stop the APM before we sync the interrupts / tasklets
+	 * because we have to (see comment there). On the other hand, since
+	 * the APM is stopped, we cannot access the HW (in particular not prph).
+	 * So don't try to restock if the APM has been already stopped.
+	 */
+	if (!test_bit(STATUS_DEVICE_ENABLED, &trans_pcie->status))
+		return;
+
 	spin_lock_irqsave(&rxq->lock, flags);
 	while ((iwl_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		/* The overwritten rxb must be a used one */
-- 
1.7.10.4

