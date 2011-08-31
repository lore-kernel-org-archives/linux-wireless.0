Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:50042 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1HaLJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:09:44 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id A63EF13B363
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:42 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 80888158A6B
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:41 +0300 (EEST)
Subject: [PATCH v2 4/4] ath6kl: read fwlog from firmware ring buffer
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 31 Aug 2011 14:09:41 +0300
Message-ID: <20110831110941.19680.27035.stgit@localhost6.localdomain6> (sfid-20110831_130947_420093_C7ABF894)
In-Reply-To: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
References: <20110831110650.19680.35966.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmare sends the logs only when it's internal ring buffer is full. But
if firmware crashes we need to retrieve the latest logs through diagnose
window. This is now done everytime the debugfs file is read.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h   |   15 ++++++
 drivers/net/wireless/ath/ath6kl/debug.c  |    3 +
 drivers/net/wireless/ath/ath6kl/init.c   |   13 -----
 drivers/net/wireless/ath/ath6kl/main.c   |   75 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/target.h |   14 ++++++
 5 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 33c84c0..61d3142 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -26,6 +26,7 @@
 #include "htc.h"
 #include "wmi.h"
 #include "bmi.h"
+#include "target.h"
 
 #define MAX_ATH6KL                        1
 #define ATH6KL_MAX_RX_BUFFERS             16
@@ -496,6 +497,19 @@ static inline void ath6kl_deposit_credit_to_ep(struct htc_credit_state_info
 	cred_info->cur_free_credits -= credits;
 }
 
+static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
+					  u32 item_offset)
+{
+	u32 addr = 0;
+
+	if (ar->target_type == TARGET_TYPE_AR6003)
+		addr = ATH6KL_AR6003_HI_START_ADDR + item_offset;
+	else if (ar->target_type == TARGET_TYPE_AR6004)
+		addr = ATH6KL_AR6004_HI_START_ADDR + item_offset;
+
+	return addr;
+}
+
 void ath6kl_destroy(struct net_device *dev, unsigned int unregister);
 int ath6kl_configure_target(struct ath6kl *ar);
 void ath6kl_detect_error(unsigned long ptr);
@@ -512,6 +526,7 @@ void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
 int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
 int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
+int ath6kl_read_fwlogs(struct ath6kl *ar);
 void ath6kl_init_profile_info(struct ath6kl *ar);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
 void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 239c092..87de44d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -247,6 +247,9 @@ static ssize_t ath6kl_fwlog_read(struct file *file, char __user *user_buf,
 	if (!buf)
 		return -ENOMEM;
 
+	/* read undelivered logs from firmware */
+	ath6kl_read_fwlogs(ar);
+
 	spin_lock_bh(&ar->debug.fwlog_lock);
 
 	while (len < buf_len && !ath6kl_debug_fwlog_empty(ar)) {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index b6a1e69..428b9c0 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -108,19 +108,6 @@ static u8 ath6kl_get_fw_iftype(struct ath6kl *ar)
 	}
 }
 
-static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
-					  u32 item_offset)
-{
-	u32 addr = 0;
-
-	if (ar->target_type == TARGET_TYPE_AR6003)
-		addr = ATH6KL_AR6003_HI_START_ADDR + item_offset;
-	else if (ar->target_type == TARGET_TYPE_AR6004)
-		addr = ATH6KL_AR6004_HI_START_ADDR + item_offset;
-
-	return addr;
-}
-
 static int ath6kl_set_host_app_area(struct ath6kl *ar)
 {
 	u32 address, data;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f881530..761c6a1 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -308,6 +308,81 @@ int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length)
 	return 0;
 }
 
+int ath6kl_read_fwlogs(struct ath6kl *ar)
+{
+	struct ath6kl_dbglog_hdr debug_hdr;
+	struct ath6kl_dbglog_buf debug_buf;
+	u32 address, length, dropped, firstbuf, debug_hdr_addr;
+	int ret = 0, loop;
+	u8 *buf;
+
+	buf = kmalloc(ATH6KL_FWLOG_PAYLOAD_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	address = TARG_VTOP(ar->target_type,
+			    ath6kl_get_hi_item_addr(ar,
+						    HI_ITEM(hi_dbglog_hdr)));
+
+	ret = ath6kl_diag_read32(ar, address, &debug_hdr_addr);
+	if (ret)
+		goto out;
+
+	/* Get the contents of the ring buffer */
+	if (debug_hdr_addr == 0) {
+		ath6kl_warn("Invalid address for debug_hdr_addr\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	address = TARG_VTOP(ar->target_type, debug_hdr_addr);
+	ath6kl_diag_read(ar, address, &debug_hdr, sizeof(debug_hdr));
+
+	address = TARG_VTOP(ar->target_type,
+			    le32_to_cpu(debug_hdr.dbuf_addr));
+	firstbuf = address;
+	dropped = le32_to_cpu(debug_hdr.dropped);
+	ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+
+	loop = 100;
+
+	do {
+		address = TARG_VTOP(ar->target_type,
+				    le32_to_cpu(debug_buf.buffer_addr));
+		length = le32_to_cpu(debug_buf.length);
+
+		if (length != 0 && (le32_to_cpu(debug_buf.length) <=
+				    le32_to_cpu(debug_buf.bufsize))) {
+			length = ALIGN(length, 4);
+
+			ret = ath6kl_diag_read(ar, address,
+					       buf, length);
+			if (ret)
+				goto out;
+
+			ath6kl_debug_fwlog_event(ar, buf, length);
+		}
+
+		address = TARG_VTOP(ar->target_type,
+				    le32_to_cpu(debug_buf.next));
+		ath6kl_diag_read(ar, address, &debug_buf, sizeof(debug_buf));
+		if (ret)
+			goto out;
+
+		loop--;
+
+		if (WARN_ON(loop == 0)) {
+			ret = -ETIMEDOUT;
+			goto out;
+		}
+	} while (address != firstbuf);
+
+out:
+	kfree(buf);
+
+	return ret;
+}
+
 /* FIXME: move to a better place, target.h? */
 #define AR6003_RESET_CONTROL_ADDRESS 0x00004000
 #define AR6004_RESET_CONTROL_ADDRESS 0x00004000
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 6c66a08..dd8b953 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -343,4 +343,18 @@ struct host_interest {
 
 #define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
 
+struct ath6kl_dbglog_buf {
+	__le32 next;
+	__le32 buffer_addr;
+	__le32 bufsize;
+	__le32 length;
+	__le32 count;
+	__le32 free;
+} __packed;
+
+struct ath6kl_dbglog_hdr {
+	__le32 dbuf_addr;
+	__le32 dropped;
+} __packed;
+
 #endif

