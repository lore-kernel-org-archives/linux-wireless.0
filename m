Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55145 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbFWHGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 03:06:35 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: add pktlog support for 10.4 firmware
Date: Tue, 23 Jun 2015 12:35:55 +0530
Message-ID: <1435043155-3111-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150623_090640_334237_F2B52B6F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware uses dedicated copy engine for pktlog transaction.
Whatever the data received in that dedicated copy engine will
have only pkt log header and followed by pktlog payload (will not
have htc header). In the current design, htc layer callback
registered with hif are acting as default receiver for all copy
engine. We need to change the design in a way dedicated copy
engine assigned for pktlog directly goes to pktlog module
(bypassing htc) and rest of copy engine data goes to htc layer.
In order to meet this, hif layer is changed to maintain copy
engine specific tx and rx callbacks.

Also, new firmware ie is added to get copy engine number used
for pktlog in the firmware. Based this, pktlog receiver callback
handler will be plugged into hif layer.

pktlog.c/h are newly added to have pktlog related stuff.
10.4 firmware pktlog header differs from non 10.4 firmware.
So, new pktlog header is added for 10.4.

This patch enables pktlog to capture only TX related info on
10.4 firmware. Some more effort is need to capture RX related
info in pktlog which is not covered in this patch.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile |  3 +-
 drivers/net/wireless/ath/ath10k/core.c   | 28 +++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h   |  3 ++
 drivers/net/wireless/ath/ath10k/hif.h    | 12 ++++----
 drivers/net/wireless/ath/ath10k/htc.c    | 15 ++++++++--
 drivers/net/wireless/ath/ath10k/htt_rx.c |  1 +
 drivers/net/wireless/ath/ath10k/hw.h     | 12 ++------
 drivers/net/wireless/ath/ath10k/pci.c    | 26 +++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.h    |  2 +-
 drivers/net/wireless/ath/ath10k/pktlog.c | 51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pktlog.h | 41 +++++++++++++++++++++++++
 11 files changed, 168 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/pktlog.c
 create mode 100644 drivers/net/wireless/ath/ath10k/pktlog.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index c04fb00..c811b8e 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -12,7 +12,8 @@ ath10k_core-y += mac.o \
 		 bmi.o \
 		 hw.o \
 		 p2p.o \
-		 swap.o
+		 swap.o \
+		 pktlog.o
 
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index be5f01c..39211c8 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -29,6 +29,7 @@
 #include "htt.h"
 #include "testmode.h"
 #include "wmi-ops.h"
+#include "pktlog.h"
 
 unsigned int ath10k_debug_mask;
 static bool uart_print;
@@ -675,7 +676,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	int ie_id, i, index, bit, ret;
 	struct ath10k_fw_ie *hdr;
 	const u8 *data;
-	__le32 *timestamp, *version;
+	__le32 *timestamp, *version, *ce_id;
 
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
@@ -819,6 +820,24 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->swap.firmware_codeswap_data = data;
 			ar->swap.firmware_codeswap_len = ie_len;
 			break;
+		case ATH10K_FW_IE_PKTLOG_DEDICATED_CE:
+			if (ie_len != sizeof(u32))
+				break;
+
+			ce_id = (__le32 *)data;
+			ar->pktlog_ce = le32_to_cpup(ce_id);
+
+			if (ar->pktlog_ce >= CE_COUNT) {
+				ath10k_warn(ar, "invalid ce number supplied for pktlog %d\n",
+					    ar->pktlog_ce);
+				break;
+			}
+
+			ar->pktlog_ce_found = true;
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "found fw ie dedicated ce number for pktlog %d\n",
+				   ar->pktlog_ce);
+			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
@@ -1499,6 +1518,13 @@ static void ath10k_core_register_work(struct work_struct *work)
 		goto err_spectral_destroy;
 	}
 
