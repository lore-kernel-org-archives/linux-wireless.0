Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42476 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbaISS22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 14:28:28 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k: request firmware flush in ath10k_flush.
Date: Fri, 19 Sep 2014 11:28:24 -0700
Message-Id: <1411151304-31544-1-git-send-email-greearb@candelatech.com> (sfid-20140919_202834_805564_047F3C2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

CT firmware now supports flushing all tids for all
peers for all vdevs.  This appears to help the ath10k_flush
logic work faster and not cause timeouts.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This requires the previously-sent patch that enables the
ATH10K_FW_FEATURE_WMI_10X_CT feature bit.  This patch provide
a nice improvement in stability and flush performance in my
testing scenarios.

 drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index af24f6c..6014856 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3830,6 +3830,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ath10k *ar = hw->priv;
 	bool skip;
 	int ret;
+	u8 peer_addr[ETH_ALEN] = {0};
 
 	/* mac80211 doesn't care if we really xmit queued frames or not
 	 * we'll collect those frames either way if we stop/delete vdevs */
@@ -3841,6 +3842,12 @@ static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (ar->state == ATH10K_STATE_WEDGED)
 		goto skip;
 
+	/* If we are CT firmware, ask it to flush all tids on all peers on
+	 * all vdevs.  Normal firmware will just crash if you do this.
+	 */
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
+		ath10k_wmi_peer_flush(ar, 0xFFFFFFFF, peer_addr, 0xFFFFFFFF);
+
 	ret = wait_event_timeout(ar->htt.empty_tx_wq, ({
 			bool empty;
 
-- 
1.7.11.7

