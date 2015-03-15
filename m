Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbCOOAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:55 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 3/7] wil6210: Align Rx frames on 4*n+2 by having SNAP
Date: Sun, 15 Mar 2015 16:00:19 +0200
Message-Id: <1426428024-4538-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150058_786682_539F241F)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the networking code and for hardware network accelerators,
it is better to have IP header 4*n aligned. On the other side,
DMA on Rx path require buffer to be aligned on 4*n as well.
Having 14 bytes of Ethernet header, these 2 alignment
requests are in contradiction.

To solve this, order hardware offload block to not remove
SNAP header. This adds extra 6 bytes between addresses and
ethertype, making it 20 bytes total. This way, both buffer and
IP header are 4*n aligned. Remaining is only to remove SNAP
by shifting addresses 6 bytes. This involves data copying, so
this feature should be disabled unless required by the platform.

Module parameter "rx_align_2" (bool, default - false)
introduced to control this feature. Feature is completely disabled
when parameter is false.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    | 27 ++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c     |  5 +++++
 drivers/net/wireless/ath/wil6210/wmi.h     |  3 +++
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3feb86c4..2453470 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -33,6 +33,15 @@ module_param(rtap_include_phy_info, bool, S_IRUGO);
 MODULE_PARM_DESC(rtap_include_phy_info,
 		 " Include PHY info in the radiotap header, default - no");
 
+bool rx_align_2;
+module_param(rx_align_2, bool, S_IRUGO);
+MODULE_PARM_DESC(rx_align_2, " align Rx buffers on 4*n+2, default - no");
+
+static inline uint wil_rx_snaplen(void)
+{
+	return rx_align_2 ? 6 : 0;
+}
+
 static inline int wil_vring_is_empty(struct vring *vring)
 {
 	return vring->swhead == vring->swtail;
@@ -209,7 +218,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 			       u32 i, int headroom)
 {
 	struct device *dev = wil_to_dev(wil);
-	unsigned int sz = mtu_max + ETH_HLEN;
+	unsigned int sz = mtu_max + ETH_HLEN + wil_rx_snaplen();
 	struct vring_rx_desc dd, *d = &dd;
 	volatile struct vring_rx_desc *_d = &vring->va[i].rx;
 	dma_addr_t pa;
@@ -365,7 +374,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	struct vring_rx_desc *d;
 	struct sk_buff *skb;
 	dma_addr_t pa;
-	unsigned int sz = mtu_max + ETH_HLEN;
+	unsigned int snaplen = wil_rx_snaplen();
+	unsigned int sz = mtu_max + ETH_HLEN + snaplen;
 	u16 dmalen;
 	u8 ftype;
 	int cid;
@@ -438,7 +448,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		return NULL;
 	}
 
-	if (unlikely(skb->len < ETH_HLEN)) {
+	if (unlikely(skb->len < ETH_HLEN + snaplen)) {
 		wil_err(wil, "Short frame, len = %d\n", skb->len);
 		/* TODO: process it (i.e. BAR) */
 		kfree_skb(skb);
@@ -460,6 +470,17 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		 */
 	}
 
+	if (snaplen) {
+		/* Packet layout
+		 * +-------+-------+---------+------------+------+
+		 * | SA(6) | DA(6) | SNAP(6) | ETHTYPE(2) | DATA |
+		 * +-------+-------+---------+------------+------+
+		 * Need to remove SNAP, shifting SA and DA forward
+		 */
+		memmove(skb->data + snaplen, skb->data, 2 * ETH_ALEN);
+		skb_pull(skb, snaplen);
+	}
+
 	return skb;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c1a71ab..a6b096e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -28,6 +28,7 @@ extern unsigned int mtu_max;
 extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
 extern u32 vring_idle_trsh;
+extern bool rx_align_2;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw" /* code */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0213135..8c18a46 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1109,6 +1109,11 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 		 */
 		cmd.l3_l4_ctrl |= (1 << L3_L4_CTRL_TCPIP_CHECKSUM_EN_POS);
 	}
+
+	if (rx_align_2)
+		cmd.l2_802_3_offload_ctrl |=
+				L2_802_3_OFFLOAD_CTRL_SNAP_KEEP_MSK;
+
 	/* typical time for secure PCP is 840ms */
 	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
 		      WMI_CFG_RX_CHAIN_DONE_EVENTID, &evt, sizeof(evt), 2000);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 8a4af61..0979650 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -687,6 +687,9 @@ struct wmi_cfg_rx_chain_cmd {
 	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_POS (0)
 	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_LEN (1)
 	#define L2_802_3_OFFLOAD_CTRL_VLAN_TAG_INSERTION_MSK (0x1)
+	#define L2_802_3_OFFLOAD_CTRL_SNAP_KEEP_POS (1)
+	#define L2_802_3_OFFLOAD_CTRL_SNAP_KEEP_LEN (1)
+	#define L2_802_3_OFFLOAD_CTRL_SNAP_KEEP_MSK (0x2)
 	u8 l2_802_3_offload_ctrl;
 
 	#define L2_NWIFI_OFFLOAD_CTRL_REMOVE_QOS_POS (0)
-- 
2.1.0

