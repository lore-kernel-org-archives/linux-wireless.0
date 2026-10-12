Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B70392C4B
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815764; cv=none; b=tgdFCPJJ7r+fULoBLGIkBVplJq1iFSMcJ8MgSCXRnRDmFljx/3gMV2pj0egBfy8k399wNRKtiAWWMfek+blk4s4JWWmd8xIEoygV83bVVbDTQFk4lYH+X1t/BPQgkiIrV0UmyHrATYfd4V5xijDM9ycJh41wkZo+Pws78nS3pNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815764; c=relaxed/simple;
	bh=xh8mLpS5Cg8gtdnoU32CnOyw4tHdEKd1FVF20tRn+fA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=thzW5klKu+jqsKF8s4DZo7bkFO5aBNj4YQdijamcxJMSTMPFmGPIIjs3TyxknrM3Cv81Qp7l9daAQWhu5QsKnkMrYd0zJYcbRd0Ul/dN8o8pjaEmK15Uda3g5CjCeMRiHUnGU422Zto2+h72z611TyOq9XGt9E7VKwDM9YlMwo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvE8DyDF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvE8DyDF"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-486e8faff03so834435f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 07:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791815760; x=1792420560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L8NynBsyAqa8X3SZ82HU4EkENEBSaj7FkySBXAXxs8E=;
        b=DvE8DyDFD3zYYvjWdYr350Ej/HaX7Ig9yiX9BQGKINujAU3ObHcQF8MnIexP6uVSuM
         4mpJBmYB601my69XzWJr6UmDTf5v8Y+BM/job91XwbJjNyc6tHYgqXzWj2+h0MPDHWvI
         78PAA44L7PmTzW1LiEI7T7zxMwE9dC2tL6RAmpL5G8mprhVHrHJMXS3xci/PPJvXtqIM
         FEvEtKkFAFejFt+30jeh7URmTHINQnSRyuHHRqDQFiLb5P/plLbZCOujF6utq5DhHANd
         9FZHHZXS9f1TlrHO0r+FVygCOQoovVnnvn8wLc3jQ9hZAeT9uGupaqUs9pg7iD8zEb42
         NMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791815760; x=1792420560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L8NynBsyAqa8X3SZ82HU4EkENEBSaj7FkySBXAXxs8E=;
        b=aFl6qBI62kly2aeujPLkiW6a4sJi4tP5fnD/+0rIVdLCkbgg9x9sCtqy5DInfJAIQQ
         FnSHu/4V0ZUPiQ64fwznwQqELaEhw1XgvVw/92id54s3yOy0RATvOm/4CvvoYX4P7EM6
         Vb2B2WiMu5rzF0Z3Ymgfb5QAWprMMqvcLe/D0YbCCnoQNjGrJv8cJeL56ifh+GkUhAmu
         A5cg/9jOkqhhS2dEYdBR1B6QiGiDzwrxMUYhwtstMVeLKrt3NXuX4d4KpBdISbeUsD8F
         7VQTT7cl5mxIcS/jjx/azsihk2AudpkRyQo3Edj60Q9l+Wig7RWAOCHmIjYUX1GN8cu8
         Bq9g==
X-Gm-Message-State: AFq9FYIzL/wgH/4oFLw4ERMQ7meKAST8G5H5p1asJiprrzhA9nP+YPeW
	4QZkL+EeAdqh0oiQ5HEtAxgW16OEIQx49keVdY26FFOanNtUnFzV4kMWDdtnuam2
X-Gm-Gg: AYBFou2/WSzIyaRKH9JU0ZYT5lJYM2nj0X/IMPsilezSdaHp/ln8U9jHIf4dtcObIWa
	xkCQEFccvLxjltnPNKDE2Hkek14k5muQil+0oIcsiX+Xct25/1ChzG/HJnB7GeobivTrLXnSl6v
	sD2M7Bp4b6Zx3ZXO8QKwpQ3JSlImPp1cW3GGb/l8xKh7Vr2Y4a6hmokiD7ncRof0V3LqbmOItwt
	HmgAwYz8D9++4vT/KxyD6olut7CAO3xBzTbMwgL/3tzjXd+lEwg2wHHiMutw9+5j1/ZfO6L/Eiu
	gwBksWb2/qRcjVcxkeGm/iWu0qYGP2JzFZfeG5vhyIv250BXRTf0ccZqAmMZMCiyZh9lKJNltaP
	JbdPkS96ZWHDnOXiZYjo8gcdger0vgsSxdeppRCb4AMCYIav4AWlHWNrnSXbVtNSDnNCQPbww78
	zrerJudIVryP9F7B38PBsjBbH0VVQ1mpWvG86jNeCvSydtFf+AdMjswwzJZVZggM8YDNYn72dcK
	0OATK1TNoHXCjw6A3f8WtJx3evcUmFZ3vjuxAZS4JO+Y7+9gY5SToumPnNSgZTHRQwD5YBSpydy
	cThofgatxF216xXBw8YWKuPeWQ==
X-Received: by 2002:a05:600c:8b09:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-4a18e4a95b7mr198077895e9.14.1791815760043;
        Mon, 12 Oct 2026 07:36:00 -0700 (PDT)
