Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:58040 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1HaLJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:09:24 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 6E1C78C02B
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:22 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 3AFFD4057
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:19 +0300 (EEST)
Subject: [PATCH v2 1/4] ath6kl: add firmware log support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 31 Aug 2011 14:09:19 +0300
Message-ID: <20110831110919.19680.72913.stgit@localhost6.localdomain6> (sfid-20110831_130927_645049_3A791DE2)
In-Reply-To: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
References: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware sends binary logs with WMIX_DBGLOG_EVENTID event. Create
a buffer which stores the latest logs and which can be copied from
fwlog debugfs file with cp command.

To save memory firmware log support is enabled only when CONFIG_ATH6KL_DEBUG
is enabled.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h   |   10 ++
 drivers/net/wireless/ath/ath6kl/debug.c  |  154 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h  |   13 +++
 drivers/net/wireless/ath/ath6kl/init.c   |    2 
 drivers/net/wireless/ath/ath6kl/target.h |    3 +
 drivers/net/wireless/ath/ath6kl/wmi.c    |    1 
 6 files changed, 182 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c5537b3..89ca343 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -21,6 +21,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
+#include <linux/circ_buf.h>
 #include <net/cfg80211.h>
 #include "htc.h"
 #include "wmi.h"
@@ -468,6 +469,15 @@ struct ath6kl {
 
 	struct ath6kl_node_table scan_table;
 	struct dentry *debugfs_phy;
+
+#ifdef CONFIG_ATH6KL_DEBUG
+	struct {
+		struct circ_buf fwlog_buf;
+		spinlock_t fwlog_lock;
+		void *fwlog_tmp;
+	} debug;
+#endif /* CONFIG_ATH6KL_DEBUG */
+
 };
 
 static inline void *ath6kl_priv(struct net_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 2b46287..b2706da 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -15,7 +15,23 @@
  */
 
 #include "core.h"
+
+#include <linux/circ_buf.h>
+
 #include "debug.h"
+#include "target.h"
+
+struct ath6kl_fwlog_slot {
+	__le32 timestamp;
+	__le32 length;
+
+	/* max ATH6KL_FWLOG_PAYLOAD_SIZE bytes */
+	u8 payload[0];
+};
+
+#define ATH6KL_FWLOG_SIZE 32768
+#define ATH6KL_FWLOG_SLOT_SIZE (sizeof(struct ath6kl_fwlog_slot) + \
+				ATH6KL_FWLOG_PAYLOAD_SIZE)
 
 int ath6kl_printk(const char *level, const char *fmt, ...)
 {
@@ -153,6 +169,117 @@ static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void ath6kl_debug_fwlog_add(struct ath6kl *ar, const void *buf,
+				   size_t buf_len)
+{
+	struct circ_buf *fwlog = &ar->debug.fwlog_buf;
+	size_t space;
+	int i;
+
+	/* entries must all be equal size */
+	if (WARN_ON(buf_len != ATH6KL_FWLOG_SLOT_SIZE))
+		return;
+
+	space = CIRC_SPACE(fwlog->head, fwlog->tail, ATH6KL_FWLOG_SIZE);
+	if (space < buf_len)
+		/* discard oldest slot */
+		fwlog->tail = (fwlog->tail + ATH6KL_FWLOG_SLOT_SIZE) &
+			(ATH6KL_FWLOG_SIZE - 1);
+
+	for (i = 0; i < buf_len; i += space) {
+		space = CIRC_SPACE_TO_END(fwlog->head, fwlog->tail,
+					  ATH6KL_FWLOG_SIZE);
+
+		if ((size_t) space > buf_len - i)
+			space = buf_len - i;
+
+		memcpy(&fwlog->buf[fwlog->head], buf, space);
+		fwlog->head = (fwlog->head + space) & (ATH6KL_FWLOG_SIZE - 1);
+	}
+
+}
+
+void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
+{
+	struct ath6kl_fwlog_slot *slot = ar->debug.fwlog_tmp;
+	size_t slot_len;
+
+	if (WARN_ON(len > ATH6KL_FWLOG_PAYLOAD_SIZE))
+		return;
+
+	spin_lock_bh(&ar->debug.fwlog_lock);
+
+	slot->timestamp = cpu_to_le32(jiffies);
+	slot->length = cpu_to_le32(len);
+	memcpy(slot->payload, buf, len);
+
+	slot_len = sizeof(*slot) + len;
+
+	if (slot_len < ATH6KL_FWLOG_SLOT_SIZE)
+		memset(slot->payload + len, 0,
+		       ATH6KL_FWLOG_SLOT_SIZE - slot_len);
+
+	ath6kl_debug_fwlog_add(ar, slot, ATH6KL_FWLOG_SLOT_SIZE);
+
+	spin_unlock_bh(&ar->debug.fwlog_lock);
+}
+
+static bool ath6kl_debug_fwlog_empty(struct ath6kl *ar)
+{
+	return CIRC_CNT(ar->debug.fwlog_buf.head,
+			ar->debug.fwlog_buf.tail,
+			ATH6KL_FWLOG_SLOT_SIZE) == 0;
+}
+
+static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct circ_buf *fwlog = &ar->debug.fwlog_buf;
+	size_t len = 0, buf_len = count;
+	ssize_t ret_cnt;
+	char *buf;
+	int ccnt;
+
+	buf = vmalloc(buf_len);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&ar->debug.fwlog_lock);
+
+	while (len < buf_len && !ath6kl_debug_fwlog_empty(ar)) {
+		ccnt = CIRC_CNT_TO_END(fwlog->head, fwlog->tail,
+				       ATH6KL_FWLOG_SIZE);
+
+		if ((size_t) ccnt > buf_len - len)
+			ccnt = buf_len - len;
+
+		memcpy(buf + len, &fwlog->buf[fwlog->tail], ccnt);
+		len += ccnt;
+
+		fwlog->tail = (fwlog->tail + ccnt) &
+			(ATH6KL_FWLOG_SIZE - 1);
+	}
+
+	spin_unlock_bh(&ar->debug.fwlog_lock);
+
+	if (WARN_ON(len > buf_len))
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	vfree(buf);
+
+	return ret_cnt;
+}
+
+static const struct file_operations fops_fwlog = {
+	.open = ath6kl_debugfs_open,
+	.read = ath6kl_fwlog_read,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
@@ -358,10 +485,25 @@ static const struct file_operations fops_credit_dist_stats = {
 
 int ath6kl_debug_init(struct ath6kl *ar)
 {
+	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
+	if (ar->debug.fwlog_buf.buf == NULL)
+		return -ENOMEM;
+
+	ar->debug.fwlog_tmp = kmalloc(ATH6KL_FWLOG_SLOT_SIZE, GFP_KERNEL);
+	if (ar->debug.fwlog_tmp == NULL) {
+		vfree(ar->debug.fwlog_buf.buf);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&ar->debug.fwlog_lock);
+
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
 					     ar->wdev->wiphy->debugfsdir);
-	if (!ar->debugfs_phy)
+	if (!ar->debugfs_phy) {
+		vfree(ar->debug.fwlog_buf.buf);
+		kfree(ar->debug.fwlog_tmp);
 		return -ENOMEM;
+	}
 
 	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_tgt_stats);
@@ -369,6 +511,16 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_credit_dist_stats);
 
