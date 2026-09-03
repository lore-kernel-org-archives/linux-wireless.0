Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A781DED42
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470694; cv=none; b=JFkSTa8/ONdp7Jqa7WO0uiSCbXDkQVaoFV1mZQ4d+Zq78DYqT5U8RyAxFZQqo/z15jvIYFKAqLOziZBFLKR72Z5Et6J8IPHGW1JOatROsb6jJRLxtOUoG7kk7kKx9iEmWaRjniNZ9SKu/l0TWdKBKw/5c5q6iJc8Rjr6///ls5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470694; c=relaxed/simple;
	bh=/YjjEmAIxpzBMggT/DhThDDtrdGrlTOWRd3kOcfHYEU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=ii+dvma6VbLOgtALwjWD6gvvNgYB42rzltR3pD3S03nT9c7jfi2AFvrHR6QU3wbXOxOaP7UWEyTCbrZFLWZfWw6Pek+Eenwpbj/MLrdta4gGI+iIsPBZnXBe8OokRi0VL+O/BRkofD2dPDR71RguXRUt7MTkE6Z4E4HtZv00QBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQSUgAwA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQSUgAwA"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49b965570d7so3904425e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 14:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788470690; x=1789075490; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mY/0C5nYgJd0Ug9TJUl4shTrLESynuosTZHPVyYcACw=;
        b=HQSUgAwAfQXpkwv93deIY5nETtgDCi1pjvoY66ECagWy/3McmLLCyPJq3tVAfj7PWM
         NKo4ZhSqt3VO72ylHCvZpxV0x7VB749Yi1e+lhXCgg8a4H22QVYpfZOyAD4au8bVnXZA
         g+FumgN+XqnRbGGGBfM9GRPahasACuF8GstP7EP1J0dr3rCUVr2TbRiyst4e+ioQEQqu
         xq+GubbzmaAdV7GE8ov8q4/NPmCnBgjOI7GD2t64x7WPXZ6Lag/lf4dKyj5n/I0ROCAr
         OfsdtMjgI4YG9bQMs01ojXt1CGHEhtbZyf6OOZ2pssihpl5jBCCne1b7m9k9keFgsSde
         CEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788470690; x=1789075490;
        h=content-transfer-encoding:content-type:content-language:cc:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mY/0C5nYgJd0Ug9TJUl4shTrLESynuosTZHPVyYcACw=;
        b=e/YOXTR0PM7m+dimMwCZjpe2ugd+Kh7/dHXvfVBQ3C9xiwVksyOkTuygco3Xftnv0p
         1asxzwEGbKgsIFctL/aKScV+n6RPbgkfSZqpV8YeBxjSgALeKSBa2Jbp6TjdfuMSpBia
         KVhfd5PpyAPjQ+ifFCjQ9wreVbqwsqp4LySBsQ1gNW0AYoFiOHzPExB05MVWC31h5mug
         YGRBhBnpMjBMxl6hMZEOiTl3ziwIIdKQAYmaGOiwbkN/ahw+nWlVPQpoWqGieJfhWai6
         xoZ/jXtW3tjn+gyHQGv3xyTgg2/cO9UQ1IbFVyS1lMATBhxDUfAF3hBirAmlQ6UNXsDY
         /aBg==
X-Gm-Message-State: AFuF++kv9slH4zb3dvcROUBGE9NdiQGHk1ovrVyjiaBSroxRPYQs6/6d
	f/wpVwe5bJyoNK5OxfOkcDhd4lInHAlyqwPdyd6HVKm7c1Qx/tA/M9Q7kWiggQ==
X-Gm-Gg: AYBFou3i/oK3mqUc+tzu6Kgkv6gy3XzzLKGzbu8PDeZcT+OsjcpbWuMg0JNXWH1Nsyp
	YeTyTb3zWJMg2ZyoIKoi8JR7gn9eicSTFNrOjjzrLWtxGm49qV24yBtDEtGKhzsa/wgZ8N2vbls
	KghQ7UmeVgjF+uKfHOmaTDnmkzHMTGTVfi9jViEV3B2yDEi214eWEbMinC8LxjbhCtRmLXN7Gif
	qIEb3ONRdjX6WJjivAkoo9GDSv9P8J2ZnK6lRv5OKWvwlgUyK1YGLmvlaa62nqDusRtKLYAMhjX
	TICUyjq0TgmnG9KzpKbszXtc1XdDMceNyXiAnFUwcBbaOs3oNycEXJ0YYrzD1hTj4/XI0aE+Wjj
	wPvKi1nIYrmtUvrfoSEcslceJJ8EaI5Od/qt6P3dSupPaz4uxFrEH9DHtgY2GusPALo13PUnW+u
	5b9Xfqh2F74ud80+aFpvzpbyqj296D9UQTYInhNDFqxKtruPoqWex0euwKg/2Fd+kWlxs=
