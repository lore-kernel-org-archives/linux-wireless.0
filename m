Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9745F175A64
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789417136; cv=none; b=Sp9qsC0Ih4DYbww5F5O4E5PibowGHNrdR7z0GOP3ckrEGISWbPyfhPYQfhL9Zikiktf14oMII3oHTLyKDVry3T3CLzIfjx/4osZj6ZQGllSzg5hADXTjvPqJCw6GmlLQb8Pnnx7qMukV9gNCAJvECuDNI7ueZMDW6o7W7JyJ5gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789417136; c=relaxed/simple;
	bh=TExIfPwSM9lFlpJp4pIhjmIPIf9ccjHiZL7lPg09RUY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ZcT2Njd7Cxg/ekak5bLouyvFLy4n7uCNSuVBxxbHPfZ4TkdNNyUcRVAbXKbGWkSAyp6yg976hd0eINCg/JFi8E5nDtaSn6TLhp6HT4P9LobW/hmXGn6D6taUKgVbzp4SAJ+V5pDDP1bqYu1kCIQMu366RM3FQNN/Hl5H7hagc68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=np+g93IB; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="np+g93IB"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso6555685e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789417132; x=1790021932; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=C2sGZ1zDe5JwW/81XnjROgfDltnF16qBaaHexlTkPLo=;
        b=np+g93IBRYOrzxLpuP/0Neznneq0nftAZcu7QHfbl1d5edrSmrHO3Wo9/O1uWGubS8
         MEudlF0/o1zLeYJxnV+ymiUPR8pxBC4oUvf7925JIkU/T2Tqf0qTohNVGf2y+QYnJdgh
         jjdJdm4f9wGUlf/YsP31b7LdsWAhf5dSfEEkta2yorrMmEbnqLoVxGH7crxmJyuy69Ce
         J5+dtGoYIG0mpsFIKv4EbAHHrx0B+BJkVOJxi6+i10i+2r98nBDhlQZp72uXYfnpAkdC
         rwUNbnlP9CZgkAPZy7bnTq/9bCl3BnenPrhdjz/e4EBMmyfT0TmY1I0NJo5Iu740GWwt
         GqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789417132; x=1790021932;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C2sGZ1zDe5JwW/81XnjROgfDltnF16qBaaHexlTkPLo=;
        b=XRDEYmuUrkwuLL87Tg+HwQSA9MqU11/+L0sex9rXGWtOSZKB7M8lqW8cL3yXATtrad
         ++lZaezkIdo0FG3TCeuIg1nFrbpj16SbqU91HL2eMwTeTpwnM7cZYr4j3SOnY6QWeXg5
         QCH0hDifY4KUlWxU5iNtMNC2xWr/n6mAXFbkkLG2kN9dE9X3CCXNKwrWl4RWkYloVQjs
         HvWHkV9JVFJAdO1MQ7udOpO5aXoIGEMLXlOivGzY4LGycnZXKs66ECDYx9XxeYFdWqxG
         3rHUS0RwelGzltq81WLGhA3EV8wTCQOjaY/Os5WWfI+fuGvpmPH2appB7nliie+mx3q3
         g9oQ==
X-Gm-Message-State: AFuF++n8pOtiz+VJCWAghLEi/MT86lsyj8+jnfeB0wQGzRA60PKZxNbg
	14ZoMYOO79hqZcaPF5khACVcw69By4OW6GoZVIzsZ8GwqC/GMWPCUYp+QkZPow==
X-Gm-Gg: AYBFou395qwzkiWp/eoptuWKiRmLB+Ynib17yzcwtYMJrVWuOdDaPCShHco9XDDpxxK
	+ZjCzZTtX2bvLTKOYPCF+OoQwmEudCqkwty1VhyBXILtr1/KJvyLH/2HgNQITAfcY0Yq4hMk7nV
	85dIILd5QYzVgajsyKkJm3MvQQHimP+XC9/Lm08c1DvTrVNLDE/j9BwhLc8duZsrJIdUQDRoK+c
	o8fucX5Z0ntixXiUgZapSXe/Wt3Ape1PMOVrsrcHdr7ix0GRIfNT338n1uslq3VE8i0aBzCIaXr
	YO+39lSl0WAmcLeWEKBDWCZvEpl0b2zFgWu7tz3KSgqPGuXWgFZJTl03IL+wjqtHeQ/MVkAh2N2
	WUCVF5ddnoaFKyxFBf22JsgjjIaGg7Jt9ONe9DvazkeALLd5eBxMyGh/3ZT7k2+JJE0m9VUh9tD
	DGrWp1lanor9WTLkPKso0d1B6ot7kAddVrH5k8WA5Z55cw+8+fu6HHlAFJXouZBaM9r8fLi+sqp
	a5He6wyoJtxsv0=
X-Received: by 2002:a05:600c:3594:b0:497:fecd:5b00 with SMTP id 5b1f17b1804b1-49e7a66275fmr63329075e9.9.1789417132386;
        Mon, 14 Sep 2026 13:18:52 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d28c734sm17873435e9.1.2026.09.14.13.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:18:51 -0700 (PDT)
Message-ID: <5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com>
Date: Mon, 14 Sep 2026 23:18:49 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
 "i.mafifi17@gmail.com" <i.mafifi17@gmail.com>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v3] wifi: rtw88: usb: Download the reserved page
 synchronously
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Mohammed Afifi <i.mafifi17@gmail.com>

