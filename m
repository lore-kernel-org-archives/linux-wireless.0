Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61459 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1AWAD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 19:03:57 -0500
Received: by bwz15 with SMTP id 15so2636414bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 16:03:56 -0800 (PST)
Message-Id: <46a379017a23b712bdf405cfcc182c7cc33457be.1295740096.git.chunkeey@googlemail.com>
In-Reply-To: <ffb8e21e6d549c2b229e7a4177586b7923805a96.1295740096.git.chunkeey@googlemail.com>
References: <2137e711f16faed3f59698cbcb210a1e650dd34c.1295740096.git.chunkeey@googlemail.com>
	<ffb8e21e6d549c2b229e7a4177586b7923805a96.1295740096.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 23 Jan 2011 00:18:28 +0100
Subject: [PATCH 3/3] carl9170: utilize fw seq counter for mgmt/non-QoS data frames
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"mac80211 will properly assign sequence numbers to QoS-data
frames but cannot do so correctly for non-QoS-data and
management frames because beacons need them from that counter
as well and mac80211 cannot guarantee proper sequencing."

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
This patch requires a new firmware with
"carl9170 firmware: per-vif tx sequence counter"
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/fw.c       |   12 ++++++++++++
 drivers/net/wireless/ath/carl9170/main.c     |    7 +++++++
 drivers/net/wireless/ath/carl9170/tx.c       |    3 +++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index d07ff7f..420d437 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -283,6 +283,7 @@ struct ar9170 {
 		unsigned int mem_blocks;
 		unsigned int mem_block_size;
 		unsigned int rx_size;
+		unsigned int tx_seq_table;
 	} fw;
 
 	/* reset / stuck frames/queue detection */
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index a4e5b44..9517ede 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -150,6 +150,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	const struct carl9170fw_otus_desc *otus_desc;
 	const struct carl9170fw_chk_desc *chk_desc;
 	const struct carl9170fw_last_desc *last_desc;
+	const struct carl9170fw_txsq_desc *txsq_desc;
 
 	last_desc = carl9170_fw_find_desc(ar, LAST_MAGIC,
 		sizeof(*last_desc), CARL9170FW_LAST_DESC_CUR_VER);
@@ -299,6 +300,17 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		}
 	}
 
+	txsq_desc = carl9170_fw_find_desc(ar, TXSQ_MAGIC,
+		sizeof(*txsq_desc), CARL9170FW_TXSQ_DESC_CUR_VER);
+
+	if (txsq_desc) {
+		ar->fw.tx_seq_table = le32_to_cpu(txsq_desc->seq_table_addr);
+		if (!valid_cpu_addr(ar->fw.tx_seq_table))
+			return -EINVAL;
+	} else {
+		ar->fw.tx_seq_table = 0;
+	}
+
 #undef SUPPORTED
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index ecfb80b..ede3d7e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -662,6 +662,13 @@ init:
 			goto unlock;
 	}
 
+	if (ar->fw.tx_seq_table) {
+		err = carl9170_write_reg(ar, ar->fw.tx_seq_table + vif_id * 4,
+					 0);
+		if (err)
+			goto unlock;
+	}
+
 unlock:
 	if (err && (vif_id >= 0)) {
 		vif_priv->active = false;
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6cc58e0..6f41e21 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -862,6 +862,9 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	if (unlikely(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_CAB;
 
+	if (unlikely(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+		txc->s.misc |= CARL9170_TX_SUPER_MISC_ASSIGN_SEQ;
+
 	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control)))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_FILL_IN_TSF;
 
-- 
1.7.2.3

