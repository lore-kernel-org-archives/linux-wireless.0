Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D3389443
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543057; cv=none; b=n11ZpDl2B77V+Zlj+qLha4nhFNNgb2OhUlCVUlMQRUs4Jh6Ch6S99UZBtFg9qItdF+2JJcMh5Rz7FhiMJwIXwaSOWt0hxoC0z7/NYlOYk1xAZqmJ0Es4+ywEajN77S8gshGkw/13tSbhJ6mHfi2nYkey5BNNx5bxQj7jhGbOSmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543057; c=relaxed/simple;
	bh=Pphd5aAEy5oXlBYCYT/rpoWKtL3ZAzH53EQXhvce1Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHibzcR6ROEjW1J4TmwBQzCrcP+brQMMG20q7/LITpscbqQSBGSTVm21NLOWc9yjGENcF1DEYalXAhw3xsHCU69aCVzFwhCc3vWRlNsM93UC2ndW7VrPGQ3QozihjD69oPEsXx6A99VnB5SR2xt1QcKnWno/DAb9R/59xsV5JLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8a45b788a71so17113267b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543055; x=1791147855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVYAMJ2HjVn2tCxOSRJ4ZWdbKDa8f4E0sD/NwLApySM=;
        b=FJQ9tgJ3oLP8Ube9fGqRQa6oBWjufV6L/R75poCOsWSfklbz6r264q8cmsop7sRPY/
         CtvNDSw8ewpdQK8hgGH5LgfGWomS23S6qbqGpjSI5xc8UK6RgojKkhNoy2y2aBs7dTGY
         rP2ROYuhxog5iYc0yYTL73/DGmg7M8EEVVs4hU06p6BKGjkRRIrgEl+Bcii1pJiClrap
         e207FzNrVHC29ljmgH75P4Dxg9JpxRaVHXHX98YIVDs6BCGRRF4IYjdqo8dmJawccteD
         xnR7bFoBRudxlucUvNS/YOiHheJs9sYW6ELGKv0u5CTTjZ/CRLQq2dlM1lVV//UjgEcs
         ZVtA==
X-Gm-Message-State: AFq9FYJCx9LHq3mtWTzZvihiinl5YgFkxVHnsrVfdC/qlSzMcsYQN7bE
	Ell4AbHKHEaaV9SeNgeyMUWIvkhkVkGeuSH0c9xS9GvtHp/7pIDWHzIY
X-Gm-Gg: AYBFou1TNJzHCSCs/iIbY4eSo2JIDBvwIPwv9FxZ2r8YR6a3aDo0eMW/JXK0R1ytPx7
	tFNizrHbB//8LgdE1GuQDqhllqCZORsWnaVhV/kcKl55juLHWWq++H3oXZE3FPhZfkWe/jOJtZY
	0k5D7BKkxPV8HR4yI39IkHhdWB3Y34x1n8Jpbnl944+mqck2R8VkeW6Iek46ae3izxmXLmCLIH0
	kvZrlVdhxTTtn6TT/6PNNqT6HJifC9C5Fv/uEwnvdGKWs+ALjhR1/viR5n2k3oGDfp8tbC/Yv2R
	sotQy1xrwAvhrIS07cgu63rH+xkNJVYr48xw1I/9pMOlcb/qrKmFGibPIEGHHh32KVxv7rX3b48
	fper+nNfMgYWP9IuNApjIu/PEtf2xNEkugyVmDYvY8Q0MsOLTDXtVmc6/ZsfCsW80E1JhP334d+
	NOLuZ2Sq5oEvFqECi1v1+c3WBT5zryky1ffpFZoXWnWHrYS2cic+6q5vBftg/HOstSsUkwDUHZ9
	VZVXm6j1ifvo2QIjF8oZhz5T7gWENK+T7E0sRcC8YFGt9FY+CjspKLAnxfeSshtM38nhw==
X-Received: by 2002:a05:690c:680d:b0:873:5c0f:293 with SMTP id 00721157ae682-8a64c3421e5mr54283007b3.61.1790543055310;
        Sun, 27 Sep 2026 14:04:15 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:14 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 17/23] wifi: mt76: mt7925: let TX status of DW-held NAN frames outlive the DW period
Date: Sun, 27 Sep 2026 16:02:59 -0500
Message-ID: <20260927210306.737669-18-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

Frames on the NAN DW-WTBL legitimately wait up to a full discovery
window period (524ms) in a paused queue before they air, but the TX
status tracking times a packet out MT_TX_STATUS_SKB_TIMEOUT (250ms)
after DMA completion and reports it as failed. wpa_supplicant treats
the false no-ack as a delivery failure and retransmits: a NIK follow-up
held to the DW is then re-queued every cycle, the peer receives one
copy per DW (56 copies measured over one 30s window), and the resulting
pairing-confirm storm poisons the pairing-verification state, which
never triggers and times out.

Extend the TX status lifetime for frames tracked on the DW wcid so the
status is reported from the actual transmission.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 72a4bc505aed..4197b8221f73 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -185,11 +185,20 @@ mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid,
 		struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
 
 		if (pktid >= 0) {
+			unsigned long timeout = MT_TX_STATUS_SKB_TIMEOUT;
+
 			if (!(cb->flags & MT_TX_CB_DMA_DONE))
 				continue;
 
-			if (time_is_after_jiffies(cb->jiffies +
-						   MT_TX_STATUS_SKB_TIMEOUT))
+			/* A frame held to the NAN DW legitimately waits up to
+			 * a full DW period (524ms) before it airs; timing its
+			 * status out earlier reports a false no-ack to the
+			 * one-shot NAN handshakes (PASN, NDP key install).
+			 */
+			if (wcid->nan_dw)
+				timeout = HZ;
+
+			if (time_is_after_jiffies(cb->jiffies + timeout))
 				continue;
 		}
 
-- 
2.43.0

