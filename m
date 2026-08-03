Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C670313550
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785767786; cv=none; b=i/OkrLmTWC+LJ8UQRjV/Oz58iAnd7sPMvegnplhZdbcQy4kL5IX+5SLsX1IW8G3DzaBkI+/E7DjYigJzJWw1GIkOSPA0gdp7u35uatCS2E6IuPyT/5bgWQsOZBuyl+n9gGFtU1DS0zsfjT8pJ11R/aWuehHzFMtNY6jk6QzHVj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785767786; c=relaxed/simple;
	bh=GFFC126DJy54L91aVHwJFsFbycvYP2zw6dY1MoOwNo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jd5nY+gGiTT66BcJ/SNEk80+R5GUvCK6dJcpWyCuOatkol4PRfMKESCX4FrO+mJQAgLwprz9Zg6b5mNzDBjvK7Yc4Vw1vuHR1uQla6CeLfjce/GQQ5qKvdYDn+trBQp7ywIggPKzQ7iWviwa/yhIkeQ+OFKMGQg4brpsxZy1GGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VsmBIaKf; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsmBIaKf"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f706438c3so190469f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 07:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785767781; x=1786372581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6NEy/PUFP4IYziRxlFsuxGJ+UKXD+3O9hbIQf+7B02s=;
        b=VsmBIaKfislYVJhGN8ID17zJC76vr6noyXUGkxQW/08MbMPf1Mco2U9Ziagv8oiZC5
         8zk9lj2TJWOpq4gHa8jh08Pu8kh2YruOMKv8uWpiHxUztaG14UPdCtJOGQ2+pQNFUyeK
         UAOHzAu942CrtyMLN5gR01lNUlDxOwJVmQW0dnTV3qBWdX8ILPq7q/IUMSHIKI775enV
         lCGB3R4NsyZ2lOiPJ4+ozkY3d7SS2Fp4LuRwSad/quuH+O0JGAzIfgqn+tIMD4H7d5Do
         hDN+4j5zDKAoDtC1z7LfIy6frV3op9B4RuIWnvFMxIN5LrdzZ7xEpMrj/GEgJ9zql6To
         sW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785767781; x=1786372581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6NEy/PUFP4IYziRxlFsuxGJ+UKXD+3O9hbIQf+7B02s=;
        b=enshQsjbDI3/h+jwLkp4+GalQhax/xHS8d1Pc30IK2CbPuelLhfCTGqFLTTPzQA9PT
         e3JmxN+FnynuwSHlObtg0+qHG1WpDxxkGQelOdAx0pw8DAqawsKnB+MQOvQ40603DA2Q
         QzNJ0U8MphN8lm3F+ehQNnAum29Dw55Nxq4ekF1a++a4h7UcrAAvGF0BuvRKtMsyjUJG
         oQ5BdaOSc43go1oBXxBFGJjLdxdrZGHukDHTvqHzEMZBRmMMP0diKWROnp93JyKOiB21
         lR4adTkrWN8vLU5E7YopQ6L02RwrYcEvuaQ5kJmOhZXWCPC5rjhnPy7lGmghq7NEcf4H
         rq5Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro3t8sobm4GVwBpCZsIB2SFD34zQICoXosRPw0s/JNZdYCrja1sGR5RSgJTdw4YBmCgKWh6gecadNORRN6zUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJiQj7mHcnR7AEG4sEu4a6VEFo2mv3pML1WHvpLN+rz21QNaT7
	wElXNP7qMNStCmcRElVdPNz4q3Dhg8F6JEt6rLaFYIMXWGj34AfUe6Hk
X-Gm-Gg: AR+sD12MuEKYPvQRKZtrAIEIiIrVQMbZQgdqK1eTcVmho/vNby2IiwBEArABotkof5S
	f6a7S0gmJCIHUMb8tNCSmYyBHwWmLJTidFUsG+We1P/+epbnmMrjQ5GS4Kki9tFwM3N9Yo28fdu
	bYPsZMbyz7rX2ymiKpOJ5ElFfdbJKHWB/SsRcDh5hvZ95OHdnES3bdVW2f21rXTi0mc2uPa/YjH
	m3RV57momRXIBjEmX6F+BPmLQRR8o2sbaJOjGB1w+VZnNUjcQ4ggESikCLcH+foyYSARS5GfTJ3
	kZ8x0PHwfrTMajUOTFkeXZBhJE+7krA83R90IFaGtaMa1enjq9QLH8pZEsrHqmQok67Nkbt2GTG
	MfpYVxqBsfW8vdksaxb15C7oZoDivHBX7bOcr7ISjMvyLLX2d+R4FQriMmHNItCrNCSXl3If0ek
	nz5RHQpPUQa2vD9/9sC4fUaWMifSfl9qpeAIa3pie4AP0HIqNbQoTFC1NdVMxLW8zlkRfeoQfCe
	/Kw1Rx2UdRn8A==
X-Received: by 2002:a05:6000:382:b0:47f:946b:d3fc with SMTP id ffacd0b85a97d-47fd72e31eemr14371381f8f.2.1785767780705;
        Mon, 03 Aug 2026 07:36:20 -0700 (PDT)
Received: from thomas-precision3591.. ([2a04:cec0:101e:c128:c461:1b2d:86b8:e437])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-47fd41cfdc6sm32663260f8f.8.2026.08.03.07.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:36:19 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org (open list:MEDIATEK MT76 WIRELESS LAN DRIVER),
	linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support)
Subject: [PATCH net] wifi: mt76: sdio: Fix possible data race when dequeuing skb
Date: Mon,  3 Aug 2026 16:35:08 +0200
Message-ID: <20260803143510.49558-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The next entry of the queue is saved as a refenrence and immediately
removed from the list, before processing the skb. It can thus be
overwritten by the queuing function at the same time as .rx_skb() is
called.

Split mt76s_get_next_rx_entry() to get the tail, and once it is
processed, pop the element.

This patch was compile-tested only.

This patch depends on commit 16254fc51f7d ("mt76: sdio: fix use of q->head and q->tail").

Fixes: d39b52e31aa6 ("mt76: introduce mt76_sdio module")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 8bae77c761be..12ee781a62f4 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -371,14 +371,21 @@ mt76s_get_next_rx_entry(struct mt76_queue *q)
 	spin_lock_bh(&q->lock);
 	if (q->queued > 0) {
 		e = &q->entry[q->tail];
-		q->tail = (q->tail + 1) % q->ndesc;
-		q->queued--;
 	}
 	spin_unlock_bh(&q->lock);
 
 	return e;
 }
 
+static void
+mt76s_clear_next_rx_entry(struct mt76_queue *q)
+{
+	spin_lock_bh(&q->lock);
+	q->tail = (q->tail + 1) % q->ndesc;
+	q->queued--;
+	spin_unlock_bh(&q->lock);
+}
+
 static int
 mt76s_process_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
@@ -397,6 +404,9 @@ mt76s_process_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 
 		dev->drv->rx_skb(dev, MT_RXQ_MAIN, e->skb, NULL);
 		e->skb = NULL;
+
+		mt76s_clear_next_rx_entry(q);
+
 		nframes++;
 	}
 	if (qid == MT_RXQ_MAIN)
-- 
2.43.0

