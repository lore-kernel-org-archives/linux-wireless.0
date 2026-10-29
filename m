Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281723;
	b=mD1D0RKRdh8flcnl4b5J51+bP/9kXG3gFjOlILZOtaINkfSeJP36np8Lx6foo7SdUS2k
	 kuCAlooRUcUVTRBphdnf3LlSTPpecCuqBVhEi0mHj6E/rnG4C/o9gN+mYioGuu758iI67
	 2warbjG7bd/PJSX23ODf0IlvyvMPwPhsv2fxS6dBJEG5FwT7E5xlURLmlL5VYpWO9W/7n
	 LFHjlhDhaFNBB3CyRZWFaVZNblf7NnwwLKQQv62pC3MfQVHW/arR7Rwk2pc7zC4YbDDCf
	 EL2i3i0+911jltbV/vhNVyM7xbjgvRUi6l993rkn4nqPrm22oRvVwVXstY0l9o4f3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281723;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Pcc2o31dnyq27UxgXPWW34srR7YdnuSDHgxI+x836g0=;
	b=lYi96rMbUxT+bcAoAxsYV3QvuwdVuxn2t/bdDwGkTmLWyOT04kIc20fKfZ+8SS+BMKGN
	 DBPum/sogu5Uz39ol9ECGHzZrCV0XbF8PYjzfZJz658PDylbweteHYIHwyeUJmdBtmqhD
	 kEGZvjdyDaJxtiIjb1T7MpCzg5XIctMZdVz59CQdo3BAFtpsHaM8rYhd5kQ9EUoMN650J
	 jdeDXcTQyWOKV4Wq3Ic5r6YcutpvwmOp5kxdpXH4jlzkvLwiJMft9hyLzYvom3TSMMR/b
	 rwx7dakjYHvwIVI0JWFZU8vZ//8p/Mw19rskkY8okRXKc0fFAA1doxY0QM7dCRp+ANA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ItZl/Yv/";
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BBB60A3821
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9BBB60A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ItZl/Yv/
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdaefe02d5dso616218a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281722; x=1793886522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pcc2o31dnyq27UxgXPWW34srR7YdnuSDHgxI+x836g0=;
        b=ItZl/Yv/W94nvvobd8i54XLI7CzdmR/sKxOfCbsu74a4BGm7U7G8osqcwtXctt+lIg
         G/3Z1eguuRocKS9YdIKz4+S5LjIg0gO7Di21ouyUeemcqfHUZH14QtUC2qKhJXDom3Di
         8Z5SVRTqNMACU+vE6uXYHTKIT7tyQX987BNTEnUPHYUWj+TzeYwalOWj4aqlFtHDXThp
         rlb2ZyDiuOlilHuvGMoZUtW3/hbwR1iWp4AbRppM525rCJxgysC8Yh1TADBc/cdbcY+/
         XN21Rvn9JOBRaKhh71zq+embbid6jh6yT6m37/flfhcUlxFS1FzS1k4Vli5P2PsK7tF6
         jmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281722; x=1793886522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pcc2o31dnyq27UxgXPWW34srR7YdnuSDHgxI+x836g0=;
        b=ZSow7h751/lO4AXJvW75ExDg041ofX26Q2Nwe1EtG+AqIWOVsnmz/A+1Q/nhU19QhZ
         Hv4zJPw90JRzwAAEgf93zijZqdk24lP2dCJ83pqNXtTIaAWMkx/xXdtKsjRJAf5PBh2C
         Ab2ji3Qxfmkoeec9XWzABIe6YAX3CDWPl8yruBOQc9TioXYWyEQ98lbsVVPAN3oEMi4V
         Da8stEUiMi/ye0PVrEPNxvOI5dIyRZM0C7/Wy4aRhoUyG4iZiawV4a3lGRUo3cRtC1GO
         1DLUXJxh91rQchy68zUyfqoB/BgsW+pJv879Up/RnRgkhVN6V6wd6nBMCkPQLpA9copI
         nukg==
