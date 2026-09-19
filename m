Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6123749F0;
	Sat, 19 Sep 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850645; cv=none; b=fh59yssGdx2cZWCI3reXIBosaJXNEbSNg5kPLyc83RCq7Nmo2p4ZZDaV48ZcxQ7VzOfoOvNU3Xpbo7JIB7gwmObry1WE5DrTE3FAsEM4lKt2/bt/+AsdLeXT45Bcb8IQVwaIoNHWIKaonhdUsZhHRd85LhflrRpa7BysQ+EmBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850645; c=relaxed/simple;
	bh=A99WF7XgsH2cfI5/e3IDMa/mJv47ybWr6d8kyD1eMI4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o1DLFyN3YHxsvWDq3T14rn1ceDAbtCdvMCu2uIm4kD07g1KgWMoGHQJNhziDwFlPRAIkldAK5ZpQEIlJoDr3kZPYWNmYeNNHwjwbu3T+8jhahywLBLhpRATAMa1JbiyKLSdEbm+JSU/ppciVGmqIymm9DgwbSA402aqNaIXVjrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XoUum+sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XoUum+sb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1CD0C2BCFB;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789850645;
	bh=A99WF7XgsH2cfI5/e3IDMa/mJv47ybWr6d8kyD1eMI4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XoUum+sbyjnqaOSNY6AUwIN3Lz2TBvGX+J6g1c03PJsqrWDvL5DcYPiBZxyo15+UN
	 pvwn92HEtm9Bb847YXfekuAKR+mpYpLjyUQvHMr2bx2E0MV50ASzi+miM/BoTI7bMo
	 avV/9BqkQYjLKlMjFBaruGrxb1Txn1KCgprQ8MyPd9Bt7F02k2AnmTjAR/w7FX68bS
	 TPuBxc4dzm1Q6hXBTclCFZfjmXPPK0ZFylZ7os3yRt4+CyIYQiCyV8uJPE78236MJi
	 czxB7lrpG+Nxtj6c6y2c8wpgccJk1EDRw0lAqahumbCpE+/QcBIQ4JG+yRZ/9xQNGF
	 S22mb4jNVzEIQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D586DC982D8;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Sun, 20 Sep 2026 05:44:06 +0900
Subject: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
In-Reply-To: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, kvalo@kernel.org, linux-kernel@vger.kernel.org, 
 Jes.Sorensen@gmail.com
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789850643; l=6457;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=ELcGIj3/1qa+I+rYa4pUTPcIEvRdg4LJVJ6OX7JJaPE=;
 b=uTxba9X02x6TPEKEvMraKPHDpYmSCZZVbBfHEyNQqaj6HGtwEgU4mEVvLH2CNjwI+uT+7/F3B
 zPJY7FyWL89D5/gOd1e4l7k4z6Byzyz5oCzbVmkuaAIg5nWyWLo3947
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: Kim Wooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

From: Kim Wooseok <5mghybrid@khu.ac.kr>

rtl8xxxu resubmits completed RX requests when more than eight URBs are
waiting on the pending list. It starts with 32 URBs, but frees them on
completion errors. After enough errors, the remaining pool can no longer
reach the submission threshold. Reception then stays stopped even after
the errors end. Temporary submission failures can leave a small batch
waiting with no further work scheduled, too.

Keep the URB when a completion reports EPROTO, EILSEQ, ETIME, EOVERFLOW,
ECOMM or ENOSR. Free its receive buffer and return the request to the
same pending list used by normal completions. ENOMEM/EAGAIN from startup
or worker submission uses this path as well, so a submission failure
cannot strand a request during recovery.

Use one delayed work item to submit the pending requests. An error
queues a retry after 100 ms without moving an existing reservation back.
If a normal completion takes the pending count above eight,
mod_delayed_work(..., 0) brings the work forward. This limits repeated
retries when reception is not progressing, while allowing normal traffic
to replenish the pool promptly. The 100 ms delay is therefore not a
minimum wait for each failed URB.