+	status = ath10k_pktlog_init(ar);
+	if (status) {
+		ath10k_err(ar, "failed to initialize pktlog: %d\n",
+			   status);
+		goto err_spectral_destroy;
+	}
+
 	set_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags);
 	return;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2e5c935..1342aeb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -624,6 +624,9 @@ struct ath10k {
 	int fw_api;
 	enum ath10k_cal_mode cal_mode;
 
+	u8 pktlog_ce;
+	bool pktlog_ce_found;
+
 	struct {
 		struct completion started;
 		struct completion completed;
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 0c92e02..abe4aac 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -80,8 +80,9 @@ struct ath10k_hif_ops {
 	 */
 	void (*send_complete_check)(struct ath10k *ar, u8 pipe_id, int force);
 
-	void (*set_callbacks)(struct ath10k *ar,
-			      struct ath10k_hif_cb *callbacks);
+	int (*set_callbacks)(struct ath10k *ar,
+			     u8 pipe_id,
+			     struct ath10k_hif_cb *callbacks);
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
@@ -163,10 +164,11 @@ static inline void ath10k_hif_send_complete_check(struct ath10k *ar,
 	ar->hif.ops->send_complete_check(ar, pipe_id, force);
 }
 
-static inline void ath10k_hif_set_callbacks(struct ath10k *ar,
-					    struct ath10k_hif_cb *callbacks)
+static inline int ath10k_hif_set_callbacks(struct ath10k *ar,
+					   u8 pipe_id,
+					   struct ath10k_hif_cb *callbacks)
 {
-	ar->hif.ops->set_callbacks(ar, callbacks);
+	return ar->hif.ops->set_callbacks(ar, pipe_id, callbacks);
 }
 
 static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 85bfa2a..f96dee3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -842,6 +842,8 @@ int ath10k_htc_init(struct ath10k *ar)
 	struct ath10k_hif_cb htc_callbacks;
 	struct ath10k_htc_ep *ep = NULL;
 	struct ath10k_htc *htc = &ar->htc;
+	int ret;
+	u8 pipe_id;
 
 	spin_lock_init(&htc->tx_lock);
 
@@ -850,12 +852,21 @@ int ath10k_htc_init(struct ath10k *ar)
 	/* setup HIF layer callbacks */
 	htc_callbacks.rx_completion = ath10k_htc_rx_completion_handler;
 	htc_callbacks.tx_completion = ath10k_htc_tx_completion_handler;
+
+	for (pipe_id = 0; pipe_id < CE_COUNT; pipe_id++) {
+		/* Ignore dedicated ce used for pktlog (if any) */
+		if (ar->pktlog_ce_found &&  (pipe_id == ar->pktlog_ce))
+			continue;
+
+		ret = ath10k_hif_set_callbacks(ar, pipe_id, &htc_callbacks);
+		if (ret)
+			return ret;
+	}
+
 	htc->ar = ar;
 
 	/* Get HIF default pipe for HTC message exchange */
 	ep = &htc->endpoint[ATH10K_HTC_EP_0];
-
-	ath10k_hif_set_callbacks(ar, &htc_callbacks);
 	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
 
 	init_completion(&htc->ctl_resp);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d7d1183..62b24db 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -22,6 +22,7 @@
 #include "debug.h"
 #include "trace.h"
 #include "mac.h"
+#include "pktlog.h"
 
 #include <linux/log2.h>
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 9172285..e24ca0e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -127,6 +127,9 @@ enum ath10k_fw_ie_type {
 
 	/* Code swap image for firmware binary */
 	ATH10K_FW_IE_FW_CODE_SWAP_IMAGE = 7,
+
+	/* Specifies dedicated copy engine number (if any) used for pktlog */
+	ATH10K_FW_IE_PKTLOG_DEDICATED_CE = 8,
 };
 
 enum ath10k_fw_wmi_op_version {
@@ -237,15 +240,6 @@ enum ath10k_mcast2ucast_mode {
 	ATH10K_MCAST2UCAST_ENABLED = 1,
 };
 
-struct ath10k_pktlog_hdr {
-	__le16 flags;
-	__le16 missed_cnt;
-	__le16 log_type;
-	__le16 size;
-	__le32 timestamp;
-	u8 payload[0];
-} __packed;
-
 enum ath10k_hw_rate_ofdm {
 	ATH10K_HW_RATE_OFDM_48M = 0,
 	ATH10K_HW_RATE_OFDM_24M,
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1b4634a..9e93d78 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1094,7 +1094,7 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
+	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current[ce_state->id];
 	struct sk_buff_head list;
 	struct sk_buff *skb;
 	u32 ce_data;
@@ -1121,7 +1121,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
-	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
+	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current[ce_state->id];
 	struct sk_buff *skb;
 	struct sk_buff_head list;
 	void *transfer_context;
@@ -1331,15 +1331,24 @@ static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 	ath10k_ce_per_engine_service(ar, pipe);
 }
 
-static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
-					 struct ath10k_hif_cb *callbacks)
+static int ath10k_pci_hif_set_callbacks(struct ath10k *ar,
+					u8 pipe_id,
+					struct ath10k_hif_cb *callbacks)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif set callbacks\n");
 
-	memcpy(&ar_pci->msg_callbacks_current, callbacks,
-	       sizeof(ar_pci->msg_callbacks_current));
+	if (pipe_id >= CE_COUNT_MAX) {
+		ath10k_warn(ar, "failed to register hif cb for pipe %d\n",
+			    pipe_id);
+		return -EINVAL;
+	}
+
+	memcpy(&ar_pci->msg_callbacks_current[pipe_id], callbacks,
+	       sizeof(*callbacks));
+
+	return 0;
 }
 
 static void ath10k_pci_kill_tasklet(struct ath10k *ar)
@@ -1543,6 +1552,7 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 	struct ath10k_ce_ring *ce_ring;
 	struct ce_desc *ce_desc;
 	struct sk_buff *skb;
+	struct ath10k_hif_cb *cb;
 	int i;
 
 	ar = pci_pipe->hif_ce_state;
@@ -1560,6 +1570,8 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 	if (WARN_ON(!ce_desc))
 		return;
 
+	cb = &ar_pci->msg_callbacks_current[ce_pipe->id];
+
 	for (i = 0; i < ce_ring->nentries; i++) {
 		skb = ce_ring->per_transfer_context[i];
 		if (!skb)
@@ -1567,7 +1579,7 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 
 		ce_ring->per_transfer_context[i] = NULL;
 
-		ar_pci->msg_callbacks_current.tx_completion(ar, skb);
+		cb->tx_completion(ar, skb);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 8d364fb..4276709 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -175,7 +175,7 @@ struct ath10k_pci {
 
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
-	struct ath10k_hif_cb msg_callbacks_current;
+	struct ath10k_hif_cb msg_callbacks_current[CE_COUNT_MAX];
 
 	/* Copy Engine used for Diagnostic Accesses */
 	struct ath10k_ce_pipe *ce_diag;
diff --git a/drivers/net/wireless/ath/ath10k/pktlog.c b/drivers/net/wireless/ath/ath10k/pktlog.c
new file mode 100644
index 0000000..176bd80
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/pktlog.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hif.h"
+#include "pktlog.h"
+
+static int ath10k_pktlog_rx_completion_handler(struct ath10k *ar,
+					       struct sk_buff *skb)
+{
+	struct ath10k_pktlog_10_4_hdr *hdr =
+		(struct ath10k_pktlog_10_4_hdr *)skb->data;
+
+	trace_ath10k_htt_pktlog(ar, hdr->payload,
+				sizeof(*hdr) + __le16_to_cpu(hdr->size));
+
+	dev_kfree_skb_any(skb);
+
+	return 0;
+}
+
+int ath10k_pktlog_init(struct ath10k *ar)
+{
+	struct ath10k_hif_cb pktlog_callbacks;
+	int ret;
+
+	if (!ar->pktlog_ce_found)
+		goto out;
+
+	/* setup hif layer callbacks for pktlog */
+	pktlog_callbacks.rx_completion = ath10k_pktlog_rx_completion_handler;
+	pktlog_callbacks.tx_completion = NULL;
+
+	ret = ath10k_hif_set_callbacks(ar, ar->pktlog_ce, &pktlog_callbacks);
+	if (ret)
+		return ret;
+out:
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath10k/pktlog.h b/drivers/net/wireless/ath/ath10k/pktlog.h
new file mode 100644
index 0000000..fb2aad9
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/pktlog.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _PKTLOG_H_
+#define _PKTLOG_H_
+
+struct ath10k_pktlog_hdr {
+	__le16 flags;
+	__le16 missed_cnt;
+	__le16 log_type;
+	__le16 size;
+	__le32 timestamp;
+	u8 payload[0];
+} __packed;
+
+struct ath10k_pktlog_10_4_hdr {
+	__le16 flags;
+	__le16 missed_cnt;
+	__le16 log_type;
+	__le16 size;
+	__le32 timestamp;
+	__le32 type_specific_data;
+	u8 payload[0];
+} __packed;
+
+int ath10k_pktlog_init(struct ath10k *ar);
+
+#endif /* _PKTLOG_H_ */
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
