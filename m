Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1138DC7F
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 20:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789245006; cv=pass; b=TK4HCvJcYaP3SCdTGaNEnVl67+JJQMNPKvNen/a3+6f1KWCHpPcC+t1xJzg+eZO4tC4bSWaeeBjL5eCIFt4G3Jmho045oz8qy0PN96vy57VHfGkW8U/IllJLxC+xS+ToYAG9UpXcsxxiWx9C9AoeuJaxkkWRkiO2Cug2hl95BbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789245006; c=relaxed/simple;
	bh=4BJFZkbbQM/TpEDNgfqVCNZkBAyQZLPvnY6GdgSNQTA=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfFMFMVScIMjXGq6VtmD/dLHZIwp5fGwpZAzVvU+QRxL4YTseAmBm5bV4F3I/PpBkSH262uk24sRB0R0jEIOPywHuErPfOBvVifNZIAvLLJYdPj6Kvf8wVxI9BulfCX944otjVMyd4RcV6hB3OgjjIkyB9plmTRoxcme7rSEltQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=GlNoYTu4; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="GlNoYTu4"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b76462aae9so561451e87.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 13:30:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789245002; cv=none;
        d=google.com; s=arc-20260327;
        b=ALHiDgByDR4CuL1nT2SgBkTT6GmDiD6CmhuHHfR/6/YBsqcpQcZqrgO6gwQpZYfAuP
         x+2yAiRdSt1GlP3dwi9f3Jn+xDKblSL7J7WBHDLM0gok9lA2uiERX/3DMZX/Ywkxe3RM
         oqw87sw7glQmSUMv1OAV8wsIJQAFRGgRXdkWo6oaVB+LZFxco4FRQjtFa9vBvrL5u9wi
         hBqLy4mtlG7nODbl60T3m9VI6pg82z9EB/Uy33Qhnb6yafRxePX8UjlMsX3pcR6tkO9F
         FuQ6AkO8Fg+dCnV4X/YAWP6HpS2VkG8veyQVBFbjA3FruixRdrABQ7Ohz/tp5N2529Gw
         6mVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=g6Pm8uj00vDZGpmdO+6bFaNiQGBkyOpHFptkpjaCoQs=;
        fh=TFULXDBgHlLqMQdfUyAurUJgwNjfZoZpfLyj5gKGrno=;
        b=OuYwBxRRQhsqmDptGVeHL/OymYa4WAODoF9bdVEnzWYbgnb+xnuLHehiwIvachYiB3
         mJTv1DqDleJJ1FzwFmXBtbEEeFIOr3rAqe0NvUUt0P2WP71d8r1F+UyvNvVZpsaD89o6
         PG/J67YgmGERaQfomSfKeYR+cLof9gv6ibNjLkLajphcbh3cK1xnNU2A+KjZEdPpoHe7
         jhrHfVycETgzQUo/AJlwns1rKCrcctQZ2cQ4P9d0wbXYvn3mQEc4tX+oIqmsdjcmGJPB
         AEL0q2N61YH2ZdgkJTUFe8m6YZmS+XPiytjQcQD6gy3rgWRPU5bzdqXh5MVmEZOQ8lJu
         CgVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789245002; x=1789849802; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6Pm8uj00vDZGpmdO+6bFaNiQGBkyOpHFptkpjaCoQs=;
        b=GlNoYTu4/tJjOnuuIuVoCg7OKQrZlu3KDrl2/ZpI4abGmS26r8/D7u6Uf9jN+NAlDV
         HiUM4DWBGMAsukab+biS6AwkuM8BG27YyQ3+93PcOXpN3HZ2ieu1vzecwnsJ2qRqOjA6
         5gePCXbv1HadLgNn5sOaL8i1+tIgW7dtzDw2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789245002; x=1789849802;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g6Pm8uj00vDZGpmdO+6bFaNiQGBkyOpHFptkpjaCoQs=;
        b=kDP6Q7xEgTU04+azQbvVaFqj/aWYb5jb1wxhRQdwnp24pn2SLomqf7N/RXVFwQdsSj
         gB5f9Lga5n//6dX2zMX5Ur5tT5/KQ/KA9dYFbDghZjGFPy40OXgpAyUwgmig4ve7x1F2
         grJa3W5aU8CZf8trA/xlYYwd6RljyQd8hzotbfenUCUrNljmaRHKvfLs2cECtcgTjw9a
         esUA6jFwQ0VGZCX3+6cWrvdwIeceb1QqJoWnuJBMIKsjgEn3PcsK2oGGxnqv10X2qh3e
         6x+gZxDvtGnyTmu8dX9WhWRMVc7VElHJO9j/8bKsnx9lb4BjplkT+aAzI1a20MNE7dxC
         TQlQ==
