Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F7838656D;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789284812; cv=none; b=gmVq4g/42VAeA4OPVxH6C9xyiTXI5fguKjSFra+9v27xe1pFH8n+0NHD+Uam2fR2h51qytVy/tPZXjfYoBLS95+jTV+YzQskLJsUyno3sWT6MaranTIhMyP8tc+i23r6kTJmjrJuLEtwWG/m6+LZLJCE1Cjo4ye72OuDcQF00Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789284812; c=relaxed/simple;
	bh=aKV60C/fq6tIKDwWhdZqx473UAKuuq700goUpnuUo10=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WyS4d+CTi1N/mbrqO7N63lbclZFyxGC+/tOF58qf7WOFiOm6nYLRGsmcwQqHwt0OHStG1KyebrhcL+rRRzDbKiO/e4y6E+PT8hPuPzypOsK5ks+ZGT3011FnU+TRZjX9T3XrLkn7w1nP9tVtzbWaXsgBm8qrVXeMxof2WmjcEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLCSgfLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLCSgfLA"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F6FBC2BCF5;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789284812;
	bh=aKV60C/fq6tIKDwWhdZqx473UAKuuq700goUpnuUo10=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YLCSgfLAFuRfjIc/FStMqKLjNYc+0DLbiKRDUenkWr4OymrD4OBgmTiITUKlgdPGR
	 h6PxwX2HwZLzDTF4VwauBDwrCupPQZXAgZVDdx9N+aAv7WvPp89rIVhnGonuKGSzIu
	 PpaeQiXamugglDuac+T9lhL24gejXFleJ8LXbZndk3Un2OlWwTveYYBLJrPm+RS1OH
	 SKZmm5bunnFYEwa24xIDrRjFOlfidMq5r1faVSs1Czp5KLcXT/K7vlveh2jIllqKfI
	 RPbpQSAiY4+UFaRkP+kVpNzGQmhihYuAaKL+WVZbFQiLJCEU759NKe0Dh0rxT2ThRb
	 /YAA4wENm9Mqg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5E1C88E56;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
From: kimwooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Sun, 13 Sep 2026 16:33:20 +0900
Subject: [PATCH rtw-next v2 2/4] wifi: rtl8xxxu: unwind incomplete receive
 startup
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-codex-rtw-rx-v2-v2-2-f09c964e0b96@khu.ac.kr>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
In-Reply-To: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, linux-kernel@vger.kernel.org, 
 kimwooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789284810; l=6426;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=F/UxAv0n5pFiROLUYSSO2c5d/aOGmW1/ktprFN1Zdro=;
 b=X2LxbCIAG5geqCIpfTjGjsOqhZRCqDz16bMC7jEUWwcWPRHZ3O4xud0/e+SQJnmBIbywsEDkv
 z3yhGB+ZfOQDFAy6yRTbQUePG6XcC0/dBf1vkmwB0HDX1DzfwetFizu
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: kimwooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

From: kimwooseok <5mghybrid@khu.ac.kr>

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, earlier requests may already be active. After a
successful submission, that allocation failure can also leave ret set
to zero. The error path then frees TX resources and disables RX filters
without draining the earlier RX requests, yet reports startup success.

Separate pool allocation from submission so an allocation failure can be
handled before any RX request is active. Introduce rtl8xxxu_alloc_rx_urbs()
to allocate all 32 wrappers, then rtl8xxxu_start_rx() to submit the
completed pool. Return ENOMEM for every RX or TX URB pool allocation
failure so a partial allocation is reported as an error.

Once submission begins, keep ENOMEM/EAGAIN failures queued for retry.
For other submission errors, rtl8xxxu_start_rx() frees the unsubmitted
requests and returns the error. Since earlier submissions may already be
active at that point, route the outer start failure through the existing
rtl8xxxu_stop() path. This drains queued work and active requests and
cleans up RF state and TX resources together. Interrupt URB submission
failure uses the same cleanup path.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 99 ++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 795a5ec2f8cd4..1932a9ec1970c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -58,6 +58,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to di
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
 