Keep the shutdown check, queue insertion and scheduling under the RX
lock. Stop sets shutdown under that lock, cancels the delayed work
synchronously, then drains active and pending requests. Cancellation and
device removal continue to free their URBs.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c     | 45 ++++++++++++++++++++++++++++-----------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 5ae3dbf5034ac..8e513a0cb2e24 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to di
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define RTL8XXXU_RX_URBS		32
 #define RTL8XXXU_RX_URB_PENDING_WATER	8
+#define RTL8XXXU_RX_URB_RETRY_DELAY_MS	100
 #define RTL8XXXU_TX_URBS		64
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
@@ -5855,9 +5856,8 @@ static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
 }
 
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
-				  struct rtl8xxxu_rx_urb *rx_urb)
+				  struct rtl8xxxu_rx_urb *rx_urb, bool retry)
 {
-	struct sk_buff *skb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
@@ -5865,16 +5865,13 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	if (!priv->shutdown) {
 		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
 		priv->rx_urb_pending_count++;
-		/*
-		 * Arm the worker under rx_urb_lock so this is atomic with the
-		 * shutdown check: moving it out of the lock would let a
-		 * completion arm the work after rtl8xxxu_stop() canceled it.
-		 */
-		if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
-			schedule_work(&priv->rx_urb_wq);
+		/* Serialize scheduling with the shutdown check and cancellation. */
+		if (retry)
+			queue_delayed_work(system_wq, &priv->rx_urb_wq,
+					   msecs_to_jiffies(RTL8XXXU_RX_URB_RETRY_DELAY_MS));
+		else if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
+			mod_delayed_work(system_wq, &priv->rx_urb_wq, 0);
 	} else {
-		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5901,7 +5898,7 @@ static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 			break;
 		case -ENOMEM:
 		case -EAGAIN:
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			rtl8xxxu_queue_rx_urb(priv, rx_urb, true);
 			break;
 		default:
 			usb_free_urb(&rx_urb->urb);
@@ -5926,7 +5923,8 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
 
-	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	priv = container_of(to_delayed_work(work), struct rtl8xxxu_priv,
+			    rx_urb_wq);
 	rtl8xxxu_submit_rx_urbs(priv, false);
 }
 
@@ -6585,10 +6583,23 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 
 		skb = NULL;
 		rx_urb->urb.context = NULL;
-		rtl8xxxu_queue_rx_urb(priv, rx_urb);
+		rtl8xxxu_queue_rx_urb(priv, rx_urb, false);
 	} else {
 		dev_dbg(dev, "%s: status %i\n",	__func__, urb->status);
-		goto cleanup;
+		switch (urb->status) {
+		case -EPROTO:
+		case -EILSEQ:
+		case -ETIME:
+		case -EOVERFLOW:
+		case -ECOMM:
+		case -ENOSR:
+			dev_kfree_skb(skb);
+			urb->context = NULL;
+			rtl8xxxu_queue_rx_urb(priv, rx_urb, true);
+			return;
+		default:
+			goto cleanup;
+		}
 	}
 	return;
 
@@ -7519,7 +7530,7 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend)
 	 * it drained via rtl8xxxu_submit_rx_urb(), so a worker still running
 	 * after the kill could submit a URB that escapes it.
 	 */
-	cancel_work_sync(&priv->rx_urb_wq);
+	cancel_delayed_work_sync(&priv->rx_urb_wq);
 
 	usb_kill_anchored_urbs(&priv->rx_anchor);
 	usb_kill_anchored_urbs(&priv->tx_anchor);
@@ -7832,7 +7843,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->tx_urb_lock);
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
 	spin_lock_init(&priv->rx_urb_lock);
-	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
+	INIT_DELAYED_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 	INIT_DELAYED_WORK(&priv->update_beacon_work, rtl8xxxu_update_beacon_work_callback);
 	skb_queue_head_init(&priv->c2hcmd_queue);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index eeb18eb0e4c0f..c6953051d9c40 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1809,7 +1809,7 @@ struct rtl8xxxu_priv {
 	struct list_head rx_urb_pending_list;
 	int rx_urb_pending_count;
 	bool shutdown;
-	struct work_struct rx_urb_wq;
+	struct delayed_work rx_urb_wq;
 
 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];

-- 
2.53.0


