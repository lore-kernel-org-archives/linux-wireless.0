Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:42 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 7/7] wil6210: optimize wil_release_reorder_frames
Date: Tue, 27 May 2014 14:45:50 +0300
Message-ID: <1401191150-29037-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134645_608021_28C85439)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of receiving frame with sequence number far greater than current,
wil_release_reorder_frames() will iterate many times over empty buffer.

Optimize this case by checking buffer emptiness and simply update
head_seq_num without iterating.

Suggested-by: Vladimir Shulman <Vladimir.Shulman@Wilocity.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index ec29954..747ae12 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -49,10 +49,17 @@ static void wil_release_reorder_frames(struct wil6210_priv *wil,
 {
 	int index;
 
-	while (seq_less(r->head_seq_num, hseq)) {
+	/* note: this function is never called with
+	 * hseq preceding r->head_seq_num, i.e it is always true
+	 * !seq_less(hseq, r->head_seq_num)
+	 * and thus on loop exit it should be
+	 * r->head_seq_num == hseq
+	 */
+	while (seq_less(r->head_seq_num, hseq) && r->stored_mpdu_num) {
 		index = reorder_index(r, r->head_seq_num);
 		wil_release_reorder_frame(wil, r, index);
 	}
+	r->head_seq_num = hseq;
 }
 
 static void wil_reorder_release(struct wil6210_priv *wil,
-- 
1.9.1

