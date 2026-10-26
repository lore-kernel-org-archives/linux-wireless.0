Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041852;
	b=AAOmZtZFms47vNH1FeT0QZqkWju0UBa1z7TFM8ThQczyQFkpM9lj6XP2xtAfvPF2ANio
	 9mOjBQgGHCRAJwkhW5V/eXaj2KzrdSY94Gr1fGTH+NrIZ8VdspeLlwUUg1OW973kOSqod
	 wsbU9eNSudNVhm+yenl3xsWqj0PKTiGRyS7wpFCHJu55VbmY/9urLqrGrpolepXSu6QbC
	 TL1VMbLi0paAtmaUAULqR12X0vsQx4n+SZwZRejR1Q4h3sgHiub9DT7ZFv1lLBWnVFYMI
	 7/8xO85wO+/9YcUpm2EEtZWUZzc70hartUq23FEwpNWofN+o0R1u5r2bCx2L81/ECBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=QIiFmRnFhWPNQzBn5gMjyz5irv/bhFzVi5C0pT/z1+E=;
	b=D1oOe/pdzakHWpzUOA+UAjsUc/HdJSRGDVwbTyPrxLmVeUWn7jSqae6Tsm8yMXEstn0Y
	 wJMK2LH9v1M1Ov4UlS+Uxu2u8rB80em/3YLNWXr+Up3+VEU9KKXFd8dpSEY3f9VoAj9dJ
	 rdICfjB6IbXXcBoIiT5drRgA9ujYVaiKRwYjqjS+hhS+27QkqYukLsCe6kJRlHyMsZL2Q
	 kw484smtAOSGhimpjh20bTBfAa3JBbNmpw/+/KQUhSUHNmsbLuD/PyQSCJkbOGf04P3Sl
	 y7ehZhPz+YZ6MEwXojQfGjWF23PgtfW2wQB7HvHNrk3FWKg5kt9hZeJUIn2B+L+1YHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ijc2W5eY;
	arc=none smtp.remote-ip=74.125.231.139
Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF12E606A321
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF12E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ijc2W5eY
Received: by mail-oo2-f11.google.com with SMTP id 46e09a7af769-828912d37e6so542780a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793041851; x=1793646651; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QIiFmRnFhWPNQzBn5gMjyz5irv/bhFzVi5C0pT/z1+E=;
        b=ijc2W5eYEB0cQuzXLKzLx8XPbifxXb8vJ9gJhxVAZCQwllNTKS/3/oysRJjn84q4m7
         DBRAZlkNJZn/UWlCA21NXgyWNN8HAcpD8F4XPXCq1NmxZ1YPbghEOXmIHdNNyFsLAUhn
         fzX9BvZeDqvJly30aenoLHezQDZKoFK/5K7o+NgudOjqtVl1+xdP9acBhBJDupJ3yd1o
         kma4ocDPJqpHFheKUBPFA9oo1MFs0NZ4RGWH1t9Hzm1RQMvtsE3F+ScfRZdT8iymdEqk
         4nb8RBaO/IcphnATawBZUSu9HsPWYOWSMlhEmYDXk2/+KuCFV7S47+PnirHXne8m/ZZc
         8+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041851; x=1793646651;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIiFmRnFhWPNQzBn5gMjyz5irv/bhFzVi5C0pT/z1+E=;
        b=0t7EeIaKqKLnxXf9UT5iq3gI+eLJrmbnlMHLOXqTRwonKwiTCdx4Sutu7uKbN4C7np
         yi+NHYXxogwe7TGg+R1nYkuBPV2ouP0coT29UGMNbUrDYms0xTWXRjWXIjPe1WG7aoAu
         cTKit0xdDEZu+sK8IDOv1YH4Jj1gn7rpUCUW/N8NRf0TkGz2n0MatWO8cLQAkuN+41RC
         bKg08eantdkx1upd4M4/flX2R6tavSnkfLq7CeN1GH+DOqn2jKpiPbgnBqPKXfkyUEzU
         F6abVMS08jCPSzipDWfAvw6zPLdADf+xE6Lp2k40oVB71yJT6ZIzKxahg83lme0K1ZVs
         K/Mw==
X-Gm-Message-State: AFq9FYLRGqslgXBtuRgjjzuDDuvAFpvA4//PhaxMy4oO92AS4whH18+W
	dBHkf+AlXmdXftSSRc5Xd+Xh5ENgdwA2IX6qsGLEguHgJM/JU+F9iI5q
