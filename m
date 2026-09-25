Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF7B4BB5C2;
	Fri, 25 Sep 2026 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348813; cv=none; b=qINHqGcp32BSH5MsdbeYq+FqlgmPCzTIUpT/JtgaSSwzr2Fb+M47AdZBZGb6kt2m9FLBWdL6o6PJVl4xNeSTitGZu4lvgwGhIqvWIx++9fzm6EOxPPDqV4WfZ053No6FSvnNMBV+LM3e4ofs5eoRcEnar8F6PDfJg/1UUY+Kss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348813; c=relaxed/simple;
	bh=B8Y1jpvrxiDM5beryHs+5YuRP8bFi6IKhqjMPAySITY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UpohbGsPBidH3p43OoSz29nKFhMPKtxeETiegZcDLcK37vdbyi5zHyUaPWNjeoWuLEKfdemr/9nCluIztfEzwQ17D/R/xgykdVJVbT8N6nYTBbtYQ09bbZZfa1SW/3UospXzqNd6A24FC2NgBgrQMEJUkjKSBntMyU2dy+kfhIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NVERoFOc; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NVERoFOc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=31
	AX/cwM8/OnRF/yeYpJQfvdlOv5vgEP2EVvQZ6gI+o=; b=NVERoFOce+O9R/f4x2
	hvWRcvmqTNOrJI3K+/OW+OCIMFyKId47ONck8G5sKMUbjPMf/wYuAhKSqP9WTy9b
	s2o6EBmwymm514LveNBMrSaz50lFI0galmlPA2PuqRQRrKKyg+p+lcmgd+hFPzOg
	sWJZW6UOdFcBPdJ5IEBEC9Vuo=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3J8zYjbZq2yQpAw--.5414S4;
	Fri, 25 Sep 2026 23:06:05 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/2] wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
Date: Fri, 25 Sep 2026 23:05:55 +0800
Message-Id: <20260925150556.2304003-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260925150556.2304003-1-yaojiale02@163.com>
References: <20260925150556.2304003-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3J8zYjbZq2yQpAw--.5414S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4UWFy5ZFW5uw45Cw13XFb_yoW8Cr47pF
	yxKF9IvrsxGF17t34xAa15AF95ua9ak34DKrZ3Za4fZ348Aw1YkFW0qFyjkr1j9w4F9r1j
	qrnxtryxW34DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pK-eoAUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7x3iHWq2jd0jqAAA3K

mt7663u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 6cb596ba84e3 ("mt76: usb: introduce __mt76u_init utility routine")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index bab7b91f14be..3629e3d9bf47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -58,15 +58,22 @@ static void mt7663u_copy(struct mt76_dev *dev, u32 offset,
 			 const void *data, int len)
 {
 	struct mt76_usb *usb = &dev->usb;
-	int ret, i = 0, batch_len;
 	const u8 *val = data;
+	int len_aligned;
+	int batch_len;
+	int copy_len;
+	int ret;
+	int i = 0;
 
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		batch_len = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, batch_len);
+	while (i < len_aligned) {
+		batch_len = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, batch_len, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < batch_len)
+			memset(usb->data + copy_len, 0, batch_len - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_WRITE_EXT,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     (offset + i) >> 16, offset + i,
-- 
2.34.1

