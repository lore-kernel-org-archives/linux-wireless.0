Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49977 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaINJnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:43:13 -0400
Subject: [PATCH 07/10] ath10k: else is not generally useful after a break or
 return
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:33 +0300
Message-ID: <20140914095033.9063.17325.stgit@x230> (sfid-20140914_114316_310834_F6E60EBC)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

WARNING: else is not generally useful after a break or return

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c  |    4 ++--
 drivers/net/wireless/ath/ath10k/htt_rx.c |   12 ++++++------
 drivers/net/wireless/ath/ath10k/mac.c    |   12 ++++++------
 drivers/net/wireless/ath/ath10k/pci.c    |    7 ++++---
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 2bfd00b29204..ff914b4ac0e6 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1180,8 +1180,8 @@ int ath10k_debug_register(struct ath10k *ar)
 	if (IS_ERR_OR_NULL(ar->debug.debugfs_phy)) {
 		if (IS_ERR(ar->debug.debugfs_phy))
 			return PTR_ERR(ar->debug.debugfs_phy);
-		else
-			return -ENOMEM;
+
+		return -ENOMEM;
 	}
 
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 26196ed947bc..18117b9a1e9a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -450,11 +450,11 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		if (last_msdu) {
 			msdu->next = NULL;
 			break;
-		} else {
-			next = ath10k_htt_rx_netbuf_pop(htt);
-			msdu->next = next;
-			msdu = next;
 		}
+
+		next = ath10k_htt_rx_netbuf_pop(htt);
+		msdu->next = next;
+		msdu = next;
 	}
 	*tail_msdu = msdu;
 
@@ -631,8 +631,8 @@ static struct ieee80211_hdr *ath10k_htt_rx_skb_get_hdr(struct sk_buff *skb)
 
 	if (fmt == RX_MSDU_DECAP_RAW)
 		return (void *)skb->data;
-	else
-		return (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
+
+	return (void *)skb->data - RX_HTT_HDR_STATUS_LEN;
 }
 
 /* This function only applies for first msdu in an msdu chain */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c1cf6ff319e8..28e6db1d3846 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -698,8 +698,8 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 
 	if (should_start)
 		return ath10k_monitor_start(ar);
-	else
-		return ath10k_monitor_stop(ar);
+
+	return ath10k_monitor_stop(ar);
 }
 
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
@@ -4065,8 +4065,8 @@ ath10k_bitrate_mask_nss(const struct cfg80211_bitrate_mask *mask,
 			continue;
 		else if (mask->control[band].ht_mcs[i] == 0x00)
 			break;
-		else
-			return false;
+
+		return false;
 	}
 
 	ht_nss = i;
@@ -4077,8 +4077,8 @@ ath10k_bitrate_mask_nss(const struct cfg80211_bitrate_mask *mask,
 			continue;
 		else if (mask->control[band].vht_mcs[i] == 0x0000)
 			break;
-		else
-			return false;
+
+		return false;
 	}
 
 	vht_nss = i;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 08e88a3758c1..abd0a681d56c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -362,10 +362,11 @@ static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
 
 	if (ar_pci->num_msi_intrs > 1)
 		return "msi-x";
-	else if (ar_pci->num_msi_intrs == 1)
+
+	if (ar_pci->num_msi_intrs == 1)
 		return "msi";
-	else
-		return "legacy";
+
+	return "legacy";
 }
 
 static int __ath10k_pci_rx_post_buf(struct ath10k_pci_pipe *pipe)

