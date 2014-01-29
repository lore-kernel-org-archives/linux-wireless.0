Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64556 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaA2TIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:49 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Li1hG-1VVhGE192Q-00n7YY for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:48 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 13/13] ath9k_htc: catch fw panic pattern
Date: Wed, 29 Jan 2014 20:07:04 +0100
Message-Id: <1391022424-21087-12-git-send-email-linux@rempel-privat.de> (sfid-20140129_200853_335164_343FDD23)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... and print what we get.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 36 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_hst.h | 12 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index aac4a40..a0ff5b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -358,6 +358,36 @@ ret:
 		kfree_skb(skb);
 }
 
+static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
+				      struct sk_buff *skb)
+{
+	uint32_t *pattern = (uint32_t *)skb->data;
+
+	switch (*pattern) {
+	case 0x33221199:
+		{
+		struct htc_panic_bad_vaddr *htc_panic;
+		htc_panic = (struct htc_panic_bad_vaddr *) skb->data;
+		dev_err(htc_handle->dev, "ath: firmware panic! "
+			"exccause: 0x%08x; pc: 0x%08x; badvaddr: 0x%08x.\n",
+			htc_panic->exccause, htc_panic->pc,
+			htc_panic->badvaddr);
+		break;
+		}
+	case 0x33221299:
+		{
+		struct htc_panic_bad_epid *htc_panic;
+		htc_panic = (struct htc_panic_bad_epid *) skb->data;
+		dev_err(htc_handle->dev, "ath: firmware panic! "
+			"bad epid: 0x%08x\n", htc_panic->epid);
+		break;
+		}
+	default:
+		dev_err(htc_handle->dev, "ath: uknown panic pattern!\n");
+		break;
+	}
+}
+
 /*
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
@@ -379,6 +409,12 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
 	epid = htc_hdr->endpoint_id;
 
+	if (epid == 0x99) {
+		ath9k_htc_fw_panic_report(htc_handle, skb);
+		kfree_skb(skb);
+		return;
+	}
+
 	if (epid >= ENDPOINT_MAX) {
 		if (pipe_id != USB_REG_IN_PIPE)
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index e1ffbb6..06474cc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -77,6 +77,18 @@ struct htc_config_pipe_msg {
 	u8 credits;
 } __packed;
 
+struct htc_panic_bad_vaddr {
+	__be32 pattern;
+	__be32 exccause;
+	__be32 pc;
+	__be32 badvaddr;
+} __packed;
+
+struct htc_panic_bad_epid {
+	__be32 pattern;
+	__be32 epid;
+} __packed;
+
 struct htc_ep_callbacks {
 	void *priv;
 	void (*tx) (void *, struct sk_buff *, enum htc_endpoint_id, bool txok);
-- 
1.8.5.3

