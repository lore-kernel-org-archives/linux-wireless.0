Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43815389443
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543055; cv=none; b=o1JNIW7H7GGImh9KirYmb0yoEOLx1VGB/TyZEsfeHOw4tmQP1EfRCiA+Z7TMUgS+ROhg3qBbA1Yh2gd/v7WEWleoaJTi4ASp1NdLUJiGoH3cSycDxSGEhkaxcbNztvDz77yzZmXWX1JInX8uwH0t5TZpRK4XzF/UWWV6UmlV+II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543055; c=relaxed/simple;
	bh=DS7RQI+SjbtaUrMx37zjsTPSpFF2oKhLuf0BMFVKnJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNXs9FE+ogZd0httid2HJjOBmPxdTfWzawXNWjgoyNf/zC6IH1oC7fGpnQwh7akZDajfzOsXOMjQ/C+ixTzo/YY5+VIToq8Bz05h94mySB4AurdeCkDNkqzl58JAuGbuREpoMYNVQzjBVN3ZOq7Q5MWGK1h+ZmuSKs7eV5w0gzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8a9d3f5c1d7so6339807b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543053; x=1791147853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=44C50Q4Ln0VEE6bQOHS+qkeZ/WSlCaRUIPf2SffjR1M=;
        b=b6PAbbb1J9h4G2F/3Rd0m9JP50KuEKTiVZvHFdzUMFF3MRHxzCXrYO9uEf4tnVC57s
         0jzN7q22Gj2uJshsrQw0MD1SQA+/4NLMCTZI2tH8PiuidtTrX0r6HRfWJTiysEOoAbYf
         YOp0hiUaUO4CHzJH8tmVQSXQziPsmnF4fFvn/eyNHUn6XJ7DiaoEmQqIikunODi1sbNG
         EdkkVnmS2ZSN94FrKbTnsBwsZp8WADAndUMexy86zgx3gkmim3rluhOv0aGvV/EzWeCp
         mncE771snZCcThak4PiqGMqDVkrf3/NnMMAzdPeq7amk5jH2HE9QfSBwM0/2LwsVLXme
         +fng==
X-Gm-Message-State: AFq9FYKK8q6SyxtErq/LxUYDxE/1AqGMmOnESQRrhq3srhv9butx/lRI
	5zUWUdPJn9PqRgkeLpoEKtvSYlerCKawQIH3KwQJv995POohS3uy+Xro
X-Gm-Gg: AYBFou3w81gC7OFHBrtCl9dorL02XzSAVumbU9zge6bYyU9+3rehW5AwtXI+T3ItAOP
	7PTv9LK9LcLM2V63YvRsptDkevAdYexv9ugtIJA3oJf9MIkaXeBIHE/VKkUqudhCqXGrgRT4CJb
	29o7IKkVkXC4UFADV8wKoShuvSAmZhWIPib/wPmaP9RHm4HYFrUUU+CZyuPVdJ5FA387ECieNPa
	Zze6vXxAYYqF5CvyCkGcs0pV2wMjlEK5qk1pY9/PBz2nawf2BqbBhRubMmbUPH5DxCWvKhJsOTy
	VQs1XDpQy/99+2LKirkaEOvi4rNPFBaBNSP0Y9Bq6qEzxBM2KbHOJ/SyWMnwU55ZqwMqTSzijaG
	OVvLk6u9ik+++pRfzDBt2va3r2sGLarQKXnrKZVbi0/23TxjLZJUdibIge+3evRfBVbeBB+imAX
	ihFQuKbuYwhNXxO8x43YMeJ/7wep5+xLMwDR7OlmREj8XEUaE6Z3dtoXi1rckBkonv49XNyWj/p
	vxhFWXhFoCRyzAkiC6d02wWBClQwsgoahzXyYD3cRQUuiK/A7rfpuYkJ6FOI5bkA7cztg==
X-Received: by 2002:a05:690c:16:b0:8a2:496:1985 with SMTP id 00721157ae682-8a6486081f9mr47069207b3.54.1790543053313;
        Sun, 27 Sep 2026 14:04:13 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:12 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 16/23] wifi: mt76: mt7925: double the retry budget for NAN unicast management
Date: Sun, 27 Sep 2026 16:02:58 -0500
Message-ID: <20260927210306.737669-17-sean.wang@kernel.org>
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

The NAN setup handshakes are one-shot at the host: wpa_supplicant aborts
PASN on the first unacknowledged authentication frame and completes the
NDP state machine without retransmitting an unacknowledged key-install.
Right after the data path confirm both peers transmit at each other
nearly simultaneously, and with half-duplex radios one 15-retry burst
regularly dies inside the peer's own TX window (measured ~50% loss of
the key-install on an MT7925 pair, killing the NDP setup).

Double the TXD retry budget to the field maximum for NAN unicast
management so the burst outlives the cross-fire window.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 101f571b027f..f19d0451f373 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -806,6 +806,19 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 
 	val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, 15);
 
+	/* NAN setup handshakes are one-shot at the host: a single lost burst
+	 * kills the NDP (peers transmit at each other nearly simultaneously
+	 * after M3 and half-duplex radios miss the reply). Double the retry
+	 * budget so the burst outlives the cross-fire window.
+	 */
+	if (vif && vif->type == NL80211_IFTYPE_NAN) {
+		struct ieee80211_hdr *nan_hdr = (struct ieee80211_hdr *)skb->data;
+
+		if (ieee80211_is_mgmt(nan_hdr->frame_control) &&
+		    !is_multicast_ether_addr(nan_hdr->addr1))
+			val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, 31);
+	}
+
 	if (key)
 		val |= MT_TXD3_PROTECT_FRAME;
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-- 
2.43.0

