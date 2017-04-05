Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46778 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdDEHLm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:11:42 -0400
Subject: [PATCH 6/7] ath10k: convert __ath10k_sdio_write_async() to use
 ath10k_sdio_write()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:07:36 +0300
Message-ID: <149137605651.4898.4712041956291103322.stgit@potku.adurom.net> (sfid-20170405_091145_571352_BD451BE5)
In-Reply-To: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
References: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c |    9 +++++----
 drivers/net/wireless/ath/ath10k/sdio.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 301355228cfa..8ea1629c7bae 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1304,9 +1304,11 @@ static void __ath10k_sdio_write_async(struct ath10k *ar,
 	int ret;
 
 	skb = req->skb;
-	ret = ath10k_sdio_read_write_sync(ar, req->address,
-					  skb->data, skb->len,
-					  req->request);
+	ret = ath10k_sdio_write(ar, req->address, skb->data, skb->len);
+	if (ret)
+		ath10k_warn(ar, "failed to write skb to 0x%x asynchronously: %d",
+			    req->address, ret);
+
 	if (req->htc_msg) {
 		ep = &ar->htc.endpoint[req->eid];
 		ath10k_htc_notify_tx_completion(ep, skb);
@@ -1355,7 +1357,6 @@ static int ath10k_sdio_prep_async_req(struct ath10k *ar, u32 addr,
 	}
 
 	bus_req->skb = skb;
-	bus_req->request = HIF_WRITE;
 	bus_req->eid = eid;
 	bus_req->address = addr;
 	bus_req->htc_msg = htc_msg;
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/ath/ath10k/sdio.h
index d1e4f78ddaeb..1bce56447e53 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -110,7 +110,7 @@ struct ath10k_sdio_bus_request {
 
 	/* sdio address */
 	u32 address;
-	u32 request;
+
 	struct sk_buff *skb;
 	enum ath10k_htc_ep_id eid;
 	int status;