+	debugfs_create_file("fwlog", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_fwlog);
+
 	return 0;
 }
+
+void ath6kl_debug_cleanup(struct ath6kl *ar)
+{
+	vfree(ar->debug.fwlog_buf.buf);
+	kfree(ar->debug.fwlog_tmp);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index e8c9ea9..f0d6471 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -78,7 +78,10 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_proc_registers *irq_proc_reg,
 			   struct ath6kl_irq_enable_reg *irq_en_reg);
 void dump_cred_dist_stats(struct htc_target *target);
+void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len);
 int ath6kl_debug_init(struct ath6kl *ar);
+void ath6kl_debug_cleanup(struct ath6kl *ar);
+
 #else
 static inline int ath6kl_dbg(enum ATH6K_DEBUG_MASK dbg_mask,
 			     const char *fmt, ...)
@@ -101,9 +104,19 @@ static inline void ath6kl_dump_registers(struct ath6kl_device *dev,
 static inline void dump_cred_dist_stats(struct htc_target *target)
 {
 }
+
+void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
+{
+}
+
 static inline int ath6kl_debug_init(struct ath6kl *ar)
 {
 	return 0;
 }
+
+void ath6kl_debug_cleanup(struct ath6kl *ar)
+{
+}
+
 #endif
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ad9716c..bcb94ab 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1353,6 +1353,8 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	ath6kl_bmi_cleanup(ar);
 
+	ath6kl_debug_cleanup(ar);
+
 	if (unregister && test_bit(NETDEV_REGISTERED, &ar->flag)) {
 		unregister_netdev(dev);
 		clear_bit(NETDEV_REGISTERED, &ar->flag);
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 53e2c78..6c66a08 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -340,4 +340,7 @@ struct host_interest {
 #define AR6004_REV1_BOARD_DATA_ADDRESS          0x435400
 #define AR6004_REV1_BOARD_EXT_DATA_ADDRESS      0x437000
 #define AR6004_REV1_RAM_RESERVE_SIZE            11264
+
+#define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d116d0e..b96a734 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2482,6 +2482,7 @@ static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 	case WMIX_HB_CHALLENGE_RESP_EVENTID:
 		break;
 	case WMIX_DBGLOG_EVENTID:
+		ath6kl_debug_fwlog_event(wmi->parent_dev, datap, len);
 		break;
 	default:
 		ath6kl_err("unknown cmd id 0x%x\n", id);