In AP mode the reserved page (which contains the beacon) is downloaded
to the chip by rtw_fw_write_data_rsvd_page(). That function writes the
data via rtw_hci_write_data_rsvd_page() and then immediately polls the
hardware BCN_VALID bit to confirm the firmware accepted the beacon.

On USB, rtw_usb_write_data_rsvd_page() ends up in rtw_usb_write_port(),
which submits the URB with usb_submit_urb() and returns as soon as the
transfer is queued. The completion callback only frees the skb. As a
result the BCN_VALID poll can run while the beacon is still in flight
on the bus, and the poll times out even though the download itself is
fine.

This shows up as:

  rtw_8822bu: error beacon valid
  rtw_8822bu: failed to download drv rsvd page

The failure is intermittent because the poll retries sometimes cover
the transfer time. It occurs in bursts when something triggers repeated
beacon updates, such as stations associating and disassociating.

Fix this by making rtw_usb_write_data() wait for the URB to complete
when it's called from rtw_usb_write_data_rsvd_page(). Only the reserved
page / beacon path is made synchronous; the normal data TX path is left
untouched, so throughput is unaffected.

The reserved page download runs in process context under rtwdev->mutex,
so sleeping there is safe.

Closes: https://github.com/lwfinger/rtw88/issues/451
Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
Several people said that making rtw_usb_write_data_rsvd_page()
synchronous gets rid of the "error beacon valid" messages and makes AP
mode more stable. I wonder why the vendor driver doesn't need to do
this? It downloads the reserved page asynchronously and polls
BIT_BCN_VALID_V1 the same way rtw88 does.

v2:
 - Fix compilation error in rtw_usb_write_data_rsvd_page().

v3:
 - Reuse the existing rtw_usb_write_data() and
   rtw_usb_write_port_complete() functions instead of adding new ones.

 - It's not calling usb_kill_urb() anymore when the completion handler
   is not called within 5 seconds. This is probably fine because the
   documentation says "If the submission is successful, the complete()
   callback from the URB will be called exactly once, when the USB core
   and Host Controller Driver (HCD) are finished with the URB." So the
   handler will be called eventually.

 - Delete the unnecessary comments.
---
 drivers/net/wireless/realtek/rtw88/usb.c | 47 +++++++++++++++++++++---
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index c90802919473..6dad08f4bd4c 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -27,6 +27,13 @@ struct rtw_usb_txcb {
 	struct sk_buff_head tx_ack_queue;
 };
 
+struct rtw_usb_write_data_cb {
+	struct completion done;
+	struct sk_buff *skb;
+	int status;
+	bool sync;
+};
+
 static void rtw_usb_fill_tx_checksum(struct rtw_usb *rtwusb,
 				     struct sk_buff *skb, int agg_num)
 {
@@ -499,16 +506,21 @@ static void rtw_usb_tx_queue_purge(struct rtw_usb *rtwusb)
 
 static void rtw_usb_write_port_complete(struct urb *urb)
 {
-	struct sk_buff *skb = urb->context;
+	struct rtw_usb_write_data_cb *cb = urb->context;
 
-	dev_kfree_skb_any(skb);
+	cb->status = urb->status;
+	complete(&cb->done);
+	dev_kfree_skb_any(cb->skb);
+	if (!cb->sync)
+		kfree(cb);
 }
 
 static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 			      struct rtw_tx_pkt_info *pkt_info,
-			      u8 *buf)
+			      u8 *buf, bool sync)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_usb_write_data_cb *cb;
 	struct sk_buff *skb;
 	unsigned int size;
 	u8 qsel;
@@ -528,11 +540,29 @@ static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
 
+	cb = kmalloc_obj(*cb, GFP_KERNEL);
+	if (!cb) {
+		dev_kfree_skb_any(skb);
+		return -ENOMEM;
+	}
+
+	init_completion(&cb->done);
+	cb->status = -EINPROGRESS;
+	cb->skb = skb;
+	cb->sync = sync;
+
 	ret = rtw_usb_write_port(rtwdev, qsel, skb,
-				 rtw_usb_write_port_complete, skb);
+				 rtw_usb_write_port_complete, cb);
 	if (unlikely(ret)) {
 		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
 		dev_kfree_skb_any(skb);
+		kfree(cb);
+	} else if (sync) {
+		if (!wait_for_completion_timeout(&cb->done, secs_to_jiffies(5)))
+			ret = -ETIMEDOUT;
+		else
+			ret = cb->status;
+		kfree(cb);
 	}
 
 	return ret;
@@ -549,7 +579,12 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 	pkt_info.offset = chip->tx_pkt_desc_sz;
 	pkt_info.ls = true;
 
-	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+	/*
+	 * Download the beacon/reserved page synchronously so that the
+	 * caller's subsequent BCN_VALID poll observes the completed
+	 * transfer instead of racing the async TX path.
+	 */
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf, true);
 }
 
 static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
@@ -559,7 +594,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	pkt_info.tx_pkt_size = size;
 	pkt_info.qsel = TX_DESC_QSEL_H2C;
 
-	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf, false);
 }
 
 static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
-- 
2.55.0

