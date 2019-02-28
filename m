Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03667C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF692184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="DstmsSw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbfB1P62 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:58:28 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:59880 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732388AbfB1P62 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 10:58:28 -0500
Received: from ben-dt4.candelatech.com (firewall.candelatech.com [50.251.239.81])
        by mail2.candelatech.com (Postfix) with ESMTP id B778140A959;
        Thu, 28 Feb 2019 07:58:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com B778140A959
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1551369505;
        bh=4tvZN3qZ4F36kWPG1qijRWIf/Ey7Do5nXSh44HvMrzc=;
        h=From:To:Cc:Subject:Date:From;
        b=DstmsSw84jQK5waNOPQxrJ16B5X3UxgbMY9KUBup2pUEMOmsrU+nutiCQ59edJ8Oo
         STDQzOVA9cUGiUNhDCggRB44dScVCpwVrX6yH6QKcVdtVsysuNGJf0hdL2yDydOzDG
         T2YZ0M/5l4zjoQ1LSOcQTAVdUwrWZaBq79zKw9/U=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath10k:  Fix DMA errors related to beacons (CT FW only)
Date:   Thu, 28 Feb 2019 07:58:23 -0800
Message-Id: <20190228155823.24749-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

I often saw the ath10k-ct wave-1 firmware spit DMA errors and
hang the entire system, requiring a hard power-cycle to revoer.

It appears the issue is that there is no beacon-tx callback in
stock firmware, so the driver can delete the beacon DMA buffer
while firmware is still trying to access it.

So, wave-1 ath10k-ct firmware now sends a beacon-tx-complete
wmi message and that allows the driver to safely know when it
can clean up the buffer.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This will not apply or work in upstream kernels since the
rest of the CT fw support will not be accepted.  But, I'd appreciate
any technical feedback on this in case I missed any corner cases
on locking or similar.

 drivers/net/wireless/ath/ath10k/core.c    |  1 +
 drivers/net/wireless/ath/ath10k/core.h    |  6 ++++
 drivers/net/wireless/ath/ath10k/mac.c     | 14 +++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 12 +++++--
 drivers/net/wireless/ath/ath10k/wmi.c     | 38 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h     |  8 +++++
 6 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e6664131fdee..929e0c059adc 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -623,6 +623,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_RETRY_GT2_CT] = "retry-gt2-CT",
 	[ATH10K_FW_FEATURE_CT_STA] = "CT-STA",
 	[ATH10K_FW_FEATURE_TXRATE2_CT] = "txrate2-CT",
