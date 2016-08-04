Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48447 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647AbcHDNp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 09:45:27 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <mkenna@codeaurora.org>,
	"Maharaja Kennadyrajan" <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: hide kernel addresses from logs using %pK format specifier
Date: Thu, 4 Aug 2016 19:21:51 +0530
Message-ID: <1470318711-28986-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20160804_154532_645561_0D26B658)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

With the %pK format specifier we hide the kernel addresses
with the help of kptr_restrict sysctl.
In this patch, %p is changed to %pK in the driver code.

The sysctl is documented in Documentation/sysctl/kernel.txt.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c      |    2 +-
 drivers/net/wireless/ath/ath10k/bmi.c      |    4 ++--
 drivers/net/wireless/ath/ath10k/ce.c       |    4 ++--
 drivers/net/wireless/ath/ath10k/core.c     |    4 ++--
 drivers/net/wireless/ath/ath10k/htc.c      |    6 +++---
 drivers/net/wireless/ath/ath10k/htt_rx.c   |    2 +-
 drivers/net/wireless/ath/ath10k/mac.c      |   20 ++++++++++----------
 drivers/net/wireless/ath/ath10k/pci.c      |    2 +-
 drivers/net/wireless/ath/ath10k/testmode.c |    4 ++--
 drivers/net/wireless/ath/ath10k/txrx.c     |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c      |    4 ++--
 11 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index acec16b..dede026 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -577,7 +577,7 @@ static int ath10k_ahb_resource_init(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "irq: %d\n", ar_ahb->irq);
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "mem: 0x%p mem_len: %lu gcc mem: 0x%p tcsr_mem: 0x%p\n",
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "mem: 0x%pK mem_len: %lu gcc mem: 0x%pK tcsr_mem: 0x%pK\n",
 		   ar_ahb->mem, ar_ahb->mem_len,
 		   ar_ahb->gcc_mem, ar_ahb->tcsr_mem);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index 3d29b08..2872d34 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -221,7 +221,7 @@ int ath10k_bmi_lz_data(struct ath10k *ar, const void *buffer, u32 length)
 	u32 txlen;
 	int ret;
 
-	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz data buffer 0x%p length %d\n",
+	ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi lz data buffer 0x%pK length %d\n",
 		   buffer, length);
 
 	if (ar->bmi.done_sent) {
@@ -287,7 +287,7 @@ int ath10k_bmi_fast_download(struct ath10k *ar,
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BMI,
-		   "bmi fast download address 0x%x buffer 0x%p length %d\n",
+		   "bmi fast download address 0x%x buffer 0x%pK length %d\n",
 		   address, buffer, length);
 
 	ret = ath10k_bmi_lz_stream_start(ar, address);
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 9fb8d74..65d8d71 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -840,7 +840,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot init ce src ring id %d entries %d base_addr %p\n",
+		   "boot init ce src ring id %d entries %d base_addr %pK\n",
 		   ce_id, nentries, src_ring->base_addr_owner_space);
 
 	return 0;
@@ -874,7 +874,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot ce dest ring id %d entries %d base_addr %p\n",
+		   "boot ce dest ring id %d entries %d base_addr %pK\n",
 		   ce_id, nentries, dest_ring->base_addr_owner_space);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e889829..ffcf6b8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -699,7 +699,7 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	if (!ar->running_fw->fw_file.otp_data ||
 	    !ar->running_fw->fw_file.otp_len) {
-		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
+		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %pK otp_len %zd)!\n",
 			    ar->running_fw->fw_file.otp_data,
 			    ar->running_fw->fw_file.otp_len);
 		return 0;
@@ -753,7 +753,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot uploading firmware image %p len %d\n",
+		   "boot uploading firmware image %pK len %d\n",
 		   data, data_len);
 
 	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 5b3c6bc..175aae3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -44,7 +44,7 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 	skb_cb = ATH10K_SKB_CB(skb);
 	memset(skb_cb, 0, sizeof(*skb_cb));
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: skb %p\n", __func__, skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: skb %pK\n", __func__, skb);
 	return skb;
 }
 
@@ -62,7 +62,7 @@ static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 {
 	struct ath10k *ar = ep->htc->ar;
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %p\n", __func__,
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %pK\n", __func__,
 		   ep->eid, skb);
 
 	ath10k_htc_restore_tx_skb(ep->htc, skb);
