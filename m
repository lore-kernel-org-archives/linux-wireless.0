Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6CF374E48;
	Sat, 19 Sep 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850645; cv=none; b=H3lBRhoaffk40i/l6vJfUG9efagDP6mhRFlbvmL1xdMc4na7UJJHNvZ3Tocgz9SE65dDNphtXxy7OaIA+5vrqXC/Hbrp79uQbpjqLc5GY4T+s7iCLJj9BNBOzZkJ4ii2j+XpCapRF6aw2rM5FSQ9xc3tDQvSnBdFzHwqsDqY7+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850645; c=relaxed/simple;
	bh=4W78FwMWh4CkJw7GIiqqdH7RuAbrFba5NTIWdCi/LyU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kh6mcRPmTi9HRAW+5q/QkMNa509h/ZsHYYoFsHlon9lzjsunR6nzfLexoQgu8xgXVS182VDp5vk3xE4RDv0vqmX1C+/vURxnS/SXl00pRggzJHpm25TTJ1neC9xzcgr4Dkw/8qhVgvb53a0XSZbN15+75EzTzxbUmfWA2aPT4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8vfZUvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8vfZUvY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E44C8C2BCFA;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789850645;
	bh=4W78FwMWh4CkJw7GIiqqdH7RuAbrFba5NTIWdCi/LyU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F8vfZUvYre9WAhv6mYfyJR5ReD5xJWJSRVVkeDNYQys8vy53VjmNSt3DRt3DMOQj1
	 XFzD/6QOE4j6AnJN5bZsUTaUjae9lnQ/RRfBu48Zua7DvfQm7xCv+D0rF0NHlfZw5B
	 kc5/wqsyOfY/W7uCeGNpFEah2h6Vy7Ub7GwgG1rBZI3gMOaBXICqE2W5f0YF7fYgSt
	 0W+mYaruMZkfviJZX6ShEhuGtgF0xhhr8mFHgdcSML9zvyJsy2uh++8oy1gXBmtijU
	 V4kmDypBCnTOkLUWXjWlB0kfLqMZJx4i/UkYNv0zxX4m+ZUyqqM+4wYMiGIYHe3QMO
	 7GmJkgSh1l5TQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7805C982DF;
	Sat, 19 Sep 2026 20:44:04 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Sun, 20 Sep 2026 05:44:05 +0900
Subject: [PATCH rtw-next v3 2/3] wifi: rtl8xxxu: unwind incomplete receive
 startup
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-codex-rtl-rx-v3-submit-v3-2-883d11351963@khu.ac.kr>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
In-Reply-To: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, kvalo@kernel.org, linux-kernel@vger.kernel.org, 
 Jes.Sorensen@gmail.com
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789850643; l=6605;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=OyDx5rqQosEORE8l/erZWFaYVL1RAiawqnAc+isUD8g=;
 b=AyIU/A7O/gd25EvcDw8HcPXZvk2amnaZxTQiI8/QUnLjF1+cdS8aa2Igk2w7J6cq0qe9YozoV
 ERUJ/87p5VfBJSWw7dRp39BX6dFeDVxX5l0FYtV/yCCWGoaodwc1X+A
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: Kim Wooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

From: Kim Wooseok <5mghybrid@khu.ac.kr>

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, the error path frees the TX pool but leaves earlier RX
requests active. A partial TX or RX allocation failure can also leave
ret at zero, so start reports success despite the incomplete setup.

Allocate the RX pool before submitting any of it, and return ENOMEM
whenever a pool allocation fails. Pass start errors through
rtl8xxxu_stop(), including interrupt URB submission failures, so the
existing stop path cancels work and releases both active requests and
partially allocated pools.

Share the submission loop with the RX worker. Both callers keep requests
that fail with ENOMEM/EAGAIN. For a fatal error during startup, free the
rest of the unsubmitted batch and return the error so start can unwind.
In the worker, free only the failed request and continue with the rest
of the batch.

Keep the allocation loop in a small helper so the setup and error paths
in start remain easy to follow.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
 1 file changed, 54 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 795a5ec2f8cd4..5ae3dbf5034ac 100644
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
@@ -5859,32 +5881,21 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
-static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 {
-	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
-	struct list_head local;
 	unsigned long flags;
+	LIST_HEAD(local);
 	int ret;
 
-	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
-	INIT_LIST_HEAD(&local);
-
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
-
 	list_splice_init(&priv->rx_urb_pending_list, &local);
 	priv->rx_urb_pending_count = 0;
-
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
 	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
 		list_del_init(&rx_urb->list);
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		/*
-		 * If out of memory or temporary error, put it back on the
-		 * queue and try again. Otherwise the device is dead/gone
-		 * and we should drop it.
-		 */
 		switch (ret) {
 		case 0:
 			break;
@@ -5893,11 +5904,30 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
+			usb_free_urb(&rx_urb->urb);
+			if (startup)
+				goto free_remaining;
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			usb_free_urb(&rx_urb->urb);
 		}
 	}
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
+static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+{
+	struct rtl8xxxu_priv *priv;
+
+	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	rtl8xxxu_submit_rx_urbs(priv, false);
 }
 
 /*
@@ -7408,7 +7438,6 @@ static void rtl8xxxu_watchdog_callback(struct work_struct *work)
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	unsigned long flags;
 	int ret, i;
@@ -7423,14 +7452,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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
@@ -7441,31 +7469,21 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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
+	ret = rtl8xxxu_submit_rx_urbs(priv, true);
+	if (ret)
+		goto error_out;
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-exit:
 	/*
 	 * Accept all data and mgmt frames
 	 */
@@ -7478,13 +7496,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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
 

-- 
2.53.0


