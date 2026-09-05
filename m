Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E310029BDBF
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 08:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788597930; cv=none; b=ZS6U58nEHNV70+Luf9181AtRrab5lHY3bJixwWCfuqBO11rInhJh5+Kqb+hd/tgHJ8Guaj5xiH6UoCx3FD5Ar5d0Y0FX69qJCyyAvgYSzqdPd2HhYxwEGSrWy9MmhjKjr0bo66pdxOUd8fou1/XzPwQfMeVWPuN0ZLOUuCJhAmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788597930; c=relaxed/simple;
	bh=qTUqJpmOZfneAkXR51R9HKjY3ut2KmdkckUklfD7V00=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BpEvGww8nyhaksh+6Ics0YmYoURhTx0vpfGDJj9Gf5H23Bx336zswTC4J5AZaz8X9eNirJOpACeWzEs+8NcQRIqU6DfQCEAYXg/Xp1NE50cN4MqjU+FDBgEvfgwhxg7jEW9okCpVhQXH4VAnu7MfJzGr1h7Nq3HPYWhUgm3FN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geEqIIia; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geEqIIia"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4843f205a5bso1094636f8f.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 01:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788597926; x=1789202726; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yi85Njyt+YQbTk0qkutRoUa/021alepU64DQKFvSd8E=;
        b=geEqIIiaCoXdyHMHkgnPnQ4qMRayFubT9BzLex8eLi5YXF2p56MuSSYF73VxGSOuVE
         CCUGEQu72Bg5RdxaiRs7F8ntLCLYixvwAfK90Jxn1N01volZOZzRKJZkJ5lmItYISCA+
         hMs+BxXkpwO7/xyBd8Z7KLKK2P2UqglzUvqlUC1BDIfbo1T8ib44Q7vBOZKfU+roJ4mE
         3Pqge5s6KTDm/boKwRwCsQittL53Wy4eY/yBAs50RvFndUOiPSEtj0liJDp/aZy1i32k
         x6fRajyrEdXtmbl75BlgDmg6JCANzx09l9sNB81t9BIXFee4BehuNdGyiPuxOtqkPjKO
         4y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788597926; x=1789202726;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yi85Njyt+YQbTk0qkutRoUa/021alepU64DQKFvSd8E=;
        b=nhJdRfJfVQOiovLkvMJ8DksEmNlbAUg4rUBNEOIIMwmnLg4lLqQJUon1bSdvsyjTs5
         JXiE4Gk81gIyeP4XNUAoBfZHW3nrOZhnwMv0q2CMWj7Zkwb2MOW4jQRG5gKkxN3jx52q
         JKefO8CgydlpvWXs2KwSjRds4gV+SGM+I/VeZC+idUfjydrnOzAGoyzY1DK4CcfGtKXR
         1B3M+MvTGA/5YFmyd3ampkhQ87MS6nmb1pAcozEYCSb1kRGWt0ed5tYCVrL9UMmodph0
         178L9/2rcSgKX8OgVKWAyDhW9NtUF1/DsEhCnKDOCXEuvk2b9LNaSmPNog205taGLOgg
         d5eg==
X-Gm-Message-State: AFuF++nW/66PsBc79lhzvoN/jv8fjVV24vpCRvyMBQaZ+aniiAWm9tei
	PnL/fBznhN5oco/92M0einQtylTLXqbJ7lbach1fS5DL/EOr7LE5+hrt7AZrqQ==
X-Gm-Gg: AYBFou3565F8IzMswZ5c4f1qRWzHH42NanEeX+VPbWXkuudMLv3ei8jI7/eHKW9OG9a
	zgU1JlO0S4kOVFH3/hEROuIO6BhcddvUgDXbYFj6x0Vlllf//6wugfegXnhn1PueOS6GcIuMC0I
	p6XBfzA7zzfJ8gFpmx+1/tg2EVUITlYNOMQLklxrvgOluVyhGCfL8U7r8qoyyOIj3Hz7Y3YYAHv
	22sJMMVeNiGtDwM3syFtq9Gl6bj4jzQ4kw5PiP14xWXc95iwSuSSeqPMEecPqK5FzcA5Ptiho/e
	nTowOp31P9KVVjFVzzu7LntmpdeuO2H161/LYItBGD2k2Vdu7hwjNdp2tS7WG6o3JPuBfsrpHrq
	Tvx2mURfdlhLGOKIiHwmtRDJN+7vTAMJIFOEris999ky1X3lxVO/cBqddTUnlpVXYgmYSwmDu9u
	Ze8IglMmNErkrANXfdMEMshFA9V4OPYRII4jtg4RUVVAyf+Przpzti+saG7+YPHHQwrs3j9huqs
	Y8+lA==
X-Received: by 2002:a05:6000:2f86:b0:485:8a46:b3c7 with SMTP id ffacd0b85a97d-4858a46b5b7mr8932763f8f.47.1788597925987;
        Sat, 05 Sep 2026 01:45:25 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883c81c3sm11542834f8f.26.2026.09.05.01.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 01:45:25 -0700 (PDT)
Message-ID: <8efe15ee-bdea-428b-a636-3e801c22009f@gmail.com>
Date: Sat, 5 Sep 2026 11:45:23 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, i.mafifi17@gmail.com
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next v2] wifi: rtw88: usb: Download the reserved page
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
v2:
 - Fix compilation error in rtw_usb_write_data_rsvd_page().
---
 drivers/net/wireless/realtek/rtw88/usb.c | 91 +++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index c90802919473..d31297954f22 100644
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
@@ -543,13 +608,37 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_tx_pkt_info pkt_info = {0};
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
+	skb_push(skb, chip->tx_pkt_desc_sz);
+	memset(skb->data, 0, chip->tx_pkt_desc_sz);
+	rtw_tx_fill_tx_desc(rtwdev, &pkt_info, skb);
+	rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, skb->data);
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

