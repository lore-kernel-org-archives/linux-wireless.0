Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53955 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbcEKRCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:43 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
Date: Wed, 11 May 2016 10:02:21 -0700
Message-Id: <1462986153-16318-10-git-send-email-greearb@candelatech.com> (sfid-20160511_192231_798357_322F7655)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows user-space tools to decode debug-log
messages by parsing dmesg or /var/log/messages.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 72 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |  5 +++
 drivers/net/wireless/ath/ath10k/pci.c   |  3 ++
 drivers/net/wireless/ath/ath10k/wmi.c   | 12 ++++++
 4 files changed, 92 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c7bff1e..97de9f37 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2717,3 +2717,75 @@ void ath10k_dbg_dump(struct ath10k *ar,
 EXPORT_SYMBOL(ath10k_dbg_dump);
 
 #endif /* CONFIG_ATH10K_DEBUG */
+
+void ath10k_dbg_print_fw_dbg_buffer(struct ath10k *ar, __le32 *ibuf, int len,
+				    const char* lvl)
+{
+	/* Print out raw hex, external tools can decode if
+	 * they care.
+	 * TODO:  Add ar identifier to messages.
+	 */
+	int q = 0;
+
+	dev_printk(lvl, ar->dev, "ath10k_pci ATH10K_DBG_BUFFER:\n");
+	while (q < len) {
+		if (q + 8 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
+			       ibuf[q+4], ibuf[q+5], ibuf[q+6], ibuf[q+7]);
+			q += 8;
+		}
+		else if (q + 7 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
+			       ibuf[q+4], ibuf[q+5], ibuf[q+6]);
+			q += 7;
+		}
+		else if (q + 6 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
+			       ibuf[q+4], ibuf[q+5]);
+			q += 6;
+		}
+		else if (q + 5 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
+			       ibuf[q+4]);
+			q += 5;
+		}
+		else if (q + 4 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3]);
+			q += 4;
+		}
+		else if (q + 3 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1], ibuf[q+2]);
+			q += 3;
+		}
+		else if (q + 2 <= len) {
+			printk("%sath10k: [%04d]: %08X %08X\n",
+			       lvl, q,
+			       ibuf[q], ibuf[q+1]);
+			q += 2;
+		}
+		else if (q + 1 <= len) {
+			printk("%sath10k: [%04d]: %08X\n",
+			       lvl, q,
+			       ibuf[q]);
+			q += 1;
+		}
+		else {
+			break;
+		}
+	}/* while */
+
+	dev_printk(lvl, ar->dev, "ATH10K_END\n");
+}
+EXPORT_SYMBOL(ath10k_dbg_print_fw_dbg_buffer);
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 3062948..641fce1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -38,6 +38,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_WMI_PRINT	= 0x00002000,
 	ATH10K_DBG_PCI_PS	= 0x00004000,
 	ATH10K_DBG_AHB		= 0x00008000,
+	ATH10K_DBG_FW		= 0x80000000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
@@ -192,4 +193,8 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
 {
 }
 #endif /* CONFIG_ATH10K_DEBUG */
+
+void ath10k_dbg_print_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer,
+				    int len, const char* lvl);
+
 #endif /* _DEBUG_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e6315ec..dbf0db8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1623,6 +1623,9 @@ static void ath10k_pci_dump_dbglog(struct ath10k *ar)
 		WARN_ON(len & 0x3);
 
 		ath10k_dbg_save_fw_dbg_buffer(ar, (__le32 *)(buffer), len >> 2);
+		ath10k_dbg_print_fw_dbg_buffer(ar, (__le32 *)(buffer),
+					       dbuf.length/sizeof(__le32),
+					       KERN_ERR);
 		kfree(buffer);
 
 next:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d9e4b77..6cfba41 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2510,6 +2510,18 @@ int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 				      (skb->len - 4)/sizeof(__le32));
 	spin_unlock_bh(&ar->data_lock);
 
+	if (ev->dropped_count)
+		ath10k_warn(ar, "WARNING: Dropped dbglog buffers: %d\n", __le32_to_cpu(ev->dropped_count));
+
+	if (ath10k_debug_mask & ATH10K_DBG_FW)
+		ath10k_dbg_print_fw_dbg_buffer(ar, ev->messages,
+					       (skb->len - 4)/sizeof(__le32),
+					       KERN_INFO);
+	else
+		ath10k_dbg_print_fw_dbg_buffer(ar, ev->messages,
+					       (skb->len - 4)/sizeof(__le32),
+					       KERN_DEBUG);
+
 	return 0;
 }
 
-- 
2.4.3

