Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EE244F54F;
	Mon, 21 Sep 2026 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977592; cv=none; b=GeF6kUX6DJSL80iMO5dPpxnXR/mM0f2qYa1OiPrY64nvyLI/Kpt8y+tE7KcXvZoiciseX9+NcnFBMrm/EmMew7Iy+mUwet96sbLVIMF23anyImp8Eg+Wcuz73dXEqXf7IHhEAiKqHW7uoSl3qINNNh+FLaKjtrYnUJXX3mUYDw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977592; c=relaxed/simple;
	bh=YzeRJI+k51HfWcyQp+4KPivjBZtcOJ98l1A4EKDeL6o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cdWSEr1vsjb6fx6oxfVsT7gSzDf/OorEhtgFt1t2DqBuUPVPVNaiLdUaL0NbOI5IRtRxMZ1E6YScz2JAiF1KHkV5+/d7Lh4rMFVvl5e9x5mCAUi5gQY7F/HX32BUuDC+X/pne1C2PK5wr8MU3g1MFMazDn1WehheJrFcBMYxCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaH6Mfln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaH6Mfln"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 177B8C2BCFD;
	Mon, 21 Sep 2026 07:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789977592;
	bh=YzeRJI+k51HfWcyQp+4KPivjBZtcOJ98l1A4EKDeL6o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KaH6MflnuvLkAnFTDDAdcXjYv2Qj3/cZvmAg/J5vb1G2yix4mYhM1QqwwpYn9U3ZK
	 WIFD35oGeKllX3L/XDfIjZocAoQQQ0so9nl7fcbFnYW8CpDHKzpA9SzU9nDMNN1RHi
	 MtYG8i2bw2/kTq57ixhO2XYjjPTm4JR+wBTZH71JFIPBByjDNAYxv0rrkzUFDl21Ml
	 LVSiDrFABVykhcetuCi38AIszf/XVodi6C9pXwi6yIuEO7wQ/VV9z5Nu+cR5GVPzGv
	 b18ZZmApZMc2Cqb5xM+g0b5BDBlhXs02GFz0OP+bHqwpX42rQM8rPd7LweB1Ualo6C
	 jzzm3AvExBcDw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FE1C982F6;
	Mon, 21 Sep 2026 07:59:51 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Mon, 21 Sep 2026 16:59:51 +0900
Subject: [PATCH rtw-next v4 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-codex-rtl-rx-v3-submit-v4-3-eeb09fe8f791@khu.ac.kr>
References: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
In-Reply-To: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 linux-kernel@vger.kernel.org, Kim Wooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789977589; l=6556;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=s5LeAHyjThLc6mAtyZ76vXgD5nPgBRiYvXbrCmu0990=;
 b=YObtkdvOMk+XG1WWAVnXkHgOmGgdoUHXvEkcPBMAUaJMcqBe2K2HJdatthNn8lrllh7AB6Cx6
 dkFEgSu1Ca6C8FvlVTohaqf6UYgrL//bDqu+AUq8e5WL7nkaiUDVAhw
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
 drivers/net/wireless/realtek/rtl8xxxu/core.c     | 46 +++++++++++++++---------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 5cd6498cc47f2..3d0c22db30a80 100644
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
@@ -5856,9 +5857,8 @@ static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
 }
 
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
-				  struct rtl8xxxu_rx_urb *rx_urb)
+				  struct rtl8xxxu_rx_urb *rx_urb, bool defer_schedule)
 {
-	struct sk_buff *skb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
@@ -5866,16 +5866,13 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
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
+		if (defer_schedule)
+			schedule_delayed_work(&priv->rx_urb_wq,
+					      msecs_to_jiffies(RTL8XXXU_RX_URB_RETRY_DELAY_MS));
+		else if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
+			mod_delayed_work(system_percpu_wq, &priv->rx_urb_wq, 0);
 	} else {
-		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5902,7 +5899,7 @@ static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 			break;
 		case -ENOMEM:
 		case -EAGAIN:
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			rtl8xxxu_queue_rx_urb(priv, rx_urb, true);
 			break;
 		default:
 			usb_free_urb(&rx_urb->urb);
@@ -5925,7 +5922,8 @@ static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
-	struct rtl8xxxu_priv *priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	struct rtl8xxxu_priv *priv = container_of(to_delayed_work(work),
+					       struct rtl8xxxu_priv, rx_urb_wq);
 
 	rtl8xxxu_submit_rx_urbs(priv, false);
 }
@@ -6585,10 +6583,24 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 
 		skb = NULL;
 		rx_urb->urb.context = NULL;
-		rtl8xxxu_queue_rx_urb(priv, rx_urb);
+		rtl8xxxu_queue_rx_urb(priv, rx_urb, false);
 	} else {
 		dev_dbg(dev, "%s: status %i\n",	__func__, urb->status);
-		goto cleanup;
+
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
 
@@ -7519,7 +7531,7 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend)
 	 * it drained via rtl8xxxu_submit_rx_urb(), so a worker still running
 	 * after the kill could submit a URB that escapes it.
 	 */
-	cancel_work_sync(&priv->rx_urb_wq);
+	cancel_delayed_work_sync(&priv->rx_urb_wq);
 
 	usb_kill_anchored_urbs(&priv->rx_anchor);
 	usb_kill_anchored_urbs(&priv->tx_anchor);
@@ -7832,7 +7844,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
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


