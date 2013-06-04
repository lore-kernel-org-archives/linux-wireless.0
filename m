Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50493 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3FDSh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 14:37:58 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lj83k-1U728A1faw-00dBfK for
 <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 20:37:56 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: fix skb_under_panic error
Date: Tue,  4 Jun 2013 20:37:44 +0200
Message-Id: <1370371064-6903-1-git-send-email-linux@rempel-privat.de> (sfid-20130604_203801_867171_A8EBD9A1)
In-Reply-To: <51ADBC01.6090202@blackshift.org>
References: <51ADBC01.6090202@blackshift.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This error seems to be really rare, and we do not know real couse of it.
But, in any case, we should check size of head before reducing it.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Reported-by: Marc Kleine-Budde <mkl@blackshift.org>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index aac4a40..2901351 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -26,6 +26,12 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	struct htc_endpoint *endpoint = &target->endpoint[epid];
 	int status;
 
+	if (skb_headroom(skb) < len &&
+	    pskb_expand_head(skb, len, 0, GFP_ATOMIC)) {
+		dev_err(target->dev, "Unable to expand headrom to %d\n", len);
+		return -ENOMEM;
+	}
+
 	hdr = (struct htc_frame_hdr *)
 		skb_push(skb, sizeof(struct htc_frame_hdr));
 	hdr->endpoint_id = epid;
-- 
1.8.1.2

