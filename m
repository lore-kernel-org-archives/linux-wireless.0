Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793181355;
	b=HGtTSC2/dNt5MNqx/MIdPiFP/KFcV2Nl+L48a0CbCqTCNY6dU12gKneb8fkFDvIRRcCJ
	 BujqmrRyXhu57lsIAZ9ouVAw5s0ITCS7vlPpDgxyfnroCKfnozxuVu3UeejUT8a1BNjV9
	 Mp3tdFqzmYCnbAgU1UzsJQIBYy8HuIexp5FXQaClJZvmIiiRZ0bKaFtoFcnZds27/Oerl
	 KO7kOnw6W1RK13f+M76k5pWRetb6t3GF2JqIAqSSbheT4C3OIvksA68hWk9fy1EI7Dyqv
	 A7+q6lW5sr2wdcZWV/uFO+WK5VkCjnPxsZlzKkk5MIOpkZVsCWxEtFLkSAY4dtPf2Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793181355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=OyV0HDmRMYiFl3wmB/hAy0yAcou0wSmWY5SeO9gr10o=;
	b=IAeGI4UpWJzRnKVOlm1QOwpd3WrDxam5jqL3p/UbqHG1hQZCrtjTOY/RtDn8rRVRIXRn
	 LX5b9QVgzHkgL1c5o8gVBmXW0JqPlzv+oIk3u+mbaUYHeBHRH6pEmXulaJ5a5BNItz0aO
	 cGNZRtPKSuCos4zsSSUf2aJqnrJneeij1LNY6hFE0axq5psbkqbJtO/Rb2pf+rLWiBXjz
	 nXWkvdEiNIfAXiDbcKS7+I2MsZ+SvpU7XxzBOZILFLrm4ekFLHRT5OFT6zY6dL4cRD621
	 8xVK+8ARlFb6+h845m4Wkbr3qif5WobopItnXULIm6xrR31WIV98OVU/5eIAW5Nvh9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XzezqD0r;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E28606A324
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94E28606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XzezqD0r
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso6328115e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 02:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793181353; x=1793786153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OyV0HDmRMYiFl3wmB/hAy0yAcou0wSmWY5SeO9gr10o=;
        b=XzezqD0rhg2oq8gXXJ3dkJrvZ9W3zyCQAJ9UfE82nVgy9EdtYlLL94ej3kLPpZ+IKB
         MFYmovrHli/QnrOIj+bv76+vskttkAj/6uuankSh4prnY6/u7mgMzVXXZa/41x/p3s9W
         bi2ORP3MxStNuK0wSL2rZz8PYtMNbGl33xLLCBi5d+EWHyEjZXHtlL5cvCnm4c6GJ7hd
         yKY+boZELNaT7GmD1VcJ59Y+V5Yl6RgrO+BRJB3h0SSnea9nqZdb2HtkRu/sOxH+8FYz
         B374li3g/ek2oge7Cr+v3rhLykl8VwdoS3hQ4hsgjOPNJ9ai+XtRF2SYxL8BdcptUa4a
         y0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793181353; x=1793786153;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OyV0HDmRMYiFl3wmB/hAy0yAcou0wSmWY5SeO9gr10o=;
        b=hKBVvzYehAyyp+kdCuOT9GZH9Px+ue3RVr0qN6HBem2ryQsLpHOZrvWDBUFVz1km7U
         3JhnJTLh2568KJMOY2F3IURAzZZpZIxzKM5A6psswr+Mp6wWyAw1BnszxsXC0S0RWz3X
         Eas14wABBf1ObetLkBpN1gdlNW/zGvaMYz3NJLBsikGED2NMtg58YXNGmEk4IgIiXzi7
         O1FrZh6CM5ZI9S+WNcCJyn8Ctv8aJQnEIre3A2WXcp5GRkmyJ1oNTybyjC7Fu6CyAIzJ
         eVM65dGRY8beOVack4mEW++YZ9NVBuuAWgfFwRAs/rDaNl+hhRH6V9KcbaiPVoESp+Lv
         akwQ==
X-Gm-Message-State: AFq9FYLKIG7qZQ3zkcsJsMHAxKmtRlqBB/L/4qLNq5HzYbnqvPEYNNlT
	mFS+F7MY2lg5UadUldO3CQlNn+/jSWmOSy+VAgqcXFOomrsSmqih9zuUVC8zB2BijT0=
X-Gm-Gg: AYBFou2YkN4CrLZZc/cbviCd0mXeZXO8hufInb3iTVK9+uV+X/6R6KnzT653A2GkO4G
	BI7zLixx+csB16gNTua5Sak8E6vosjTj3RLDa+ZMI1CAW9ExvVK2h+KHvsijP3PveNlyP3bPv9i
	/l0B+3xSFC2OSpHrvNwiiHNnERtoBU/ID8LVOuOL84fYeKHv8Eb1f7/UZSqkJHP85bl7E46d1rb
	HvbghVLiwj87igiTSvIDhvmDGAIMUFwgoDz9VdNsx2063c0Welusjbr+tsd5cnjNnKB0qUoRfcl
	7u8FZI9+orrfKAFeVAQ+L1IlLA5UdpUjbxYAWLD0CDaGBpsJz3/TK7OZPjvkXD9yo4aeOnQoFQ+
	iLQu8F0T+cRbyl/itzGS4ykzVA4fXkKkh7ugkDKlXxEGj44APP5/L2nq8RIJWTzvaQf/qmtKWyq
	KHR/LkebND5PlsQnN8NWkalLjC3MFabM36ThHQsSzBk5loZ5sE5coxVrqAvK+2svbvIBLicxSK8
	YB/xNW3ZH8DWd8P8KExxd33WcMI/1DdMN4rdSY4swwhkzSGffRTR/xabiWr1LApJ5jyf8ZpGSlv
	kJiLdjjH8Wyc4/zsmom3lMdmIs1siNzOVTy8PYY8GUxIU/ibRwq5JdJLIn60xb9gs63RMwBPBpS
	oq948gOqzOT2S1D89jaCV8zns3iTOzsHAXLqEKKBgIffOqgoyvzNnYJWz4+9D+/2TTv/8