X-Gm-Gg: AYBFou2np4wfIBrklipzLKAZlqQLoE/Hjio/AwA02fYyD+z+SEX8ceO1zpkfln7ag5f
	CHstVDwCGppsafqkIGgdY/R1Lf1VUsW9PAm2sXK2+9Zoo2kZpaK3jtXb6mQE1vIkeAEFSnzhhWB
	blmw9XZkdMmfHX3i29NpuMkRCmuXyU5rP3lw+xoxDfKq/2E0HuX/tpc57FP/0M8Wm1mq6QjZ9N1
	YjQpqv/I/emHInYni7PWH7ZrYY5bwyDOFVoYY+2y/rAAaPPm5R9/aDYbDQspyhlbLEJOS3UaRvO
	g6lJ3Yzd8uWpQD8FflQ94kfzccgY16Mcq41EW1WN0vRe8z5htVy4Gs9xRA9/CfSsgKZ7ioiIlj/
	aA1hSaPuHU5XRgEFyhC9GSKcCXgdzVbGepRju8JNl3NE0rbzSJDSGpCtERWsoyNo8DK01GrX9A0
	VN1E83mvipMlpZB5JOrAEeYuJZIDPmQL3SZiYWTP6YL5CO3S3PEIIibJ8B0fIPFM9R1nwpD/GpM
	qvfIB0BdmIZSv4OgqyCmQn8cSf9fWY5oUSTkMklVOPEZlmLS0Tob6ZM1Rg/IcXmB07k8mYVyomd
	Obe2bQcPaqAdyoRkGOMLurqh0D6SQDEorPgYsYisWSJOK6k=
X-Received: by 2002:a05:6808:150a:b0:532:6c52:9778 with SMTP id 5614622812f47-55f6af83955mr374971b6e.20.1793041850651;
        Mon, 26 Oct 2026 12:10:50 -0700 (PDT)
Received: from [10.10.18.223] (wsip-64-207-253-118.tu.ok.cox.net. [64.207.253.118])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c03dc3524sm5740834b6e.0.2026.10.26.12.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:10:50 -0700 (PDT)
From: Ryan Brue <ryanbrue.dev@gmail.com>
Date: Mon, 26 Oct 2026 14:10:39 -0500
Subject: [PATCH 4/4] wifi: mt76: mt7663s: use RX enhance mode
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-4-944b1f7e63a8@gmail.com>
References: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
In-Reply-To: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Ryan Brue <ryanbrue.dev@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793041838; l=5919;
 i=ryanbrue.dev@gmail.com; s=20260906; h=from:subject:message-id;
 bh=3uU3p0eYN0gWkFjqNQLRhAPcmSmlrPjUlBG9Bxgtb3g=;
 b=4BBBF/yUowDPHwMwWDdDl2PGA2yooKLBaQvgJiKnkDgfIFukdubCZ0Lb/ZE35bsg1OP3qaTHm
 0MGOuDWtAcRBRC1D1bDKhM5vRsE0gBXaVcupju6xvGzrzB9FXvHck+t
X-Developer-Key: i=ryanbrue.dev@gmail.com; a=ed25519;
 pk=KsUvVaP//v/2q+ZBuacc7cLbsyEYn+AD71Sn28oZWKo=

In RX enhance mode (WHCR bit 16), the chip appends the next interrupt
status block to every RX data read: after the frames come 4 bytes of
zero padding and then the same 112-byte block a WHISR read returns.
mt76 never enabled it, so the txrx worker read WHISR before every RX
read, about two status reads per frame. MediaTek's own driver for these
chips runs in enhance mode and only reads WHISR when no appended status
is pending.

Do the same for mt7663s: read the extra 116 bytes with the frames, keep
the appended status when its padding is zero, and let the next
parse_irq() use it instead of reading WHISR. Each status is used once,
so the read-clear TX quota counts are neither lost nor counted twice.
mt7663s reads only RX port 0, so a pass of the worker makes at most
one RX read and no appended status is overwritten before it is used.
A 1.5 KB frame plus the status still fits in four 512-byte blocks, so
the reads don't grow.

