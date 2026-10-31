Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465527;
	b=GPSmte9xTQK+uOoKsEMKhxrUaw6RgCV++O0cq3nKFzspoUdrqZoRt9+Ge9WQudSX/02B
	 jVtoIPZ/0cHMBXrUONdK6inrFlJOuSMys19KktNcEqtsAdncf3AqqlqUqlouWuPsVFO3e
	 maHKfxJi69oi4gawYzpj2gZySEle7kIRqqDDxs2fFdf5zDNdz/gDT6xXbFaT6Yurn5WT2
	 k2CG7yZUG5zUynDn2qeHHzw8vy4sCZcslcpBLFeOZenrooVhEujVhnyb91HEPkeeDgqVZ
	 tPnm3IwqypjqDp2kwrAKXx27l6QqYIy5INEiY9fGrPiVmusb4vr7DZW3y4dsUvl0mOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465527;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EFSJ82wtYsf67nTNRk7kGxqNGCpPOA3KyDqpUbxSvPc=;
	b=rdTJzLi/mvNORZrJntzNtHbdcko4u0RFLrWDWtpcsu+hh/XwpYQcxs0gKsy//N5Lgybh
	 L7xQ7iSfsJzhauAzWhs2XoJfq4vZh1lj+qM5/NBd2CVXuUG9z3YH9pWT0FD6XteHcKqhf
	 mB6DuZGL0pX3PDadvH7+yMR84hLQ6kbYc9jPUL7XpZwU1gEyO0oOcYqbynohQzX4YsvLc
	 nfdUgpg4HhTYA/jtkkfP4uaVi4oar6l2B1bIgqBmsmCUBcs/GswB0uI04b+E5+6zXtu2G
	 r9oofSrdzquOy7vTnKsn0hBKrOtuvovq4lj5ykCKEdTiPDSFM7XIRcLla7F1E5LuhPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LS+vdFrt;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE90606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:52:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BE90606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LS+vdFrt
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a2761c69fbso1614552c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465526; x=1794070326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EFSJ82wtYsf67nTNRk7kGxqNGCpPOA3KyDqpUbxSvPc=;
        b=LS+vdFrt1wI01+jmi6iHhCy5YGLYVIn/zu11128dyGYPZBcvcX5BlBrtDQOtqJf7yZ
         yg9xpXRnyDsE/JL8QJ8fbvr3sgz+SpwCOdePJClnNgw5InKZ8VG5cilbI5SJPy8E+Jmy
         EMEEfbHhLtmTQkNjoC1h11f6M6YwzXD1RbDDAqXo2RAhKL5hOGuxWau6TdSKjDGwepN7
         QoVK8pKlZtkE5XdRoi1Bzibyq0/+P0CyWAmywTrE+ZaC+gh9VqR0jxCqxOifAYKsW45p
         mzpk8r/JVO+mTNX/sii52YKrUzlrX+BOGAFBrZfVn2Cp1Zvdgg/Tl8wiM91qNg5//42m
         2QrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465526; x=1794070326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EFSJ82wtYsf67nTNRk7kGxqNGCpPOA3KyDqpUbxSvPc=;
        b=cbZojPCyjRVd1u6D61K+7SURk1qF6+ZN50KVydnl9vTCPOHHTiotkileLjm21Ht2bL
         CemfUoIl0oUpOxBbKnZrBZPAf+qUdpI1QtKxrrVM7/IGUuQ0xrYn3Fgc3ID9YqCSBRsT
         mk+4KE6zSrLUvYrXPzKbk72JAsgkI/ciQGW0xfE4bDNUAwZtPCITLkS+WY+AtdmYyYE/
         lsrSpf51aHZQWYroK/JZezhW3CKoIKEUGKlZR8pUuPbCa56mwc9gDkHw7gdzJaqajXTZ
         Jp6BhFhWmxH+/SEbeiyg5BmSVJfnX8YzqAP7PotPo/gQUHF1ueyNE8dq6C/bSTrpijvl
         kJ4w==
X-Gm-Message-State: AFq9FYLDQtmJ6Q+NGZ9mhJhVJLc2wqAlny6xXu+VAsZZiIpIfH1InpaK
	gw7RBwzv9LYJK3C3/MwyjrE8KIP70mIcWchYfuQ0jo4krQtnN7nk4RkpU0kLfDfe
X-Gm-Gg: AYBFou07RQzdc+wFmzyQSFtCM/1dqzma+wzUrMqAmmJDZ9KuiLUta5XuZeWxIBncvcf
	FaLirONXMKYPfDRmHV+mmeUVGrgubqJy+wwDPJqstCaFotD9GpLqZRIPWRkfLOkRmRlExrghUyC
	dtep9HCtQc+to3Gh+rS+9POoyFdhmQ9ElD29qhrHRDxgZTpt7h2xep79N5oZmUzJe3zUUPaQlNH
	0OjCYyu7nPQ3GURxxk7JCp2uHnvQ53PGWlvPZ3Zpb1lMgDHtasBF+9RDJAojxJuDG4MTBJV2sbe
	TWyTDXIDsyscBSTP5lpyAFhrGE2EIvSnKJsvIILLqbz6YHq6+TdqhEV7V8qekMBy8PVAU73j6CJ
	hcoeWTPsfIxU511TElyo8iogyqvpqnENBs2UWSCmdxiJKLG/JXD3JQ7/E7lKv/yfB5VgnvK5Vng
	PxgzcO3ErPlG2e2ON2mZZyLy4CeCaWPYQUkk0ArvUl+TrL4p2DP008WkRAKyWvAn6/J63lmOgRT
	qChSEiWBHDfjEqL5V1XYG1PUeHOm/jjx0LEXrli2CiT+MfnAYjKwryy+MfnTjlG885PTNqz4rxz
	3/Wv1q4oEWxlKKSV48Efq3rfYTWDvz1LIg3sWeVWp50088UxOtYzU8qUrxP2nVpvMYQzlBstiIJ
	fTfkvzvA=
X-Received: by 2002:a05:701b:42cb:20b0:174:cf1b:235c with SMTP id a92af1059eb24-1ac5cef075cmr8535175c88.43.1793465525528;
        Sat, 31 Oct 2026 09:52:05 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:52:05 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 7/7] wifi: rt2x00usb: use a threaded NAPI with GRO for RX
Date: Sun,  1 Nov 2026 00:51:14 +0800
Message-ID: <20261031165117.2868671-8-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
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
index 4c83168e9c169..25262b96c6941 100644
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
index 8f02b62cecdf6..6226bcbf24e5b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -847,7 +847,11 @@ static void rt2x00lib_rxdone_skb(struct queue_entry *entry)
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