X-Received: by 2002:a05:600c:3b1e:b0:4a2:10f9:37ce with SMTP id 5b1f17b1804b1-4a9665870e9mr39026265e9.15.1793181352921;
        Wed, 28 Oct 2026 02:55:52 -0700 (PDT)
Received: from localhost.localdomain ([80.68.231.132])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a97c42b3c1sm36317355e9.6.2026.10.28.02.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 02:55:52 -0700 (PDT)
From: =?UTF-8?q?Piotr=20Nie=C5=82acny?= <piotr.nielacny@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?q?Piotr_Nie=C5=82acny?= <piotr.nielacny@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [RFC PATCH] wifi: mt76: handle truncated TX-free notifications
Date: Wed, 28 Oct 2026 10:55:48 +0100
Message-ID: <20261028095548.15922-1-piotr.nielacny@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mt7915, mt7925 and mt7996 TX-free parsers return immediately when
an event ends before the advertised MSDU count is reached. If earlier
entries have already released tokens, this skips the common completion
path, leaking SKBs queued on the local free_list and potentially leaving
TX blocked despite a pending wake request.

The existing entry checks also allow a 32-bit read when only one to
three bytes remain. The event headers and the mt7996 version 7 lookahead
need complete-word bounds checks as well.

Validate the headers before reading them and require a complete word
for each entry and lookahead read. Break out of the parsing loop on a
truncated entry so that the common completion path still handles the
already processed entries.

Found during AI-assisted code review. The extracted parsers were
tested with truncated notifications under ASan/UBSan, using stubbed
kernel callbacks. The issue has not been observed on hardware.

Signed-off-by: Piotr Niełacny <piotr.nielacny@gmail.com>
---
The full driver has not been built or tested on hardware.

 drivers/net/wireless/mediatek/mt76/mt7915/mac.c |   11 ++++++++---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |    7 +++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c |   10 +++++++---
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 06cddffa..a5f4b71d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -876,9 +876,14 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
 	void *end = data + len;
 	bool v3, wake = false;
 	u16 total, count = 0;
-	u32 txd = le32_to_cpu(free->txd);
+	u32 txd;
 	__le32 *cur_info;
 
+	if (WARN_ON_ONCE(len < sizeof(*free)))
+		return;
+
+	txd = le32_to_cpu(free->txd);
+
 	mt7915_mac_tx_free_prepare(dev);
 
 	total = le16_get_bits(free->ctrl, MT_TX_FREE_MSDU_CNT);
@@ -888,8 +893,8 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
 		u32 msdu, info;
 		u8 i;
 
-		if (WARN_ON_ONCE((void *)cur_info >= end))
-			return;
+		if (WARN_ON_ONCE((u8 *)end - (u8 *)cur_info < sizeof(*cur_info)))
+			break;
 
 		/*
 		 * 1'b1: new wcid pair.
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 7af996ab..309a188f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1314,6 +1314,9 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 	bool wake = false;
 	u16 total, count = 0;
 
+	if (WARN_ON_ONCE(len < 2 * sizeof(*tx_free)))
+		return;
+
 	/* clean DMA queues and unmap buffers first */
 	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_PSD], false);
 	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_BE], false);
@@ -1326,8 +1329,8 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 		u32 msdu, info;
 		u8 i;
 
-		if (WARN_ON_ONCE((void *)cur_info >= end))
-			return;
+		if (WARN_ON_ONCE((u8 *)end - (u8 *)cur_info < sizeof(*cur_info)))
+			break;
 		/* 1'b1: new wcid pair.
 		 * 1'b0: msdu_id with the same 'wcid pair' as above.
 		 */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 36776a76..f4632a6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1362,6 +1362,9 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 	u16 total, count = 0;
 	u8 ver;
 
+	if (WARN_ON_ONCE(len < 2 * sizeof(*tx_free)))
+		return;
+
 	/* clean DMA queues and unmap buffers first */
 	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_PSD], false);
 	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_BE], false);
@@ -1383,8 +1386,8 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 		u32 msdu, info;
 		u8 i;
 
-		if (WARN_ON_ONCE((void *)cur_info >= end))
-			return;
+		if (WARN_ON_ONCE((u8 *)end - (u8 *)cur_info < sizeof(*cur_info)))
+			break;
 		/* 1'b1: new wcid pair.
 		 * 1'b0: msdu_id with the same 'wcid pair' as above.
 		 */
@@ -1425,7 +1428,8 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 			}
 next:
 			/* ver 7 has a new DW with pair = 1, skip it */
-			if (ver == 7 && ((void *)(cur_info + 1) < end) &&
+			if (ver == 7 &&
+			    (u8 *)end - (u8 *)cur_info >= 2 * sizeof(*cur_info) &&
 			    (le32_to_cpu(*(cur_info + 1)) & MT_TXFREE_INFO_PAIR))
 				cur_info++;
 			continue;