Measured with ftrace on an MT7663 SDIO module under a UDP stream: 881
WHISR reads for 857 RX reads (2.1 per RX read before), with TCP and UDP
throughput unchanged on that air-limited link, no added loss, and no TX
stalls over 30 s of transmit.

Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h        | 10 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c | 28 +++++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/sdio.c        |  3 +++
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c   | 15 +++++++++++--
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9e851dea71d9..9c637ebddb52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -700,6 +700,16 @@ struct mt76_sdio {
 	struct sdio_func *func;
 	void *intr_data;
 	u8 hw_ver;
+
+	/*
+	 * RX enhance mode (CONNAC1): the chip appends the next interrupt
+	 * status (intr_size bytes, after 4 bytes of zero padding) to every
+	 * RX data read, saving a separate status read while frames stream.
+	 */
+	bool rx_enhance;
+	bool intr_pending;
+	u16 intr_size;
+	void *intr_next;
 	wait_queue_head_t wait;
 
 	int pse_mcu_quota_max;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
index 46188951ad19..f744240ebd34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
@@ -56,12 +56,19 @@ static int mt7663s_parse_intr(struct mt76_dev *dev, struct mt76s_intr *intr)
 	struct mt7663s_intr *irq_data = sdio->intr_data;
 	int i, err;
 
-	sdio_claim_host(sdio->func);
-	err = sdio_readsb(sdio->func, irq_data, MCR_WHISR, sizeof(*irq_data));
-	sdio_release_host(sdio->func);
-
-	if (err)
-		return err;
+	if (sdio->intr_pending) {
+		/* appended to the last RX read (RX enhance mode) */
+		memcpy(irq_data, sdio->intr_next, sizeof(*irq_data));
+		sdio->intr_pending = false;
+	} else {
+		sdio_claim_host(sdio->func);
+		err = sdio_readsb(sdio->func, irq_data, MCR_WHISR,
+				  sizeof(*irq_data));
+		sdio_release_host(sdio->func);
+
+		if (err)
+			return err;
+	}
 
 	intr->isr = irq_data->isr;
 	intr->rec_mb = irq_data->rec_mb;
@@ -124,6 +131,15 @@ static int mt7663s_probe(struct sdio_func *func,
 	if (ret < 0)
 		goto error;
 
+	mdev->sdio.intr_size = sizeof(struct mt7663s_intr);
+	mdev->sdio.intr_next = devm_kmalloc(mdev->dev, mdev->sdio.intr_size,
+					    GFP_KERNEL);
+	if (!mdev->sdio.intr_next) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	mdev->sdio.rx_enhance = true;
+
 	ret = mt76s_hw_init(mdev, func, MT76_CONNAC_SDIO);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index ba5f123f7e39..95af0a90546c 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -269,6 +269,9 @@ int mt76s_hw_init(struct mt76_dev *dev, struct sdio_func *func, int hw_ver)
 	case MT76_CONNAC_SDIO:
 		/* set WHISR as read clear and Rx aggregation number as 16 */
 		ctrl = FIELD_PREP(MAX_HIF_RX_LEN_NUM, 16);
+		if (dev->sdio.rx_enhance)
+			ctrl |= RX_ENHANCE_MODE;
+		dev->sdio.intr_pending = false;
 		break;
 	default:
 		ctrl = sdio_readl(func, MCR_WHCR, &ret);
diff --git a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
index 311c31e87ee5..f15746a13991 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio_ids.h>
@@ -87,7 +88,7 @@ mt76s_rx_run_queue(struct mt76_dev *dev, enum mt76_rxq_id qid,
 {
 	struct mt76_queue *q = &dev->q_rx[qid];
 	struct mt76_sdio *sdio = &dev->sdio;
-	int len = 0, err, i;
+	int len = 0, data_len, err, i;
 	struct page *page;
 	u8 *buf, *end;
 
@@ -97,6 +98,10 @@ mt76s_rx_run_queue(struct mt76_dev *dev, enum mt76_rxq_id qid,
 	if (!len)
 		return 0;
 
+	data_len = len;
+	if (sdio->rx_enhance)
+		len += 4 + sdio->intr_size;
+
 	if (len > sdio->func->cur_blksize)
 		len = roundup(len, sdio->func->cur_blksize);
 
@@ -117,7 +122,13 @@ mt76s_rx_run_queue(struct mt76_dev *dev, enum mt76_rxq_id qid,
 		return err;
 	}
 
-	end = buf + len;
+	/* The next interrupt status follows the frames and a zero pad */
+	if (sdio->rx_enhance && !get_unaligned((u32 *)(buf + data_len))) {
+		memcpy(sdio->intr_next, buf + data_len + 4, sdio->intr_size);
+		sdio->intr_pending = true;
+	}
+
+	end = buf + data_len;
 	i = 0;
 
 	while (i < intr->rx.num[qid] && buf < end) {

-- 
2.55.0