+static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend);
 static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb);
 
@@ -5832,6 +5833,27 @@ static void rtl8xxxu_free_rx_resources(struct rtl8xxxu_priv *priv)
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
+static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb;
+	int i;
+
+	/* No RX work is active until the complete pool has been allocated. */
+	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
+		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
+		if (!rx_urb)
+			return -ENOMEM;
+
+		usb_init_urb(&rx_urb->urb);
+		INIT_LIST_HEAD(&rx_urb->list);
+		rx_urb->hw = priv->hw;
+		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
+		priv->rx_urb_pending_count++;
+	}
+
+	return 0;
+}
+
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb)
 {
@@ -5900,6 +5922,44 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	}
 }
 
+static int rtl8xxxu_start_rx(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
+	unsigned long flags;
+	LIST_HEAD(local);
+	int ret;
+
+	spin_lock_irqsave(&priv->rx_urb_lock, flags);
+	list_splice_init(&priv->rx_urb_pending_list, &local);
+	priv->rx_urb_pending_count = 0;
+	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
+
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del_init(&rx_urb->list);
+		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
+		switch (ret) {
+		case 0:
+			break;
+		case -ENOMEM:
+		case -EAGAIN:
+			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			break;
+		default:
+			usb_free_urb(&rx_urb->urb);
+			goto free_remaining;
+		}
+	}
+
+	return 0;
+
+free_remaining:
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del(&rx_urb->list);
+		usb_free_urb(&rx_urb->urb);
+	}
+	return ret;
+}
+
 /*
  * The RTL8723BU/RTL8192EU vendor driver use coexistence table type
  * 0-7 to represent writing different combinations of register values
@@ -7408,7 +7468,6 @@ static void rtl8xxxu_watchdog_callback(struct work_struct *work)
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	unsigned long flags;
 	int ret, i;
@@ -7423,14 +7482,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts) {
 		ret = rtl8xxxu_submit_int_urb(hw);
 		if (ret)
-			goto exit;
+			goto error_out;
 	}
 
 	for (i = 0; i < RTL8XXXU_TX_URBS; i++) {
 		tx_urb = kmalloc_obj(struct rtl8xxxu_tx_urb);
 		if (!tx_urb) {
-			if (!i)
-				ret = -ENOMEM;
+			ret = -ENOMEM;
 
 			goto error_out;
 		}
@@ -7441,31 +7499,21 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		priv->tx_urb_free_count++;
 	}
 
+	ret = rtl8xxxu_alloc_rx_urbs(priv);
+	if (ret)
+		goto error_out;
+
 	priv->tx_stopped = false;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
 	priv->shutdown = false;
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
-	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
-		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
-		if (!rx_urb) {
-			if (!i)
-				ret = -ENOMEM;
-
-			goto error_out;
-		}
-		usb_init_urb(&rx_urb->urb);
-		INIT_LIST_HEAD(&rx_urb->list);
-		rx_urb->hw = hw;
-
-		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret)
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-	}
+	ret = rtl8xxxu_start_rx(priv);
+	if (ret)
+		goto error_out;
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-exit:
 	/*
 	 * Accept all data and mgmt frames
 	 */
@@ -7478,13 +7526,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	return ret;
 
 error_out:
-	rtl8xxxu_free_tx_resources(priv);
-	/*
-	 * Disable all data and mgmt frames
-	 */
-	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
-	rtl8xxxu_write16(priv, REG_RXFLTMAP0, 0x0000);
-
+	rtl8xxxu_stop(hw, false);
 	return ret;
 }
 
@@ -7820,6 +7862,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->tx_urb_lock);
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
 	spin_lock_init(&priv->rx_urb_lock);
+	priv->shutdown = true;
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 	INIT_DELAYED_WORK(&priv->update_beacon_work, rtl8xxxu_update_beacon_work_callback);

-- 
2.48.1