+	[ATH10K_FW_FEATURE_BEACON_TX_CB_CT] = "beacon-cb-CT",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 15621a2af557..a70771170007 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -563,6 +563,7 @@ enum ath10k_beacon_state {
 
 struct ath10k_vif {
 	struct list_head list;
+	struct completion beacon_tx_done;
 
 	u32 vdev_id;
 	u16 peer_id;
@@ -944,6 +945,11 @@ enum ath10k_fw_features {
 	/* TX-Rate v2 is reported. */
 	ATH10K_FW_FEATURE_TXRATE2_CT = 49,
 
+	/* Firmware will send a beacon-tx-callback message so driver knows when
+	 * beacon buffer can be released.
+	 */
+	ATH10K_FW_FEATURE_BEACON_TX_CB_CT = 50,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 154dcdabc48a..02a8efa2e783 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5811,6 +5811,10 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->ar = ar;
 	arvif->vif = vif;
 
+	init_completion(&arvif->beacon_tx_done);
+	/* start completed since we have not sent any beacons yet */
+	complete(&arvif->beacon_tx_done);
+
 	INIT_LIST_HEAD(&arvif->list);
 	INIT_WORK(&arvif->ap_csa_work, ath10k_mac_vif_ap_csa_work);
 	INIT_DELAYED_WORK(&arvif->connection_loss_work,
@@ -6147,6 +6151,16 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "failed to stop spectral for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
+	if (test_bit(ATH10K_FW_FEATURE_BEACON_TX_CB_CT,
+		      ar->running_fw->fw_file.fw_features)) {
+		int time_left;
+
+		time_left = wait_for_completion_timeout(&arvif->beacon_tx_done, (3 * HZ));
+		if (!time_left)
+			ath10k_warn(ar, "WARNING: failed to wait for beacon tx callback for vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+	}
+
 	ar->free_vdev_map |= 1LL << arvif->vdev_id;
 	spin_lock_bh(&ar->data_lock);
 	list_del(&arvif->list);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 6c6f7db5b20b..dcba53575dfc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -1000,25 +1000,33 @@ ath10k_wmi_peer_assoc(struct ath10k *ar,
 }
 
 static inline int
-ath10k_wmi_beacon_send_ref_nowait(struct ath10k *ar, u32 vdev_id,
+ath10k_wmi_beacon_send_ref_nowait(struct ath10k_vif *arvif,
 				  const void *bcn, size_t bcn_len,
 				  u32 bcn_paddr, bool dtim_zero,
 				  bool deliver_cab)
 {
 	struct sk_buff *skb;
 	int ret;
+	struct ath10k *ar = arvif->ar;
 
 	if (!ar->wmi.ops->gen_beacon_dma)
 		return -EOPNOTSUPP;
 
-	skb = ar->wmi.ops->gen_beacon_dma(ar, vdev_id, bcn, bcn_len, bcn_paddr,
+	skb = ar->wmi.ops->gen_beacon_dma(ar, arvif->vdev_id, bcn, bcn_len, bcn_paddr,
 					  dtim_zero, deliver_cab);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
+	spin_lock_bh(&ar->data_lock);
+	reinit_completion(&arvif->beacon_tx_done);
+	spin_unlock_bh(&ar->data_lock);
+	
 	ret = ath10k_wmi_cmd_send_nowait(ar, skb,
 					 ar->wmi.cmd->pdev_send_bcn_cmdid);
 	if (ret) {
+		spin_lock_bh(&ar->data_lock);
+		complete(&arvif->beacon_tx_done);
+		spin_unlock_bh(&ar->data_lock);
 		dev_kfree_skb(skb);
 		return ret;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5d89482ffca8..6e9705d3a967 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1846,8 +1846,7 @@ static void ath10k_wmi_tx_beacon_nowait(struct ath10k_vif *arvif)
 
 		dtim_zero = !!(cb->flags & ATH10K_SKB_F_DTIM_ZERO);
 		deliver_cab = !!(cb->flags & ATH10K_SKB_F_DELIVER_CAB);
-		ret = ath10k_wmi_beacon_send_ref_nowait(arvif->ar,
-							arvif->vdev_id,
+		ret = ath10k_wmi_beacon_send_ref_nowait(arvif,
 							bcn->data, bcn->len,
 							cb->paddr,
 							dtim_zero,
@@ -5941,6 +5940,38 @@ static int ath10k_wmi_event_temperature(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+static void ath10k_wmi_event_beacon_tx(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct ath10k_vif *arvif;
+	const struct wmi_beacon_tx_event *ev;
+	u32 vdev_id;
+
+	spin_lock_bh(&ar->data_lock);
+
+	ev = (struct wmi_beacon_tx_event *)skb->data;
+
+	if (WARN_ON_ONCE(skb->len < sizeof(*ev)))
+		goto exit;
+
+	vdev_id = __le32_to_cpu(ev->vdev_id);
+
+	/*ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi event beacon-tx-complete, vdev-id: %u  completion-status: 0x%x\n",
+		   vdev_id, __le32_to_cpu(ev->tx_status));*/
+
+	arvif = ath10k_get_arvif(ar, vdev_id);
+	if (!arvif) {
+		ath10k_warn(ar, "wmi-event-beacon-tx, could not find vdev for id: %u\n",
+			    vdev_id);
+		goto exit;
+	}
+
+	complete(&arvif->beacon_tx_done);
+
+exit:
+	spin_unlock_bh(&ar->data_lock);
+}
+
 static int ath10k_wmi_event_pdev_bss_chan_info(struct ath10k *ar,
 					       struct sk_buff *skb)
 {
@@ -6269,6 +6300,9 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_1_PDEV_BSS_CHAN_INFO_EVENTID: /* Newer CT firmware supports this */
 		ath10k_wmi_event_pdev_bss_chan_info(ar, skb);
 		break;
+	case WMI_10_1_BEACON_TX_EVENTID: /* Feb 28, 2019 CT firmware supports this */
+		ath10k_wmi_event_beacon_tx(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown (10.1) eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 49466123b8fe..96066cc57f83 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1533,6 +1533,7 @@ enum wmi_10x_event_id {
 
 	WMI_10_1_PDEV_TEMPERATURE_EVENTID = 36898, /* Newer CT firmware */
 	WMI_10_1_PDEV_BSS_CHAN_INFO_EVENTID = 36900, /* Newer CT firmware */
+	WMI_10_1_BEACON_TX_EVENTID = WMI_10X_END_EVENTID - 4, /* CT FW, beacon tx completed */
 	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID - 1,
 };
 
@@ -6223,6 +6224,13 @@ struct wmi_bcn_info {
 	struct wmi_p2p_noa_info p2p_noa_info;
 } __packed;
 
+/* CT FW only */
+struct wmi_beacon_tx_event {
+	__le32 vdev_id;
+	__le32 tx_status;
+	__le32 future[4];
+};
+
 struct wmi_host_swba_event {
 	__le32 vdev_map;
 	struct wmi_bcn_info bcn_info[0];
-- 
2.20.1

