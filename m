Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33281 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBYG5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 01:57:17 -0500
Received: by mail-ee0-f43.google.com with SMTP id e51so3642437eek.30
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 22:57:16 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: skip management frames in HTT path
Date: Tue, 25 Feb 2014 07:56:39 +0100
Message-Id: <1393311399-8070-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140225_075722_960738_CEF9771D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After we pass frames with INV_PEER to upper layer in patch:

ath10k: pass frames with invalid peer status to upper layer

we could pass some management frames (in case INVALID_PEER
and MGMT_CTRL) twice to upper layer, once via WMI and once
via HTT. Next we could handle assoc request twice. This
patch remove such regression.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index c7a5822..316433f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -852,6 +852,20 @@ static bool ath10k_htt_rx_has_mic_err(struct sk_buff *skb)
 	return false;
 }
 
+static bool ath10k_htt_rx_is_mgmt(struct sk_buff *skb)
+{
+	struct htt_rx_desc *rxd;
+	u32 flags;
+
+	rxd = (void *)skb->data - sizeof(*rxd);
+	flags = __le32_to_cpu(rxd->attention.flags);
+
+	if (flags & RX_ATTENTION_FLAGS_MGMT_TYPE)
+		return true;
+
+	return false;
+}
+
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 {
 	struct htt_rx_desc *rxd;
@@ -944,7 +958,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			status = info.status;
 
 			/* Skip mgmt frames while we handle this in WMI */
-			if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL) {
+			if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
+			    ath10k_htt_rx_is_mgmt(msdu_head)) {
 				ath10k_htt_rx_free_msdu_chain(msdu_head);
 				continue;
 			}
-- 
1.7.9.5

