Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34763 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab0GTSPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:15:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: correct/silence sparse warnings
Date: Tue, 20 Jul 2010 14:07:02 -0400
Message-Id: <1279649222-3042-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/mwl8k.c:1541:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mwl8k.c:1541:21:    expected restricted __le16 [usertype] result
drivers/net/wireless/mwl8k.c:1541:21:    got int
drivers/net/wireless/mwl8k.c:1575:42:    expected unsigned short [unsigned] [usertype] cmd
drivers/net/wireless/mwl8k.c:1575:42:    got restricted __le16 [usertype] code
drivers/net/wireless/mwl8k.c:1587:50: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1587:50:    expected unsigned short [unsigned] [usertype] cmd
drivers/net/wireless/mwl8k.c:1587:50:    got restricted __le16 [usertype] code
drivers/net/wireless/mwl8k.c:1592:50: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1592:50:    expected unsigned short [unsigned] [usertype] cmd
drivers/net/wireless/mwl8k.c:1592:50:    got restricted __le16 [usertype] code
drivers/net/wireless/mwl8k.c:1845:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1845:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1845:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:1848:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1848:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1848:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:1851:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1851:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1851:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:1854:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1854:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1854:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:1857:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1857:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1857:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:1860:27: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/mwl8k.c:1860:27:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/mwl8k.c:1860:27:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/mwl8k.c:3055:20: warning: incorrect type in assignment (different base types)
drivers/net/wireless/mwl8k.c:3055:20:    expected restricted __le16 [usertype] ht_caps
drivers/net/wireless/mwl8k.c:3055:20:    got unsigned short [unsigned] [usertype] cap

At least the last one looks like a real bug...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwl8k.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cd37b2a..3576071 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -314,13 +314,15 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
-static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
+static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
+	u16 command = le16_to_cpu(cmd);
+
 #define MWL8K_CMDNAME(x)	case MWL8K_CMD_##x: do {\
 					snprintf(buf, bufsize, "%s", #x);\
 					return buf;\
 					} while (0)
-	switch (cmd & ~0x8000) {
+	switch (command & ~0x8000) {
 		MWL8K_CMDNAME(CODE_DNLD);
 		MWL8K_CMDNAME(GET_HW_SPEC);
 		MWL8K_CMDNAME(SET_HW_SPEC);
@@ -1538,7 +1540,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	unsigned long timeout = 0;
 	u8 buf[32];
 
-	cmd->result = 0xffff;
+	cmd->result = (__force __le16) 0xffff;
 	dma_size = le16_to_cpu(cmd->length);
 	dma_addr = pci_map_single(priv->pdev, cmd, dma_size,
 				  PCI_DMA_BIDIRECTIONAL);
@@ -1842,22 +1844,28 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->sta_macids_supported = 0x00000000;
 
 		off = le32_to_cpu(cmd->wcbbase0) & 0xffff;
-		iowrite32(cpu_to_le32(priv->txq[0].txd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->txq[0].txd_dma),
+				priv->sram + off);
 
 		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
-		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->rxq[0].rxd_dma),
+				priv->sram + off);
 
 		off = le32_to_cpu(cmd->rxrdptr) & 0xffff;
-		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->rxq[0].rxd_dma),
+				priv->sram + off);
 
 		off = le32_to_cpu(cmd->wcbbase1) & 0xffff;
-		iowrite32(cpu_to_le32(priv->txq[1].txd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->txq[1].txd_dma),
+				priv->sram + off);
 
 		off = le32_to_cpu(cmd->wcbbase2) & 0xffff;
-		iowrite32(cpu_to_le32(priv->txq[2].txd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->txq[2].txd_dma),
+				priv->sram + off);
 
 		off = le32_to_cpu(cmd->wcbbase3) & 0xffff;
-		iowrite32(cpu_to_le32(priv->txq[3].txd_dma), priv->sram + off);
+		iowrite32((__force __u32) cpu_to_le32(priv->txq[3].txd_dma),
+				priv->sram + off);
 	}
 
 	kfree(cmd);
@@ -3052,7 +3060,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->peer_type = MWL8K_PEER_TYPE_ACCESSPOINT;
 	p->basic_caps = cpu_to_le16(vif->bss_conf.assoc_capability);
 	p->ht_support = sta->ht_cap.ht_supported;
-	p->ht_caps = sta->ht_cap.cap;
+	p->ht_caps = cpu_to_le16(sta->ht_cap.cap);
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
 	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
-- 
1.7.1.1