X-Gm-Message-State: AFq9FYIyXXZPzIFzubLudy3KKMDpmNVb7Wq/cJa2PMuRUInJqzJ5K4UW
	KRTYAJzvOO/VBYu+p7OcrTbPEpYDOs5r81QvvKq1YPPBz+NH1uvs1q9P
X-Gm-Gg: AYBFou0Efi8XHcN4iuYx2xvcM9D+IaHAkwg4UM18tQPLflKPxo0JkXYUD9Ew/K5s9vF
	sLW90XJd/2bjSAnhCWofmypt5dIkmvcnb142rc8lEcJwarLRt50q4O5TZStYob55shdjExMmnPv
	vOCuQJyHLkfpFGZQvNJBHaIm71t5n5v7vj1NH0bulmisrSebfue8Glf8LULCqwqgLFE7ZhtcFod
	ttzGGaQW3PbuSQ5FP2C/hg6P6Q9XBRMXdw7ZOW0FUxRKndQiiu+kFOpsz4meTbeM/aterG0k+PQ
	6VuAkKo+0YIUZnrnZDNOYbsaV4uoqo7YOlOaAPYxJOYYkD9L59Yqh6OnQGPQPO7GmrZsIGycJgn
	UoeJbGS5McO/aevd3Q0YZn2tZix8Z/WWQGc/cKYgwS8NzHqyunPzyA5aS3CDV8mY0/hx13B9cQA
	NJdkr+ZxFYqVmF4HvXC4bvJEXjy+42H9eXwX4AvqwameK3ls92YakGfnxbZLhUJlpMW3pY0mG+O
	4WZDvYPed09XWymNmDZYnnAMOFQA2YAipqcD2Ntul1BXhMlMEBXsksEvjtzntPzTiQa9QUtWYnW
	b81BEvdE8PZZ5WAgABAxFPEE+sy1uFkB5lSruNCQUbbku2LvyIId4U319Jc4m1jWKqGAb02EucL
	XrEOUfOK9ERDv+uWt/HCqCZRaT+cQkQ==
X-Received: by 2002:a05:6a20:7348:b0:3e1:282b:b69 with SMTP id adf61e73a8af0-3e9022d6f89mr5409945637.28.1793281721811;
        Thu, 29 Oct 2026 06:48:41 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:41 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 8/8] wifi: rt2x00usb: use a threaded NAPI with GRO for RX
Date: Thu, 29 Oct 2026 21:47:49 +0800
Message-ID: <20261029134752.1299130-9-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GRO makes sense now that RX aggregation is enabled, since multiple
frames arrive at once.

This code is referenced from commit 5323d3e50c20
("wifi: mt76: mt76u: use a threaded NAPI for the RX path")

Test results:
   before after
TX 30.5   30.5
RX 80.9   161.7

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  7 ++-
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  6 ++-
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    | 49 ++++++++++++++++---
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 5bc077fce9cbf..a120adb18f4b8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -955,9 +955,14 @@ struct rt2x00_dev {
 	/**
 	 * Scheduled work for TX/RX done handling (USB devices)
 	 */
-	struct work_struct rxdone_work;
 	struct work_struct txdone_work;
 
+	/*
+	 * NAPI context for RX done handling (USB devices).
+	 */
+	struct net_device *napi_dev;
+	struct napi_struct napi;
+
 	/*
 	 * Powersaving work
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 351e7da178279..4527fdf905b15 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -846,7 +846,11 @@ static void rt2x00lib_rxdone_skb(struct queue_entry *entry)
 	rx_status->bw = rxdesc.bw;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
-	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
+	if (rt2x00dev->napi_dev)
+		ieee80211_rx_napi(rt2x00dev->hw, NULL, entry->skb,
+				  &rt2x00dev->napi);
+	else
+		ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
 }
 
 void rt2x00lib_rxdone(struct queue_entry *entry, unsigned int len, gfp_t gfp)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 4519a20a7f4bc..d11244a2c4f2e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -341,10 +341,10 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 /*
  * RX data handlers.
  */
-static void rt2x00usb_work_rxdone(struct work_struct *work)
+static int rt2x00usb_poll_rxdone(struct napi_struct *napi, int budget)
 {
 	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, rxdone_work);
+	    container_of(napi, struct rt2x00_dev, napi);
 	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry *entry;
 	struct skb_frame_desc *skbdesc;
@@ -368,8 +368,12 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 		 */
 		entry_priv = entry->priv_data;
 		rt2x00lib_rxdone(entry, entry_priv->urb->actual_length,
-				 GFP_KERNEL);
+				 GFP_ATOMIC);
 	}