X-Gm-Message-State: AFuF++ljTSsB5QjpL2ssBEhrjEAh8DJk7T16zExcGYB5TdwYT1uA97Xo
	vMODwv7KPpx5cXLtQ57fbMRJx7YTpGCy6wbS63Jbp8QLYBJ3yIjiw31bmBpKaEBZN8KHszDNrZD
	638zxOLGF+vBnb5GuDjlWJJXdCpyq992X7NklpbN6DA==
X-Gm-Gg: AYBFou2iOk7+zExDGORP8/Of3+J/GP/S7JBRVRn3hWRhQq+JUcTJDwMMnjwQWcxIFUu
	cCkLTDkqfa62hSv8LaCnhydS5MSiZ2xevjpp8n3zW5B/mealU9/Mcj/QcjuGA9lJNILFq5IWSOC
	dSBOh0+D7KbT+D7IhAWvL8tilddHdhdT25QVPN/MfZy2vwzqqrvCPKOKdkJb+488tBQm3GnsKVs
	ACg0NVr9Ed+6YFKQfG9BRuPH0/syCgHkngQF8rltIfmIUdCbFDZjCN5qkY4mKYb6mmMK3YTaoaN
	3LVT9S9CDbQb8n3XqjBNEUy6tQnKmr4tFO7vTp9nnnhEocpBvvg=
X-Received: by 2002:a05:6512:aca:b0:5b6:1a7c:27 with SMTP id
 2adb3069b0e04-5b8a8ebef8bmr688989e87.42.1789245002235; Sat, 12 Sep 2026
 13:30:02 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:30:00 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 13:28:22 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 15:20:17 -0500
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 12 Sep 2026 16:09:52 -0400
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
References: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
Date: Sat, 12 Sep 2026 16:30:00 -0400
X-Gm-Features: AcwNN1WT4aMWlmVlxnGTGx87l59oN-wznF_pEmsob68vpR5yn0wdR6MFNtw3CH4
Message-ID: <CAH1Bc_y9JSo1w=sM4Rgu9wRmoTiN2axVrz87Ttwmnpnp-XoZ6A@mail.gmail.com>
Subject: [PATCH wireless 3/4] wifi: rtl8xxxu: preserve RX requests across
 recoverable transfer errors
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

rtl8xxxu normally reuses 32 RX URBs, scheduling the submission worker when
more than eight completed requests have accumulated on the pending list.
Completion errors free URBs instead. A finite error burst can therefore
leave eight or fewer requests, which cannot reach that threshold after
they all complete. With no request in flight and no worker pending or
running, RX stays stopped even after the errors cease.

To prevent these errors from shrinking the pool below the number
needed for normal resubmission, retain URBs after EPROTO, EILSEQ, ETIME,
EOVERFLOW, ECOMM and ENOSR completions. EHCI can report ENOSR for IN data-buffer
errors, and FHCI maps RX buffer overrun to ECOMM. Free the failed
transfer's skb and keep its URB on a separate retry list.

Keeping the URBs is only part of the fix: the driver must also submit
them again without waiting for nine requests to accumulate. When the
first failed request enters the retry list, schedule delayed work for
100 ms. Further failures join that list while the work is pending.
When it runs, move the collected requests to normal pending and schedule
the submission worker even if only one request is waiting. Keeping
failed requests separate until then prevents normal completions from
triggering an immediate retry; successful RX keeps its existing batching.

A retry can itself fail with ENOMEM/EAGAIN. Returning that request to
normal pending would bring back the same threshold problem, so route
temporary submission failures from both start and the RX worker through
the delayed retry list as well.

Serialize retry insertion and scheduling with shutdown so late
completions cannot schedule fresh retries during stop. Cancel retry work
first, then wait for submission work before killing active URBs, so a
running worker cannot submit a request after the active requests have
been drained.

