Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33064 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcKNQf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:28 -0500
Received: by mail-lf0-f68.google.com with SMTP id 98so7490648lfs.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:27 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 02/12] ath10k: htc: rx trailer lookahead support
Date: Mon, 14 Nov 2016 17:33:32 +0100
Message-Id: <1479141222-8493-3-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173604_225855_9B325353)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX trailer parsing is now capable of parsing lookahead reports.
This is needed by SDIO/mbox.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   91 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/htc.h |   30 +++++++++--
 2 files changed, 116 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 26b1e15..e3f7bf4 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -228,10 +228,74 @@ void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 	spin_unlock_bh(&htc->tx_lock);
 }
 
+static int
+ath10k_htc_process_lookahead(struct ath10k_htc *htc,
+			     const struct ath10k_htc_lookahead_report *report,
+			     int len,
+			     enum ath10k_htc_ep_id eid,
+			     u32 *next_lk_ahds,
+			     int *next_lk_ahds_len)
+{
+	struct ath10k *ar = htc->ar;
+
+	if (report->pre_valid != ((~report->post_valid) & 0xFF))
+		/* Invalid lookahead flags are actually transmitted by
+		 * the target in the HTC control message.
+		 * Since this will happen at every boot we silently ignore
+		 * the lookahead in this case
+		 */
+		return 0;
+
+	if (next_lk_ahds && next_lk_ahds_len) {
+		ath10k_dbg(ar, ATH10K_DBG_HTC,
+			   "htc rx lk_ahd found pre_valid 0x%x post_valid 0x%x\n",
+			   report->pre_valid, report->post_valid);
+
+		/* look ahead bytes are valid, copy them over */
+		memcpy((u8 *)&next_lk_ahds[0], report->lk_ahd, 4);
+
+		*next_lk_ahds_len = 1;
+	}
+
+	return 0;
+}
+
+static int
+ath10k_htc_process_lookahead_bundle(struct ath10k_htc *htc,
+				    const struct ath10k_htc_lookahead_report_bundle *report,
+				    int len,
+				    enum ath10k_htc_ep_id eid,
+				    u32 *next_lk_ahds,
+				    int *next_lk_ahds_len)
+{
+	int bundle_cnt = len / sizeof(*report);
+
+	if (!bundle_cnt || (bundle_cnt > HTC_HOST_MAX_MSG_PER_BUNDLE)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (next_lk_ahds && next_lk_ahds_len) {
+		int i;
+
+		for (i = 0; i < bundle_cnt; i++) {
+			memcpy((u8 *)&next_lk_ahds[i], report->lk_ahd,
+			       sizeof(u32));
+			report++;
+		}
+
+		*next_lk_ahds_len = bundle_cnt;
+	}
+
+	return 0;
+}
+
 int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 			       u8 *buffer,
 			       int length,
-			       enum ath10k_htc_ep_id src_eid)
+			       enum ath10k_htc_ep_id src_eid,
+			       u32 *next_lk_ahds,
+			       int *next_lk_ahds_len)
 {
 	struct ath10k *ar = htc->ar;
 	int status = 0;
@@ -272,6 +336,28 @@ int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 							 record->hdr.len,
 							 src_eid);
 			break;
+		case ATH10K_HTC_RECORD_LOOKAHEAD:
+			len = sizeof(struct ath10k_htc_lookahead_report);
+			if (record->hdr.len < len) {
+				ath10k_warn(ar, "Lookahead report too long\n");
+				status = -EINVAL;
+				break;
+			}
+			status = ath10k_htc_process_lookahead(htc,
+							      record->lkahd_report,
+							      record->hdr.len,
+							      src_eid,
+							      next_lk_ahds,
+							      next_lk_ahds_len);
+			break;
+		case ATH10K_HTC_RECORD_LOOKAHEAD_BUNDLE:
+			status = ath10k_htc_process_lookahead_bundle(htc,
+								     record->lkahd_bundle,
+								     record->hdr.len,
+								     src_eid,
+								     next_lk_ahds,
+								     next_lk_ahds_len);
+			break;
 		default:
 			ath10k_warn(ar, "Unhandled record: id:%d length:%d\n",
 				    record->hdr.id, record->hdr.len);
@@ -359,7 +445,8 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		trailer += payload_len;
 		trailer -= trailer_len;
 		status = ath10k_htc_process_trailer(htc, trailer,
-						    trailer_len, hdr->eid);
+						    trailer_len, hdr->eid,
+						    NULL, NULL);
 		if (status)
 			goto out;
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 858e19f..589800a 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -50,6 +50,8 @@
  * 4-byte aligned.
  */
 
+#define HTC_HOST_MAX_MSG_PER_BUNDLE        8
+
 enum ath10k_htc_tx_flags {
 	ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE = 0x01,
 	ATH10K_HTC_FLAG_SEND_BUNDLE        = 0x02
@@ -174,8 +176,10 @@ struct ath10k_htc_msg {
 } __packed __aligned(4);
 
 enum ath10k_ath10k_htc_record_id {
-	ATH10K_HTC_RECORD_NULL    = 0,
-	ATH10K_HTC_RECORD_CREDITS = 1
+	ATH10K_HTC_RECORD_NULL             = 0,
+	ATH10K_HTC_RECORD_CREDITS          = 1,
+	ATH10K_HTC_RECORD_LOOKAHEAD        = 2,
+	ATH10K_HTC_RECORD_LOOKAHEAD_BUNDLE = 3,
 };
 
 struct ath10k_ath10k_htc_record_hdr {
@@ -192,10 +196,28 @@ struct ath10k_htc_credit_report {
 	u8 pad1;
 } __packed;
 
+struct ath10k_htc_lookahead_report {
+	u8 pre_valid;
+	u8 pad0;
+	u8 pad1;
+	u8 pad2;
+	u8 lk_ahd[4];
+	u8 post_valid;
+	u8 pad3;
+	u8 pad4;
+	u8 pad5;
+} __packed;
+
+struct ath10k_htc_lookahead_report_bundle {
+	u8 lk_ahd[4];
+} __packed;
+
 struct ath10k_htc_record {
 	struct ath10k_ath10k_htc_record_hdr hdr;
 	union {
 		struct ath10k_htc_credit_report credit_report[0];
+		struct ath10k_htc_lookahead_report lkahd_report[0];
+		struct ath10k_htc_lookahead_report_bundle lkahd_bundle[0];
 		u8 pauload[0];
 	};
 } __packed __aligned(4);
@@ -359,6 +381,8 @@ void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 			       u8 *buffer,
 			       int length,
-			       enum ath10k_htc_ep_id src_eid);
+			       enum ath10k_htc_ep_id src_eid,
+			       u32 *next_lk_ahds,
+			       int *next_lk_ahds_len);
 
 #endif
-- 
1.7.9.5
