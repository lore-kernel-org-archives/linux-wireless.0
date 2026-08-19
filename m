Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61174C9579
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787167781; cv=none; b=PVZhHXiRNdgBPOPwBtIIqxL9G3NAMPqmhQmNM+dnqiWqUWAV2aIc5o/AbSVxHMfL661lEfhSbnASKFcYKtOu933EiRDp/NJ+KVS+YUrR+wWqef3XYk8iJxg2Sawebv50FfSDEOa4aHl/gwtKHQPi4TEJ6XGNlazGs8YU8FtEdEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787167781; c=relaxed/simple;
	bh=7SMHHseQ0rCn3j0B97vQN6SaBN0cr4CvM9PgJeMTewU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fJHidScJnlvsu5yVQFZv9/97XRAY/pvCSrlAY7tt0+gaMQpZdt7M/CHXQ96FNTdv44Yzo/IzlVE840FAijV0fYeqSg2Ne3yG2d6QpM5GedL2FX71sqywx0vBfRvhBJwvce5fhCLOpCMTtAosehUlxSzvgtu8SrojhUsKppULH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=In9/Ek1m; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="In9/Ek1m"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso938660a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 12:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787167776; x=1787772576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O/sNYgJI7iTmex3XqzHbkrDBlq9Mkontfk7aIxaop2E=;
        b=In9/Ek1mR6qhCaI5bDgV1fc98uTtgXuLqHSTLfK0GFGgs6UyRylurKuz5lBQpnINAd
         cVV//wZRzbIVfLekDHNXYFATGtKZZt/+s9Bnk+ortnn+iTIjAHVud6Li3tNW7e9kHS4V
         v6WSsNpY3vQ42gSVL2rYDB6SPe5oFBoFaGLkrHSVwN+U1tqFei/O4BBRVuRRhW7biHxA
         hwwjBXYLgvzRRfBWBJHxYjsy2tYuXflHN64W+63qWqPHJYp0m2fc8v57Ryg6u6V0uKN/
         IRtIrGYY79+hDw6RPkMcFOXlOnV6sizjgiIbAXJ2ZQKa3zn0KHJ0z7opvC560V6AKsbI
         5guA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787167776; x=1787772576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O/sNYgJI7iTmex3XqzHbkrDBlq9Mkontfk7aIxaop2E=;
        b=Hn3QkklALiZIz6ezclB7lJiCSU4aIMcK1QYDMTm+MKCAe74P3x9TBaIgceEE+KSMYv
         G5nOEn1rWRpRfV5BtjTw6nN4bsxoYKSA1HYpW/8gCVl1o7fg2eWxXd7x/GM//9t0515v
         fLRtElfJ8uaiER7SYejM3TVuLbXGwfwHC1ejDje+7qLz9fT5kCRH+rT1N3TNeGbe0u7M
         WHHY43gRNEEuFYpzfeq95tx5fLGkZBNiNyH7o1khPLtx9z13TRzMHVvdMhFYstGwiD5j
         TXq3gSi95UqINmCLKaLYTb5mR8bWBBN2uWk/5EZafUJtpEUUXK6Fn3ZAkyX2TvNJN2aG
         gUDg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/e+6QNusMKHEGt1t1iMgFgqJh33UEh1B0cEj7FubHS3ZrfOSXXPUQNx7radbpO/cQtMYkA6vfo9CPXTAzzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyobt1gFlIIhiRsbzh2jB4vuRdKyyc/uoMIlyCplpuQ0MlbdRlR
	XBrnPbnWqBpt7fcr6ebLoqQf//siXaInZSCfRAW9sXtKP11rpAPQuAhc
X-Gm-Gg: AR+sD11+jvvx/naxPNB7IRwa8tGaTqkIx3QJva3BFVnkeo/nMmlFgvtZl2sEh4iw4jS
	AAFG2QImhuvWLe3WPemK57HEgnUIu8TX14dIjLIrCOamJDNhLRO4WIiNPYbWW2UhbFOlTUNOIrb
	yP8heoKptvXliM6dmCv93pQt8LFuft1mMl3RuX2boPqCtOTYAqeXe/wgGYWkSshU/MxM+zRPjNR
	ZWv7HAC+FjkidEXzbq4KnDlvoK6waObd72dgdwQH2Wz4dnBJZruXD3TOW3qgmMg4EV765FtfkZv
	c3hjeF44EOIhProEOShj+G8L4nl+xKPJIsXA81vWif5Yw7R8+GqBAkZYpYojjzRmD9IKanm8qR9
	CDcnhFtvveSVnYE0VRG5fOmXJvwGCw70oelGda41U8KmoKL5xi+dDMBM6nJXC28ud6rFzlmq8ZJ
	B+aKXIqvz1e2sAIbCK8/VU74MrVRk2FZI/y6mqDu4+oJFE5m7On01BJFZhH1mQAl0No8r7oA==
X-Received: by 2002:a05:6a20:d707:b0:3c1:fbf:1e2e with SMTP id adf61e73a8af0-3cd011d6123mr15174456637.10.1787167775719;
        Wed, 19 Aug 2026 12:29:35 -0700 (PDT)
Received: from DESKTOP-TIT0J8O.dm.ae ([49.47.196.141])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77be3sm9088789eec.10.2026.08.19.12.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 12:29:35 -0700 (PDT)
From: Ahmed Naseef <naseefkm@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	naseefkm@gmail.com
Subject: [PATCH wireless-next] wifi: mt76: mt7615: read MT7663 temperature from the correct offset
Date: Wed, 19 Aug 2026 23:29:11 +0400
Message-Id: <20260819192911.1886457-1-naseefkm@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On MT7663 the hwmon temp1_input attribute always reads 0.

mt7615_mcu_parse_response() takes the temperature from the first dword of
the THERMAL_CTRL response payload, but MT7663 firmware reports it in the
second one. On a DASAN H660GM-A (MT7663E, N9 firmware 7663mp1827) the
request and its response are:

  request:  00 00 00 00
  response: 00 00 00 00 2a 00 00 00

0x2a is the reading, 42 degrees, while the driver returns the leading
zero. mt7915 and mt7921 already pull sizeof(*rxd) + 4 for this command.

Restrict the extra pull to MT7663, as no MT7615 or MT7622 hardware was
available to check whether their firmware uses the same layout.

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index ff57ede87f71..1ce0192c2c91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -153,6 +153,8 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
 		skb_pull(skb, sizeof(*rxd));
+		if (is_mt7663(mdev))
+			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
 		skb_pull(skb, sizeof(*rxd));
-- 
2.34.1

