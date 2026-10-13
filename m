Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989037F309
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 03:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791862663; cv=none; b=czeGYpVXGe2z8U3NxOIEuSsLT0WczMfG2eNnD+M8sQXcsMC6gu8EscKDjphs9QQ0v8i/W3JTK5Ka8ZEz9iKYpyAXwkVFT4NMfGxkHc5v5gx0SZiYCQhbquTdVbLuluoVamOrqD02dVyVWDS2XMz7HC5A3vL2j98wE9JtVZGn14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791862663; c=relaxed/simple;
	bh=MvXl+GmsjP+gs7iI1PaKSS9XHaC/IG2YS8m9MZmCJhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DcihoIWCJYIJ5gBQjhyAjlhF35OjMQK+8wU/xhZQ5j3+Kf8DpVQ2Wdr8s11kVKJs91XHzEBKJGU1fDow27B+fRrknAfxnX0N4i8UJooHR2KwBMS6Qfb+v3rDL1SN4fQ/gf1qkMJZ2BEp8KyQAQGnmoY0UoF9KveXbStOWG03S8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ruehx8sQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ruehx8sQ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a061a13884so21115395e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 20:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791862660; x=1792467460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XOXNuwVFMKBRaHFZAoF6Ob6jnlr6NIyZs1LJfg7FaWA=;
        b=ruehx8sQE7BKc7LzDmCyV7xmJD6x+vlN/Lh4sSSdMWv5VyEpE0ahxazbTX/pE84xyC
         pH0wj7klN6Adf47j7doUYbrS9mfh7IqibakK4MPXLZHTmnaBisMGCknmcogn3oOZAvwU
         Ont3oygtU9eEpTmfU0LzsMDa/9/u6MSVW/yoMG8zmSjim5xKzh0ATpUsNOTP5xQ5DkaI
         Y2NnAKULyes2O4OWTUYE2B1Oe1nrrni/SSPHfzf3xmV2qcFVza3uGrD6msyH9BYUyOUH
         sEYmGBMYeVFO5mu2hjXkO9eQtRhtpY1Dsdf1XqwAu+4GDKCVlMo0vnGbkoAkClLvLwL7
         sFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791862660; x=1792467460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XOXNuwVFMKBRaHFZAoF6Ob6jnlr6NIyZs1LJfg7FaWA=;
        b=aCrWRJ1FUPG/h0ImfpVM11Xn6tAaJe0GUwogCje+s7VgdfjU0P88oEJI8ijkHLg+7l
         l4Ngx0QK+0DT+n3BOp7MyAQVXeUvwbzpBCEFByJvVBaElhxgjzEedIN7a3u5kNcHwFSx
         bAa6uMOFIFQqRCW8e35/9wUK7gwnG6GC5G4lTLp9NhQ3BlWPWP5621FOkynj/oHm/geM
         QX4rTaRUSHRSK6VIJSTLWjwRghVMy/ahYyupPSCL6BxCMjMGenWmQjXM/wtJxW8UA7NQ
         kXlxv6k/3woAFVHTunqc/r0HUTg5DfaTVS9MwFYeK9oPlRsbWtVrnyzekZcpdc5u46Ra
         ESYg==
X-Gm-Message-State: AFq9FYI8SYnQdKijMU5kvdkv6dfHTFyoCTEqsLRq/UtolKrJAoHPmhNQ
	j+gzuQBMmJSgcfhYHZfkNT8ymOhbhJPFieGkLlbNP8N5GrFBS58KB3r8zP9Rp9KF
