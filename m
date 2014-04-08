Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65446 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaDHIgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:51 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 4/5] wil6210: relaxed check for BACK start sequence
Date: Tue, 8 Apr 2014 11:36:18 +0300
Message-ID: <1396946179-11677-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103700_530177_DF0DD633)
In-Reply-To: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes, due to the race between Rx path and WMI_BA_STATUS_EVENTID WMI event,
few frames may be passed to the stack before reorder buffer allocated.
Then, after BACK establishment, it start getting frames with sequence number ahead of
SSN, and it get interpreted as missing frames. Then, BACK mechanism will wait
for missing frames; data traffic will be stopped. In case of interface configured
for DHCP, this data delay causes DHCP failure.

Relax checking for sequence number; use sequence of 1-st frame handled by the buffer
as SSN for this buffer.

This is work-around, real fix should be done when proper BACK mechanism implemented.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h    |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index d04629f..ec29954 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -91,6 +91,22 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 
 	spin_lock(&r->reorder_lock);
 
+	/** Due to the race between WMI events, where BACK establishment
+	 * reported, and data Rx, few packets may be pass up before reorder
+	 * buffer get allocated. Catch up by pretending SSN is what we
+	 * see in the 1-st Rx packet
+	 */
+	if (r->first_time) {
+		r->first_time = false;
+		if (seq != r->head_seq_num) {
+			wil_err(wil, "Error: 1-st frame with wrong sequence"
+				" %d, should be %d. Fixing...\n", seq,
+				r->head_seq_num);
+			r->head_seq_num = seq;
+			r->ssn = seq;
+		}
+	}
+
 	/* frame with out of date sequence number */
 	if (seq_less(seq, r->head_seq_num)) {
 		dev_kfree_skb(skb);
@@ -162,6 +178,7 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 	r->head_seq_num = ssn;
 	r->buf_size = size;
 	r->stored_mpdu_num = 0;
+	r->first_time = true;
 	return r;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2a2dec7..f881aee 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -301,6 +301,7 @@ struct wil_tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u8 dialog_token;
+	bool first_time; /* is it 1-st time this buffer used? */
 };
 
 struct wil6210_stats {
-- 
1.8.3.2

