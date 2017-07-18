Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:61849 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751403AbdGRL6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 07:58:47 -0400
From: <mpubbise@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCHv2 3/3] ath10k: push peer type to target for TDLS peers
Date: Tue, 18 Jul 2017 17:28:14 +0530
Message-ID: <1500379094-2373-4-git-send-email-mpubbise@qti.qualcomm.com> (sfid-20170718_135850_089035_AD7159DC)
In-Reply-To: <1500379094-2373-1-git-send-email-mpubbise@qti.qualcomm.com>
References: <1500379094-2373-1-git-send-email-mpubbise@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>

WMI interface for all the firmwares(except QCA6174) does not include the
type of peer(default/bss/tdls) requested during peer creation, therefore
target creates a default peer.

TDLS implementation on 10.4 firmware requires host to configure the
peer type(tdls) for TDLS peers. This patch adds peer type parameter to the
existing WMI interface for peer creation to accommodate this requirement.

Tested this change on QCA9888(10.4-3.5.1-00018) and QCA988x(10.2.4.70.9-2)
with ping tests for AP/STA modes.

Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c91d804..b5e5a9e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6500,6 +6500,7 @@ void ath10k_wmi_start_scan_init(struct ath10k *ar,
 	cmd = (struct wmi_peer_create_cmd *)skb->data;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
 	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
+	cmd->peer_type = __cpu_to_le32(peer_type);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index da0e719..54dabf4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5876,6 +5876,7 @@ struct wmi_tbtt_offset_event {
 struct wmi_peer_create_cmd {
 	__le32 vdev_id;
 	struct wmi_mac_addr peer_macaddr;
+	__le32 peer_type;
 } __packed;
 
 enum wmi_peer_type {
-- 
1.7.9.5