X-Gm-Gg: AYBFou0sntqoSlTKk/J85F+P4Hv7dq7Qs3e8Y6xcxjyo0Yqc2ZIzNEtjhRucXtBcmr6
	ac+Q5XktvkaH1e2VcjeSnpH/y7nxs12dFU5wxFeEwbtHs1UoAyJNNXsScIp3b66U76ci3qKlMo8
	aUOEpH+AaLMfwV3SAp9uKqCYULCHO+zx6+PdA2v3OSsWzPYtIPd7irxHfav3nH3ErYmgqnPcf+x
	aETrDDkHKk5nzgPB5kdHGCaQLKlzGZpX1vZZb+ocZgHjmAcIhCZclKLSLCQRE6SHdJUzk0VUdJo
	ILDIOWHsFbD/76M9UBf22pbE02U8O8AqIfjmTxqgQyFpY1BayJM0gK8dY8Fsj8zvrJYXr0fENN9
	YwNNGwyQ1jLoV5C7Tr80tFTRkWv/x7JRfY6MY0bEKWIbG0dYGYzMIXSrSaa+HJwnxRXqQxrey9k
	sYFl00aTkWvHxju70j1ax+7EJ85lS0vkdgOTrAGjcAMn14rCufh0/2LfokzQA03MpdlxfO2OMLb
	WWCAefwXuTAwzDYu0n8TcI6WeNZzowpVbSQQFtazeuzzJOo/xZ/pxywnsbGRFp1/uk0lZOX33xJ
	mu1FRQbEmU8k1d5tip0w8UwOXr+Hw1OCE+xUmHE72DU1zzCpLIHzVMEQIKI78CLzM2dOS6lrwP7
	LwpFlMRmJ07Yo/PVRHL76tA==
X-Received: by 2002:a05:600c:609b:b0:49f:ce78:356d with SMTP id 5b1f17b1804b1-4a18e4c9944mr205579585e9.30.1791862659466;
        Mon, 12 Oct 2026 20:37:39 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-c000-0ddf-a82e-1679-b82d-4f13.ipv6.o2.cz. [2a00:1028:c000:ddf:a82e:1679:b82d:4f13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf214a1sm378869995e9.7.2026.10.12.20.37.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 20:37:38 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Mohammed Afifi <i.mafifi17@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v5] wifi: rtw88: usb: Download the reserved page synchronously
Date: Tue, 13 Oct 2026 05:37:37 +0200
Message-ID: <20261013033737.6761-1-pepe.schlehofer@gmail.com>
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
v1: https://lore.kernel.org/linux-wireless/fd7bbc79-03f9-4932-ada8-f555392d4485@gmail.com/

v2: https://lore.kernel.org/linux-wireless/8efe15ee-bdea-428b-a636-3e801c22009f@gmail.com/
 - Fix compilation error in rtw_usb_write_data_rsvd_page().

v3: https://lore.kernel.org/linux-wireless/5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com/
 - Reuse the existing rtw_usb_write_data() and
   rtw_usb_write_port_complete() functions instead of adding new ones.
 - Don't call usb_kill_urb() on timeout; the completion handler is
   called exactly once anyway, when the USB core is done with the URB.
 - Delete the unnecessary comments.

v4: https://lore.kernel.org/linux-wireless/20261012143557.82117-1-pepe.schlehofer@gmail.com/
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

v5:
 - Reverse X'mas tree order for the declarations in
   rtw_usb_write_port_sync() (Ping-Ke).
 - Drop the initializer of ret in rtw_usb_write_data() (Ping-Ke).
 - Reword the comment in the timeout branch, which only says that
   usb_kill_urb() waits for the completion handler (Ping-Ke).

 drivers/net/wireless/realtek/rtw88/usb.c | 66 +++++++++++++++++++++---
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 715a2ce342d9..6679efa6c886 100644
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
+	int ep = qsel_to_ep(rtwusb, qsel);
+	DECLARE_COMPLETION_ONSTACK(done);
+	unsigned int pipe;
+	struct urb *urb;
+	int ret;
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
+		/* timed out; usb_kill_urb() waits for the completion handler */
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
@@ -508,13 +553,13 @@ static void rtw_usb_write_port_complete(struct urb *urb)
 
 static int rtw_usb_write_data(struct rtw_dev *rtwdev,
 			      struct rtw_tx_pkt_info *pkt_info,
-			      u8 *buf)
+			      u8 *buf, bool sync)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct sk_buff *skb;
 	unsigned int size;
 	u8 qsel;
-	int ret = 0;
+	int ret;
 
 	size = pkt_info->tx_pkt_size;
 	qsel = pkt_info->qsel;
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

base-commit: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
-- 
2.54.0 (Apple Git-157)