Received: from localhost.localdomain ([2a00:102a:4039:4521:195e:5004:8071:a7f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f249692sm171395275e9.3.2026.10.12.07.35.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 07:35:59 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Mohammed Afifi <i.mafifi17@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v4] wifi: rtw88: usb: Download the reserved page synchronously
Date: Mon, 12 Oct 2026 16:35:57 +0200
Message-ID: <20261012143557.82117-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
when it's called from rtw_usb_write_data_rsvd_page(). The new
rtw_usb_write_port_sync() waits the same way usb_bulk_msg() does: if
the URB doesn't complete within 5 seconds, it is killed before the
function returns, so the completion handler can't run after that.
usb_bulk_msg() itself is not used because it can't set URB_ZERO_PACKET,
which rtw_usb_write_port() sets for every bulk out transfer.

Only the reserved page path is made synchronous; the normal data TX
path and the H2C path are left untouched, so throughput is unaffected.
The chips with a 3081 WCPU also download their firmware through
rtw_usb_write_data_rsvd_page(), so those chunks are now sent
synchronously as well.

The reserved page download runs in process context under rtwdev->mutex,
so sleeping there is safe.

Closes: https://github.com/lwfinger/rtw88/issues/451
Signed-off-by: Mohammed Afifi <i.mafifi17@gmail.com>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---
Bitterblue is fine with me taking this over, so I am sending v4.
Mohammed is still the author.

v1: https://lore.kernel.org/linux-wireless/fd7bbc79-03f9-4932-ada8-f555392d4485@gmail.com/

v2: https://lore.kernel.org/linux-wireless/8efe15ee-bdea-428b-a636-3e801c22009f@gmail.com/
 - Fix compilation error in rtw_usb_write_data_rsvd_page().

v3: https://lore.kernel.org/linux-wireless/5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com/
 - Reuse the existing rtw_usb_write_data() and
   rtw_usb_write_port_complete() functions instead of adding new ones.
 - Don't call usb_kill_urb() on timeout; the completion handler is
   called exactly once anyway, when the USB core is done with the URB.
 - Delete the unnecessary comments.

v4:
 - Use a dedicated rtw_usb_write_port_sync() that owns its URB and kills
   it on timeout, avoiding the use-after-free issues in v3 (Ping-Ke).
   Read the status from the URB and keep the completion handler free of
   accesses to the waiter's context after complete().
 - Do not reuse rtw_usb_write_port(), which drops its URB reference
   after submission, or use usb_bulk_msg(), which cannot set
   URB_ZERO_PACKET.
 - Keep the sync argument in rtw_usb_write_data() so the skb and TX
   descriptor are built in one place, with skb cleanup handled there.
 - Match usb_start_wait_urb() by returning the URB status if it
   completes before usb_kill_urb() takes effect.
 - Add a short comment at the call site.

Why 5 seconds: the wait only runs out if the device stops taking bulk
OUT data, and a reserved page is a few KB. The register accesses around
it already sleep under rtwdev->mutex (500 ms per write, 1000 ms per
read), so 500 ms, as Mohammed suggested in
https://github.com/lwfinger/rtw88/issues/451, would also do.

 drivers/net/wireless/realtek/rtw88/usb.c | 64 +++++++++++++++++++++---
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d9..f747400fca12 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -396,6 +396,51 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
 	return ret;
 }
 
+static void rtw_usb_write_port_sync_complete(struct urb *urb)
+{
+	complete(urb->context);
+}
+
+static int rtw_usb_write_port_sync(struct rtw_dev *rtwdev, u8 qsel,
+				   struct sk_buff *skb)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *usbd = rtwusb->udev;
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct urb *urb;
+	unsigned int pipe;
+	int ret;
+	int ep = qsel_to_ep(rtwusb, qsel);
+
+	if (ep < 0)
+		return ep;
+
+	pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return -ENOMEM;
+
+	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len,
+			  rtw_usb_write_port_sync_complete, &done);
+	urb->transfer_flags |= URB_ZERO_PACKET;
+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	if (wait_for_completion_timeout(&done, secs_to_jiffies(5))) {
+		ret = urb->status;
+	} else {
+		/* returns after the completion handler has finished with &done */
+		usb_kill_urb(urb);
+		ret = urb->status == -ENOENT ? -ETIMEDOUT : urb->status;
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
@@ -508,7 +553,7 @@ static void rtw_usb_write_port_complete(struct urb *urb)
 
 static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 			      struct rtw_tx_pkt_info *pkt_info,
-			      u8 *buf)
+			      u8 *buf, bool sync)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct sk_buff *skb;
@@ -530,12 +575,16 @@ static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 	rtw_tx_fill_tx_desc(rtwdev, pkt_info, skb);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);
 
-	ret = rtw_usb_write_port(rtwdev, qsel, skb,
-				 rtw_usb_write_port_complete, skb);
-	if (unlikely(ret)) {
+	if (sync)
+		ret = rtw_usb_write_port_sync(rtwdev, qsel, skb);
+	else
+		ret = rtw_usb_write_port(rtwdev, qsel, skb,
+					 rtw_usb_write_port_complete, skb);
+	if (unlikely(ret))
 		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
+
+	if (ret || sync)
 		dev_kfree_skb_any(skb);
-	}
 
 	return ret;
 }
@@ -551,7 +600,8 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 	pkt_info.offset = chip->tx_pkt_desc_sz;
 	pkt_info.ls = true;
 
-	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+	/* the caller checks BCN_VALID right after this, so wait for the URB */
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf, true);
 }
 
 static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
@@ -561,7 +611,7 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	pkt_info.tx_pkt_size = size;
 	pkt_info.qsel = TX_DESC_QSEL_H2C;
 
-	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
+	return rtw_usb_write_data(rtwdev, &pkt_info, buf, false);
 }
 
 static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)

base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
-- 
2.54.0 (Apple Git-157)

