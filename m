Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59627 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:21:30 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 22/28] mwl8k: add the commands used for AP firmware initialisation
Message-ID: <20091022182130.GX1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the AP version of the GET_HW_SPEC command, as well as the
SET_HW_SPEC command, for initialising AP firmware.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  133 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 132 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5ccea17..4a70ce1 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -274,6 +274,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 /* Firmware command codes */
 #define MWL8K_CMD_CODE_DNLD		0x0001
 #define MWL8K_CMD_GET_HW_SPEC		0x0003
+#define MWL8K_CMD_SET_HW_SPEC		0x0004
 #define MWL8K_CMD_MAC_MULTICAST_ADR	0x0010
 #define MWL8K_CMD_GET_STAT		0x0014
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
@@ -304,6 +305,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 	switch (cmd & ~0x8000) {
 		MWL8K_CMDNAME(CODE_DNLD);
 		MWL8K_CMDNAME(GET_HW_SPEC);
+		MWL8K_CMDNAME(SET_HW_SPEC);
 		MWL8K_CMDNAME(MAC_MULTICAST_ADR);
 		MWL8K_CMDNAME(GET_STAT);
 		MWL8K_CMDNAME(RADIO_CONTROL);
@@ -1595,6 +1597,129 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 }
 
 /*
+ * CMD_GET_HW_SPEC (AP version).
+ */
+struct mwl8k_cmd_get_hw_spec_ap {
+	struct mwl8k_cmd_pkt header;
+	__u8 hw_rev;
+	__u8 host_interface;
+	__le16 num_wcb;
+	__le16 num_mcaddrs;
+	__u8 perm_addr[ETH_ALEN];
+	__le16 region_code;
+	__le16 num_antenna;
+	__le32 fw_rev;
+	__le32 wcbbase0;
+	__le32 rxwrptr;
+	__le32 rxrdptr;
+	__le32 ps_cookie;
+	__le32 wcbbase1;
+	__le32 wcbbase2;
+	__le32 wcbbase3;
+} __attribute__((packed));
+
+static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_cmd_get_hw_spec_ap *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_GET_HW_SPEC);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	memset(cmd->perm_addr, 0xff, sizeof(cmd->perm_addr));
+	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+
+	if (!rc) {
+		int off;
+
+		SET_IEEE80211_PERM_ADDR(hw, cmd->perm_addr);
+		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
+		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
+		priv->hw_rev = cmd->hw_rev;
+
+		off = le32_to_cpu(cmd->wcbbase0) & 0xffff;
+		iowrite32(cpu_to_le32(priv->txq[0].txd_dma), priv->sram + off);
+
+		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
+		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
+
+		off = le32_to_cpu(cmd->rxrdptr) & 0xffff;
+		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
+
+		off = le32_to_cpu(cmd->wcbbase1) & 0xffff;
+		iowrite32(cpu_to_le32(priv->txq[1].txd_dma), priv->sram + off);
+
+		off = le32_to_cpu(cmd->wcbbase2) & 0xffff;
+		iowrite32(cpu_to_le32(priv->txq[2].txd_dma), priv->sram + off);
+
+		off = le32_to_cpu(cmd->wcbbase3) & 0xffff;
+		iowrite32(cpu_to_le32(priv->txq[3].txd_dma), priv->sram + off);
+	}
+
+	kfree(cmd);
+	return rc;
+}
+
+/*
+ * CMD_SET_HW_SPEC.
+ */
+struct mwl8k_cmd_set_hw_spec {
+	struct mwl8k_cmd_pkt header;
+	__u8 hw_rev;
+	__u8 host_interface;
+	__le16 num_mcaddrs;
+	__u8 perm_addr[ETH_ALEN];
+	__le16 region_code;
+	__le32 fw_rev;
+	__le32 ps_cookie;
+	__le32 caps;
+	__le32 rx_queue_ptr;
+	__le32 num_tx_queues;
+	__le32 tx_queue_ptrs[MWL8K_TX_QUEUES];
+	__le32 flags;
+	__le32 num_tx_desc_per_queue;
+	__le32 total_rxd;
+} __attribute__((packed));
+
+#define MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT	0x00000080
+
+static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_cmd_set_hw_spec *cmd;
+	int rc;
+	int i;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_HW_SPEC);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
+	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rxd_dma);
+	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
+	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);
+	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT);
+	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
+	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_MAC_MULTICAST_ADR.
  */
 struct mwl8k_cmd_mac_multicast_adr {
@@ -3210,7 +3335,13 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
 	/* Get config data, mac addrs etc */
-	rc = mwl8k_cmd_get_hw_spec_sta(hw);
+	if (priv->ap_fw) {
+		rc = mwl8k_cmd_get_hw_spec_ap(hw);
+		if (!rc)
+			rc = mwl8k_cmd_set_hw_spec(hw);
+	} else {
+		rc = mwl8k_cmd_get_hw_spec_sta(hw);
+	}
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot initialise firmware\n",
 		       wiphy_name(hw->wiphy));
-- 
1.5.6.4
