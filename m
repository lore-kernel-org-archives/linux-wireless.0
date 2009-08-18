Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40163 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZHRDuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:50:14 -0400
Date: Tue, 18 Aug 2009 05:50:15 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/29] mwl8k: remove various unused struct members and defines
Message-ID: <20090818035015.GF18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   73 ++++-------------------------------------
 1 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8a6d3af..6f78fae 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -58,7 +58,6 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 #define MWL8K_HIU_H2A_INTERRUPT_STATUS_MASK	0x00000c28
 #define  MWL8K_H2A_INT_DUMMY			(1 << 20)
 #define  MWL8K_H2A_INT_RESET			(1 << 15)
-#define  MWL8K_H2A_INT_PS			(1 << 2)
 #define  MWL8K_H2A_INT_DOORBELL			(1 << 1)
 #define  MWL8K_H2A_INT_PPA_READY		(1 << 0)
 
@@ -161,10 +160,8 @@ struct mwl8k_priv {
 
 	/* lock held over TX and TX reap */
 	spinlock_t tx_lock;
-	u32 int_mask;
 
 	struct ieee80211_vif *vif;
-	struct list_head vif_list;
 
 	struct ieee80211_channel *current_channel;
 
@@ -173,10 +170,8 @@ struct mwl8k_priv {
 	dma_addr_t cookie_dma;
 
 	u16 num_mcaddrs;
-	u16 region_code;
 	u8 hw_rev;
 	__le32 fw_rev;
-	u32 wep_enabled;
 
 	/*
 	 * Running count of TX packets in flight, to avoid
@@ -226,8 +221,6 @@ struct mwl8k_priv {
 
 /* Per interface specific private data */
 struct mwl8k_vif {
-	struct list_head node;
-
 	/* backpointer to parent config block */
 	struct mwl8k_priv *priv;
 
@@ -247,18 +240,11 @@ struct mwl8k_vif {
 	/* number of supported legacy rates */
 	u8	legacy_nrates;
 
-	/* Number of supported MCS rates. Work in progress */
-	u8	mcs_nrates;
-
 	 /* Index into station database.Returned by update_sta_db call */
 	u8	peer_id;
 
 	/* Non AMPDU sequence number assigned by driver */
 	u16	seqno;
-
-	/* Note:There is no channel info,
-	 * refer to the master channel info in priv
-	 */
 };
 
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
@@ -681,11 +667,9 @@ struct ewc_ht_info {
 
 /* Peer Entry flags - used to define the type of the peer node */
 #define MWL8K_PEER_TYPE_ACCESSPOINT	2
-#define MWL8K_PEER_TYPE_ADHOC_STATION	4
 
 #define MWL8K_IEEE_LEGACY_DATA_RATES	12
 #define MWL8K_MCS_BITMAP_SIZE		16
-#define pad_size			16
 
 struct peer_capability_info {
 	/* Peer type - AP vs. STA.  */
@@ -707,7 +691,7 @@ struct peer_capability_info {
 
 	/* HT rate table. Intersection of our rates and peer rates.  */
 	__u8	ht_rates[MWL8K_MCS_BITMAP_SIZE];
-	__u8	pad[pad_size];
+	__u8	pad[16];
 
 	/* If set, interoperability mode, no proprietary extensions.  */
 	__u8	interop;
@@ -717,15 +701,6 @@ struct peer_capability_info {
 } __attribute__((packed));
 
 /* Inline functions to manipulate QoS field in data descriptor.  */
-static inline u16 mwl8k_qos_setbit_tid(u16 qos, u8 tid)
-{
-	u16 val_mask = 0x000f;
-	u16 qos_mask = ~val_mask;
-
-	/* TID bits 0-3 */
-	return (qos & qos_mask) | (tid & val_mask);
-}
-
 static inline u16 mwl8k_qos_setbit_eosp(u16 qos)
 {
 	u16 val_mask = 1 << 4;
@@ -826,9 +801,7 @@ static inline struct sk_buff *mwl8k_add_dma_header(struct sk_buff *skb)
 /*
  * Packet reception.
  */
-#define MWL8K_RX_CTRL_KEY_INDEX_MASK	0x30
 #define MWL8K_RX_CTRL_OWNED_BY_HOST	0x02
-#define MWL8K_RX_CTRL_AMPDU		0x01
 
 struct mwl8k_rx_desc {
 	__le16 pkt_len;
@@ -1073,8 +1046,6 @@ enum {
 
 /* Transmit packet ACK policy */
 #define MWL8K_TXD_ACK_POLICY_NORMAL		0
-#define MWL8K_TXD_ACK_POLICY_NONE		1
-#define MWL8K_TXD_ACK_POLICY_NO_EXPLICIT	2
 #define MWL8K_TXD_ACK_POLICY_BLOCKACK		3
 
 #define GET_TXQ(_ac) (\
@@ -1083,20 +1054,11 @@ enum {
 		((_ac) == WME_AC_BK) ? MWL8K_WME_AC_BK : \
 		MWL8K_WME_AC_BE)
 
-#define MWL8K_TXD_STATUS_IDLE			0x00000000
-#define MWL8K_TXD_STATUS_USED			0x00000001
 #define MWL8K_TXD_STATUS_OK			0x00000001
 #define MWL8K_TXD_STATUS_OK_RETRY		0x00000002
 #define MWL8K_TXD_STATUS_OK_MORE_RETRY		0x00000004
 #define MWL8K_TXD_STATUS_MULTICAST_TX		0x00000008
-#define MWL8K_TXD_STATUS_BROADCAST_TX		0x00000010
-#define MWL8K_TXD_STATUS_FAILED_LINK_ERROR	0x00000020
-#define MWL8K_TXD_STATUS_FAILED_EXCEED_LIMIT	0x00000040
-#define MWL8K_TXD_STATUS_FAILED_AGING		0x00000080
-#define MWL8K_TXD_STATUS_HOST_CMD		0x40000000
 #define MWL8K_TXD_STATUS_FW_OWNED		0x80000000
-#define  MWL8K_TXD_SOFTSTALE				0x80
-#define  MWL8K_TXD_SOFTSTALE_MGMT_RETRY			0x01
 
 struct mwl8k_tx_desc {
 	__le32 status;
@@ -1279,12 +1241,10 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 	return 0;
 }
 
-#define MWL8K_TXD_OK	(MWL8K_TXD_STATUS_OK | \
-			 MWL8K_TXD_STATUS_OK_RETRY | \
-			 MWL8K_TXD_STATUS_OK_MORE_RETRY)
-#define MWL8K_TXD_SUCCESS(stat)		((stat) & MWL8K_TXD_OK)
-#define MWL8K_TXD_FAIL_RETRY(stat)	\
-	((stat) & (MWL8K_TXD_STATUS_FAILED_EXCEED_LIMIT))
+#define MWL8K_TXD_SUCCESS(status)				\
+	((status) & (MWL8K_TXD_STATUS_OK |			\
+		     MWL8K_TXD_STATUS_OK_RETRY |		\
+		     MWL8K_TXD_STATUS_OK_MORE_RETRY))
 
 static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 {
@@ -1671,7 +1631,6 @@ static int mwl8k_cmd_get_hw_spec(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
-		priv->region_code = le16_to_cpu(cmd->region_code);
 	}
 
 	kfree(cmd);
@@ -2150,7 +2109,6 @@ struct mwl8k_cmd_set_edca_params {
 	__u8 txq;
 } __attribute__((packed));
 
-#define MWL8K_GET_EDCA_ALL	0
 #define MWL8K_SET_EDCA_CW	0x01
 #define MWL8K_SET_EDCA_TXOP	0x02
 #define MWL8K_SET_EDCA_AIFS	0x04
@@ -2323,18 +2281,12 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 /*
  * CMD_SET_AID.
  */
-#define IEEE80211_OPMODE_DISABLED			0x00
-#define IEEE80211_OPMODE_NON_MEMBER_PROT_MODE		0x01
-#define IEEE80211_OPMODE_ONE_20MHZ_STA_PROT_MODE	0x02
-#define IEEE80211_OPMODE_HTMIXED_PROT_MODE		0x03
-
 #define MWL8K_RATE_INDEX_MAX_ARRAY			14
 
 #define MWL8K_FRAME_PROT_DISABLED			0x00
 #define MWL8K_FRAME_PROT_11G				0x07
 #define MWL8K_FRAME_PROT_11N_HT_40MHZ_ONLY		0x02
 #define MWL8K_FRAME_PROT_11N_HT_ALL			0x06
-#define MWL8K_FRAME_PROT_MASK				0x07
 
 struct mwl8k_cmd_update_set_aid {
 	struct	mwl8k_cmd_pkt header;
@@ -2439,10 +2391,6 @@ static int mwl8k_update_rateset(struct ieee80211_hw *hw,
  */
 #define MWL8K_RATE_TABLE_SIZE	8
 #define MWL8K_UCAST_RATE	0
-#define MWL8K_MCAST_RATE	1
-#define MWL8K_BCAST_RATE	2
-
-#define MWL8K_USE_FIXED_RATE	0x0001
 #define MWL8K_USE_AUTO_RATE	0x0002
 
 struct mwl8k_rate_entry {
@@ -2535,7 +2483,6 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	status = ioread32(priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 	iowrite32(~status, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
 
-	status &= priv->int_mask;
 	if (!status)
 		return IRQ_NONE;
 
@@ -2873,7 +2820,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 	}
 
 	/* Enable interrupts */
-	iowrite32(priv->int_mask, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
 	if (worker == NULL) {
@@ -3519,7 +3466,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->hostcmd_wait = NULL;
 	priv->tx_wait = NULL;
 	priv->inconfig = false;
-	priv->wep_enabled = 0;
 	priv->wmm_mode = false;
 	priv->pending_tx_pkts = 0;
 	strncpy(priv->name, MWL8K_NAME, sizeof(priv->name));
@@ -3601,8 +3547,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS);
-	priv->int_mask = 0;
-	iowrite32(priv->int_mask, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL);
 	iowrite32(0xffffffff, priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
 
@@ -3639,9 +3584,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	 * commands use interrupts and avoids polling.  Disable
 	 * interrupts when done.
 	 */
-	priv->int_mask |= MWL8K_A2H_EVENTS;
-
-	iowrite32(priv->int_mask, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
+	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
 	/* Get config data, mac addrs etc */
 	rc = mwl8k_cmd_get_hw_spec(hw);
-- 
1.5.6.4
