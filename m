Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39754 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaINJnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:43:18 -0400
Subject: [PATCH 08/10] ath10k: miscellaneous checkpatch fixes
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:39 +0300
Message-ID: <20140914095038.9063.72668.stgit@x230> (sfid-20140914_114321_202127_90AB825A)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

ath10k/htc.c:49: WARNING: Possible unnecessary 'out of memory' message
ath10k/htc.c:810: WARNING: Possible unnecessary 'out of memory' message
ath10k/htt.h:1034: CHECK: Please use a blank line after function/struct/union/enum declarations
ath10k/htt_rx.c:135: CHECK: Unnecessary parentheses around htt->rx_ring.alloc_idx.vaddr
ath10k/htt_rx.c:173: CHECK: Unnecessary parentheses around htt->rx_ring.alloc_idx.vaddr
ath10k/pci.c:633: WARNING: macros should not use a trailing semicolon
ath10k/wmi.c:3594: WARNING: quoted string split across lines

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    |    8 ++------
 drivers/net/wireless/ath/ath10k/htt.h    |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 ++--
 drivers/net/wireless/ath/ath10k/pci.c    |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 ++--
 5 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index b7ee24b19f59..676bd4ed969b 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -45,10 +45,8 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 	struct ath10k_skb_cb *skb_cb;
 
 	skb = dev_alloc_skb(ATH10K_HTC_CONTROL_BUFFER_SIZE);
-	if (!skb) {
-		ath10k_warn(ar, "Unable to allocate ctrl skb\n");
+	if (!skb)
 		return NULL;
-	}
 
 	skb_reserve(skb, 20); /* FIXME: why 20 bytes? */
 	WARN_ONCE((unsigned long)skb->data & 3, "unaligned skb");
@@ -806,10 +804,8 @@ struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size)
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(size + sizeof(struct ath10k_htc_hdr));
-	if (!skb) {
-		ath10k_warn(ar, "could not allocate HTC tx skb\n");
+	if (!skb)
 		return NULL;
-	}
 
 	skb_reserve(skb, sizeof(struct ath10k_htc_hdr));
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index e20472672efe..3b44217a6c19 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1031,6 +1031,7 @@ static inline struct htt_stats_conf_item *htt_stats_conf_next_item(
 {
 	return (void *)item + sizeof(*item) + roundup(item->length, 4);
 }
+
 /*
  * host -> target FRAG DESCRIPTOR/MSDU_EXT DESC bank
  *
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 18117b9a1e9a..92b56e43d2d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -132,7 +132,7 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 	dma_addr_t paddr;
 	int ret = 0, idx;
 
-	idx = __le32_to_cpu(*(htt->rx_ring.alloc_idx.vaddr));
+	idx = __le32_to_cpu(*htt->rx_ring.alloc_idx.vaddr);
 	while (num > 0) {
 		skb = dev_alloc_skb(HTT_RX_BUF_SIZE + HTT_RX_DESC_ALIGN);
 		if (!skb) {
@@ -170,7 +170,7 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 	}
 
 fail:
-	*(htt->rx_ring.alloc_idx.vaddr) = __cpu_to_le32(idx);
+	*htt->rx_ring.alloc_idx.vaddr = __cpu_to_le32(idx);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index abd0a681d56c..59e0ea83be50 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -631,7 +631,7 @@ static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 }
 
 #define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
-	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len);
+	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len)
 
 static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 				     const void *data, int nbytes)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6b9f38b8b827..c71376218ee5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3590,8 +3590,8 @@ ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	cmd->chan.antenna_max = arg->channel.max_antenna_gain;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi vdev %s id 0x%x flags: 0x%0X, freq %d, mode %d, "
-		   "ch_flags: 0x%0X, max_power: %d\n", cmdname, arg->vdev_id,
+		   "wmi vdev %s id 0x%x flags: 0x%0X, freq %d, mode %d, ch_flags: 0x%0X, max_power: %d\n",
+		   cmdname, arg->vdev_id,
 		   flags, arg->channel.freq, arg->channel.mode,
 		   cmd->chan.flags, arg->channel.max_power);
 