@@ -404,7 +404,7 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		goto out;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %p\n",
+	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %pK\n",
 		   eid, skb);
 	ep->ep_ops.ep_rx_complete(ar, skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 78db5d6..ae6931b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -931,7 +931,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	*status = *rx_status;
 
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
-		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
 		   ieee80211_get_SA(hdr),
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb8e38d..fe3b1d9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -824,7 +824,7 @@ static void ath10k_peer_cleanup(struct ath10k *ar, u32 vdev_id)
 		 */
 		for (i = 0; i < ARRAY_SIZE(ar->peer_map); i++) {
 			if (ar->peer_map[i] == peer) {
-				ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %p idx %d)\n",
+				ath10k_warn(ar, "removing stale peer_map entry for %pM (ptr %pK idx %d)\n",
 					    peer->addr, peer, i);
 				ar->peer_map[i] = NULL;
 			}
@@ -3524,7 +3524,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		if (!ath10k_mac_tx_frm_has_freq(ar)) {
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %p\n",
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "queued offchannel skb %pK\n",
 				   skb);
 
 			skb_queue_tail(&ar->offchan_tx_queue, skb);
@@ -3586,7 +3586,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %p\n",
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac offchannel skb %pK\n",
 			   skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -3643,7 +3643,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		time_left =
 		wait_for_completion_timeout(&ar->offchan_tx_completed, 3 * HZ);
 		if (time_left == 0)
-			ath10k_warn(ar, "timed out waiting for offchannel skb %p\n",
+			ath10k_warn(ar, "timed out waiting for offchannel skb %pK\n",
 				    skb);
 
 		if (!peer && tmp_peer_created) {
@@ -6001,7 +6001,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				continue;
 
 			if (peer->sta == sta) {
-				ath10k_warn(ar, "found sta peer %pM (ptr %p id %d) entry on vdev %i after it was supposedly removed\n",
+				ath10k_warn(ar, "found sta peer %pM (ptr %pK id %d) entry on vdev %i after it was supposedly removed\n",
 					    sta->addr, peer, i, arvif->vdev_id);
 				peer->sta = NULL;
 
@@ -7134,7 +7134,7 @@ ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx add freq %hu width %d ptr %p\n",
+		   "mac chanctx add freq %hu width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -7158,7 +7158,7 @@ ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx remove freq %hu width %d ptr %p\n",
+		   "mac chanctx remove freq %hu width %d ptr %pK\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx);
 
 	mutex_lock(&ar->conf_mutex);
@@ -7223,7 +7223,7 @@ ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx change freq %hu width %d ptr %p changed %x\n",
+		   "mac chanctx change freq %hu width %d ptr %pK changed %x\n",
 		   ctx->def.chan->center_freq, ctx->def.width, ctx, changed);
 
 	/* This shouldn't really happen because channel switching should use
@@ -7281,7 +7281,7 @@ ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx assign ptr %p vdev_id %i\n",
+		   "mac chanctx assign ptr %pK vdev_id %i\n",
 		   ctx, arvif->vdev_id);
 
 	if (WARN_ON(arvif->is_started)) {
@@ -7342,7 +7342,7 @@ ath10k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac chanctx unassign ptr %p vdev_id %i\n",
+		   "mac chanctx unassign ptr %pK vdev_id %i\n",
 		   ctx, arvif->vdev_id);
 
 	WARN_ON(!arvif->is_started);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9a22c47..1b841ad 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3062,7 +3062,7 @@ static int ath10k_pci_claim(struct ath10k *ar)
 		goto err_master;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot pci_mem 0x%pK\n", ar_pci->mem);
 	return 0;
 
 err_master:
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 120f423..52298c3 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -45,7 +45,7 @@ bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb)
 	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-		   "testmode event wmi cmd_id %d skb %p skb->len %d\n",
+		   "testmode event wmi cmd_id %d skb %pK skb->len %d\n",
 		   cmd_id, skb, skb->len);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", skb->data, skb->len);
@@ -360,7 +360,7 @@ static int ath10k_tm_cmd_wmi(struct ath10k *ar, struct nlattr *tb[])
 	cmd_id = nla_get_u32(tb[ATH10K_TM_ATTR_WMI_CMDID]);
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-		   "testmode cmd wmi cmd_id %d buf %p buf_len %d\n",
+		   "testmode cmd wmi cmd_id %d buf %pK buf_len %d\n",
 		   cmd_id, buf, buf_len);
 
 	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", buf, buf_len);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index b29a86a..1e695d1 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -44,7 +44,7 @@ static void ath10k_report_offchan_tx(struct ath10k *ar, struct sk_buff *skb)
 	complete(&ar->offchan_tx_completed);
 	ar->offchan_tx_skb = NULL; /* just for sanity */
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "completed offchannel skb %p\n", skb);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "completed offchannel skb %pK\n", skb);
 out:
 	spin_unlock_bh(&ar->data_lock);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 169cd2e7..bb080d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1874,7 +1874,7 @@ ath10k_wmi_op_gen_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 	ether_addr_copy(cmd->hdr.peer_macaddr.addr, ieee80211_get_DA(hdr));
 	memcpy(cmd->buf, msdu->data, msdu->len);
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %pK len %d ftype %02x stype %02x\n",
 		   msdu, skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
 	trace_ath10k_tx_hdr(ar, skb->data, skb->len);
@@ -2347,7 +2347,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_mac_handle_beacon(ar, skb);
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
-		   "event mgmt rx skb %p len %d ftype %02x stype %02x\n",
+		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
 		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE);
 
-- 
1.7.9.5