Cancellation and removal keep their release behavior. EPIPE endpoint-halt
recovery remains outside this change because it requires quiescing
requests and distinguishing recovery cancellation from shutdown.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 71 +++++++++++++++++--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  3 +
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c
b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 1932a9ec1970c..883c9a56f52a4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation
pages (range 1-127, 0 to di
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define RTL8XXXU_RX_URBS		32
 #define RTL8XXXU_RX_URB_PENDING_WATER	8
+#define RTL8XXXU_RX_URB_RETRY_DELAY_MS	100
 #define RTL8XXXU_TX_URBS		64
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
@@ -5823,6 +5824,11 @@ static void rtl8xxxu_free_rx_resources(struct
rtl8xxxu_priv *priv)

 	spin_lock_irqsave(&priv->rx_urb_lock, flags);

+	list_splice_tail_init(&priv->rx_urb_retry_list,
+			      &priv->rx_urb_pending_list);
+	priv->rx_urb_pending_count += priv->rx_urb_retry_count;
+	priv->rx_urb_retry_count = 0;
+
 	list_for_each_entry_safe(rx_urb, tmp,
 				 &priv->rx_urb_pending_list, list) {
 		list_del(&rx_urb->list);
@@ -5881,6 +5887,47 @@ static void rtl8xxxu_queue_rx_urb(struct
rtl8xxxu_priv *priv,
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }

+static void rtl8xxxu_rx_urb_retry_work(struct work_struct *work)
+{
+	struct rtl8xxxu_priv *priv = container_of(to_delayed_work(work),
+						struct rtl8xxxu_priv,
+						rx_urb_retry_wq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_urb_lock, flags);
+
+	if (!priv->shutdown && priv->rx_urb_retry_count) {
+		list_splice_tail_init(&priv->rx_urb_retry_list,
+				      &priv->rx_urb_pending_list);
+		priv->rx_urb_pending_count += priv->rx_urb_retry_count;
+		priv->rx_urb_retry_count = 0;
+		/* An error must not leave a small batch waiting indefinitely. */
+		schedule_work(&priv->rx_urb_wq);
+	}
+
+	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
+}
+
+static void rtl8xxxu_queue_rx_urb_retry(struct rtl8xxxu_priv *priv,
+					struct rtl8xxxu_rx_urb *rx_urb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_urb_lock, flags);
+
+	if (!priv->shutdown) {
+		list_add_tail(&rx_urb->list, &priv->rx_urb_retry_list);
+		priv->rx_urb_retry_count++;
+		/* Keep normal completions from bypassing the error backoff. */
+		queue_delayed_work(system_wq, &priv->rx_urb_retry_wq,
+				   msecs_to_jiffies(RTL8XXXU_RX_URB_RETRY_DELAY_MS));
+	} else {
+		usb_free_urb(&rx_urb->urb);
+	}
+
+	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
+}
+
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
@@ -5904,7 +5951,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
 		/*
 		 * If out of memory or temporary error, put it back on the
-		 * queue and try again. Otherwise the device is dead/gone
+		 * delayed queue and try again. Otherwise the device is dead/gone
 		 * and we should drop it.
 		 */
 		switch (ret) {
@@ -5912,7 +5959,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			break;
 		case -ENOMEM:
 		case -EAGAIN:
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			rtl8xxxu_queue_rx_urb_retry(priv, rx_urb);
 			break;
 		default:
 			dev_warn(&priv->udev->dev,
@@ -5942,7 +5989,7 @@ static int rtl8xxxu_start_rx(struct rtl8xxxu_priv *priv)
 			break;
 		case -ENOMEM:
 		case -EAGAIN:
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			rtl8xxxu_queue_rx_urb_retry(priv, rx_urb);
 			break;
 		default:
 			usb_free_urb(&rx_urb->urb);
@@ -6618,7 +6665,20 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 		rtl8xxxu_queue_rx_urb(priv, rx_urb);
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
+			rtl8xxxu_queue_rx_urb_retry(priv, rx_urb);
+			return;
+		default:
+			goto cleanup;
+		}
 	}
 	return;

@@ -7549,6 +7609,7 @@ static void rtl8xxxu_stop(struct ieee80211_hw
*hw, bool suspend)
 	 * it drained via rtl8xxxu_submit_rx_urb(), so a worker still running
 	 * after the kill could submit a URB that escapes it.
 	 */
+	cancel_delayed_work_sync(&priv->rx_urb_retry_wq);
 	cancel_work_sync(&priv->rx_urb_wq);

 	usb_kill_anchored_urbs(&priv->rx_anchor);
@@ -7861,9 +7922,11 @@ static int rtl8xxxu_probe(struct usb_interface
*interface,
 	INIT_LIST_HEAD(&priv->tx_urb_free_list);
 	spin_lock_init(&priv->tx_urb_lock);
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
+	INIT_LIST_HEAD(&priv->rx_urb_retry_list);
 	spin_lock_init(&priv->rx_urb_lock);
 	priv->shutdown = true;
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
+	INIT_DELAYED_WORK(&priv->rx_urb_retry_wq, rtl8xxxu_rx_urb_retry_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 	INIT_DELAYED_WORK(&priv->update_beacon_work,
rtl8xxxu_update_beacon_work_callback);
 	skb_queue_head_init(&priv->c2hcmd_queue);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index eeb18eb0e4c0f..ee55f6cc7f012 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1808,8 +1808,11 @@ struct rtl8xxxu_priv {
 	spinlock_t rx_urb_lock;
 	struct list_head rx_urb_pending_list;
 	int rx_urb_pending_count;
+	struct list_head rx_urb_retry_list;
+	int rx_urb_retry_count;
 	bool shutdown;
 	struct work_struct rx_urb_wq;
+	struct delayed_work rx_urb_retry_wq;

 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];
-- 
2.48.1