X-Received: by 2002:a05:600c:c4a7:b0:49c:df2b:15fc with SMTP id 5b1f17b1804b1-49cf823d0dcmr16281725e9.8.1788470690249;
        Thu, 03 Sep 2026 14:24:50 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5936a5esm66990415e9.3.2026.09.03.14.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 14:24:49 -0700 (PDT)
Message-ID: <fd7bbc79-03f9-4932-ada8-f555392d4485@gmail.com>
Date: Fri, 4 Sep 2026 00:24:47 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw88: usb: Download the reserved page
 synchronously
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, i.mafifi17@gmail.com
Content-Language: en-US
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

Fix this by adding a synchronous bulk-out helper that waits for the URB
to complete, and using it for the reserved page download. Only the
reserved page / beacon path is made synchronous; the normal data TX
path is left untouched, so throughput is unaffected.

The reserved page download runs in process context under rtwdev->mutex,
so sleeping there is safe.

Closes: https://github.com/lwfinger/rtw88/issues/451
Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 92 +++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index c90802919473..04e3095432c3 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -394,6 +394,71 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
 	return ret;
 }
 
+struct rtw_usb_write_data_sync_cb {
+	struct completion done;
+	int status;
+};
+
+static void rtw_usb_write_port_sync_complete(struct urb *urb)
+{
+	struct rtw_usb_write_data_sync_cb *cb = urb->context;
+
+	cb->status = urb->status;
+	complete(&cb->done);
+}
+
+/* Synchronous bulk-out that returns only after the data has actually been
+ * transferred to the device. Required for the reserved-page / beacon
+ * download: the caller polls the hardware BCN_VALID bit immediately after
+ * this returns, so the bytes must be on the chip by then. The normal async
+ * TX path races that poll, which shows up as intermittent
+ * "error beacon valid" / "failed to download drv rsvd page" in AP mode,
+ * more often on 5 GHz where the larger beacon takes longer to transfer.
+ */
+static int rtw_usb_write_port_sync(struct rtw_dev *rtwdev, u8 qsel,
+				   struct sk_buff *skb)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *usbd = rtwusb->udev;
+	struct rtw_usb_write_data_sync_cb cb;
+	int ep = qsel_to_ep(rtwusb, qsel);
+	unsigned int pipe;
+	struct urb *urb;
+	int ret;
+
+	if (ep < 0)
+		return ep;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return -ENOMEM;
+
+	init_completion(&cb.done);
+	cb.status = -EINPROGRESS;
+
+	pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
+	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len,
+			  rtw_usb_write_port_sync_complete, &cb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
+
+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	/* 5 s matches the vendor driver's bulk-out timeout */
+	if (!wait_for_completion_timeout(&cb.done, msecs_to_jiffies(5000))) {
+		usb_kill_urb(urb);
+		ret = -ETIMEDOUT;
+	} else {
+		ret = cb.status;
+	}
+
+out:
+	usb_free_urb(urb);
+
+	return ret;
+}
+
 static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
 {
 	struct rtw_dev *rtwdev = rtwusb->rtwdev;
@@ -543,13 +608,38 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_tx_pkt_info pkt_info = {0};
+	struct rtw_tx_desc *pkt_desc;
+	struct sk_buff *skb;
+	int ret;
 
 	pkt_info.tx_pkt_size = size;
 	pkt_info.qsel = TX_DESC_QSEL_BEACON;
 	pkt_info.offset = chip->tx_pkt_desc_sz;
 	pkt_info.ls = true;
 
-	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+	skb = dev_alloc_skb(chip->tx_pkt_desc_sz + size);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, chip->tx_pkt_desc_sz);
+	skb_put_data(skb, buf, size);
+	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
+	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
+	rtw_tx_fill_tx_desc(rtwdev, &pkt_info, pkt_desc);
+	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, pkt_desc);
+
+	/* Download the beacon/reserved page synchronously so that the caller's
+	 * subsequent BCN_VALID poll observes the completed transfer instead of
+	 * racing the async TX path.
+	 */
+	ret = rtw_usb_write_port_sync(rtwdev, pkt_info.qsel, skb);
+	if (ret)
+		rtw_err(rtwdev, "failed to download rsvd page over USB, ret=%d\n",
+			ret);
+
+	dev_kfree_skb_any(skb);
+
+	return ret;
 }
 
 static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
-- 
2.55.0

