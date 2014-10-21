Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51361 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbaJUQFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:05:06 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 7/8] iwlwifi: dvm: drop non VO frames when flushing
Date: Tue, 21 Oct 2014 19:04:38 +0300
Message-Id: <1413907479-9073-7-git-send-email-egrumbach@gmail.com> (sfid-20141021_180531_338103_3534662F)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When mac80211 wants to ensure that a frame is sent, it calls
the flush() callback. Until now, iwldvm implemented this by
waiting that all the frames are sent (ACKed or timeout).
In case of weak signal, this can take a significant amount
of time, delaying the next connection (in case of roaming).
Many users have reported that the flush would take too long
leading to the following error messages to be printed:

iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
iwlwifi 0000:03:00.0: Current SW read_ptr 161 write_ptr 201
iwl data: 00000000: 00 00 00 00 00 00 00 00 fe ff 01 00 00 00 00 00
[snip]
iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[snip]
iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [9,9]
[snip]

Instead of waiting for these packets, simply drop them. This
significantly improves the responsiveness of the network.
Note that all the queues are flushed, but the VO one. This
is not typically used by the applications and it likely
contains management frames that are useful for connection
or roaming.

This bug is tracked here:
https://bugzilla.kernel.org/show_bug.cgi?id=56581

But it is duplicated in distributions' trackers.
A simple search in Ubuntu's database led to these bugs:

https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/1270808
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1305406
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1356236
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1360597
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1361809

Cc: <stable@vger.kernel.org>
Depends-on: 77be2c54c5bd ("mac80211: add vif to flush call")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 2364a3c..cae692f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1095,6 +1095,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     u32 queues, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	u32 scd_queues;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -1108,18 +1109,19 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto done;
 	}
 
-	/*
-	 * mac80211 will not push any more frames for transmit
-	 * until the flush is completed
-	 */
-	if (drop) {
-		IWL_DEBUG_MAC80211(priv, "send flush command\n");
-		if (iwlagn_txfifo_flush(priv, 0)) {
-			IWL_ERR(priv, "flush request fail\n");
-			goto done;
-		}
+	scd_queues = BIT(priv->cfg->base_params->num_of_queues) - 1;
+	scd_queues &= ~(BIT(IWL_IPAN_CMD_QUEUE_NUM) |
+			BIT(IWL_DEFAULT_CMD_QUEUE_NUM));
+
+	if (vif)
+		scd_queues &= ~BIT(vif->hw_queue[IEEE80211_AC_VO]);
+
+	IWL_DEBUG_TX_QUEUES(priv, "Flushing SCD queues: 0x%x\n", scd_queues);
+	if (iwlagn_txfifo_flush(priv, scd_queues)) {
+		IWL_ERR(priv, "flush request fail\n");
+		goto done;
 	}
-	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
+	IWL_DEBUG_TX_QUEUES(priv, "wait transmit/flush all frames\n");
 	iwl_trans_wait_tx_queue_empty(priv->trans, 0xffffffff);
 done:
 	mutex_unlock(&priv->mutex);
-- 
1.9.1

