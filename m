Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856537DEBC;
	Fri, 25 Sep 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348825; cv=none; b=Lq6u2GoWRNQwcwtYbYuqjXBaLZKPzrDVQjjaDorJQwBmMeLtKbvRqmtaMBwhTrB3NClzp2X4hQVbzRvWKwncJXxZkrlsY7+PbYZw2O162s83ne/60AkNUE3Udhbl5nT4p0FMT/cuydjt4/MZcDAlTSlBJubzNN+jsvbdBoc4Ajg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348825; c=relaxed/simple;
	bh=H5KIP+f7KANI1YtorrV8S8a0K1k4jiQUqfQwLns4ya0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mxVfKE4jW+/xRh1xgbfYL+9EM0RBAGvFRXHN+ctM9PLdcBB/PszbrLyAB1fJEO3Eey2hA+QvNzv9Vdl4WW6+b0btQ6W5nX2LOzj8ljEWJohexs9iN8zjWNSiTJPPDN7Rxwl403Qw1kPKejlS+Yd+wqc/uMR4e5shj6k0spiLTPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DVcs3mEJ; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DVcs3mEJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Wz
	dROanWlTNrH8RVUU2vkB9x2qZKNDOucbvjx4s09js=; b=DVcs3mEJ/3/NyJ1bLz
	66RyjCWIQ9ZhktvE+Qr48b9Z0dgaPWWog1qncyjcpLs0toYOfqK77ayhEqMcSTQt
	BLH+NBSA56n6m1OnwZNxtkaFG2ObLcKEG+Ugtxk065IRWYJv7KiIGbp236MvYK4J
	nATBwJ0Km9Oh8AprQAXFMmDp4=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3J8zYjbZq2yQpAw--.5414S3;
	Fri, 25 Sep 2026 23:06:02 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Markus Theil <markus.theil@tu-ilmenau.de>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/2] wifi: mt76: usb: fix source overread in mt76u_copy
Date: Fri, 25 Sep 2026 23:05:54 +0800
Message-Id: <20260925150556.2304003-2-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3J8zYjbZq2yQpAw--.5414S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4UWFy5ZFW5uw45Zr4kCrg_yoW8ZF4kpF
	Z7KFya9rZxGF17Jw4xAan8AF93ZayIkryDKrZ3Za4fu395Jw18KFy8KFyUKrWUZF4Sgr12
	yrnFyr97W3s8taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pENeOiUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xvhHGq2jdsjagAA3K

mt76u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 9446248669968 ("mt76: speed up usb bulk copy")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a9af3aa6b80a..a42a33f4e907 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -171,8 +171,10 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 {
 	struct mt76_usb *usb = &dev->usb;
 	const u8 *val = data;
-	int ret;
 	int current_batch_size;
+	int len_aligned;
+	int copy_len;
+	int ret;
 	int i = 0;
 
 	/* Assure that always a multiple of 4 bytes are copied,
@@ -180,12 +182,16 @@ static void mt76u_copy(struct mt76_dev *dev, u32 offset,
 	 * See: "mt76: round up length on mt76_wr_copy"
 	 * Commit 850e8f6fbd5d0003b0
 	 */
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		current_batch_size = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, current_batch_size);
+	while (i < len_aligned) {
+		current_batch_size = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, current_batch_size, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < current_batch_size)
+			memset(usb->data + copy_len, 0,
+			       current_batch_size - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     0, offset + i, usb->data,
-- 
2.34.1