+
+	napi_complete(napi);
+
+	return 0;
 }
 
 static void rt2x00usb_interrupt_rxdone(struct urb *urb)
@@ -396,7 +400,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	/*
 	 * Schedule the delayed work for processing RX data
 	 */
-	queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
+	napi_schedule(&rt2x00dev->napi);
 }
 
 static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
@@ -496,7 +500,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
 		completion = &queue->rt2x00dev->txdone_work;
 		break;
 	case QID_RX:
-		completion = &queue->rt2x00dev->rxdone_work;
+		completion = NULL;
 		break;
 	default:
 		return;
@@ -515,7 +519,13 @@ void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
 		 * Schedule the completion handler manually, when this
 		 * worker function runs, it should cleanup the queue.
 		 */
-		queue_work(queue->rt2x00dev->workqueue, completion);
+		if (completion) {
+			queue_work(queue->rt2x00dev->workqueue, completion);
+		} else {
+			local_bh_disable();
+			napi_schedule(&queue->rt2x00dev->napi);
+			local_bh_enable();
+		}
 
 		/*
 		 * Wait for a little while to give the driver
@@ -750,7 +760,7 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 
 	usb_kill_anchored_urbs(rt2x00dev->anchor);
 	hrtimer_cancel(&rt2x00dev->txstatus_timer);
-	cancel_work_sync(&rt2x00dev->rxdone_work);
+	napi_synchronize(&rt2x00dev->napi);
 	cancel_work_sync(&rt2x00dev->txdone_work);
 
 	queue_for_each(rt2x00dev, queue)
@@ -758,6 +768,14 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 
+static void rt2x00usb_free_napi(struct rt2x00_dev *rt2x00dev)
+{
+	napi_disable(&rt2x00dev->napi);
+	netif_napi_del(&rt2x00dev->napi);
+	free_netdev(rt2x00dev->napi_dev);
+	rt2x00dev->napi_dev = NULL;
+}
+
 int rt2x00usb_probe(struct usb_interface *usb_intf,
 		    const struct rt2x00_ops *ops)
 {
@@ -801,9 +819,21 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
 
-	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
 
+	rt2x00dev->napi_dev = alloc_netdev_dummy(0);
+	if (!rt2x00dev->napi_dev) {
+		retval = -ENOMEM;
+		goto exit_free_hw;
+	}
+
+	strscpy(rt2x00dev->napi_dev->name, wiphy_name(hw->wiphy),
+		sizeof(rt2x00dev->napi_dev->name));
+	netif_napi_add(rt2x00dev->napi_dev, &rt2x00dev->napi,
+		       rt2x00usb_poll_rxdone);
+	netif_threaded_enable(rt2x00dev->napi_dev);
+	napi_enable(&rt2x00dev->napi);
+
 	init_usb_anchor(rt2x00dev->anchor);
 
 	retval = rt2x00lib_probe_dev(rt2x00dev);
@@ -814,6 +844,8 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 exit_free_anchor:
 	usb_kill_anchored_urbs(rt2x00dev->anchor);
+	rt2x00usb_free_napi(rt2x00dev);
+exit_free_hw:
 	ieee80211_free_hw(hw);
 	usb_set_intfdata(usb_intf, NULL);
 
@@ -830,6 +862,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00usb_free_napi(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	usb_set_intfdata(usb_intf, NULL);
-- 
2.53.0

