Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9538644F
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785481932; cv=none; b=PXt+a9yy1v6Veh00U2/uhIVE59luJ0Y00SiTfpWHoW4ta01xiwTS9FqDrjt4qto3VDjwWk4bjq3WDN3VihOzQbCcKiiGBqhKmXLXblVgvcgK3mQDnUB0zGjn38U3x1HW/5kXn9eyWDYIaBdqvXD0ZDpEjtnMkAHdwSQ9ts4UJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785481932; c=relaxed/simple;
	bh=zQi9ubKcOArEPKQUo2BWV5Pccb8fFbLU0DSqAsWQMb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MtGhzBA50sdCOVrsXblyUAL97MFlRl0yiXp73oB5h4DgpJS6RNly5L/FmXFdLZLX7wqw5GrLOKgAkfr7EPAbyOdEmpuaj7X25fZg4R0WZvStsCLEw8Y3dje/aZyAnxpA6JlkItZdhnlSvXb8hlIHquvxvNqqfonvl9EPk7oU7RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EalirIWE; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EalirIWE"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so495688a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 00:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785481919; x=1786086719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p/zSUWBhbluccRh5Y+3PaEaBGuhqo6tGCiQ6G7WtFxk=;
        b=EalirIWEPJ09Cebu3MNRI8bkiwl2XsvrhhhX4vePKd2+6FLrOX3aTMQX3jVLuRjvgk
         BcX4ai9Z2wnmmlKmD/M27Xg3LYgXd+O+ZF+/W8DaJOo0TIKB1fAmmfM/9CcvVrJl2TA3
         RB+nEGbS+I77Aa0tvHAgdJktARzCN+MAzSQ4Dc3mIwQYMSbvCw8oqEh2SeY3YiwUmkRJ
         XmnWWrLkUA8zAyqGZEiFYclpg3y9Xb92EV56kQva/b6fUyR/mJcXfjFaKVpAe63MkijH
         ALkC7knYR4gavBnazUG3eQQryYTJJGZQKWmaPvjl+U+oipmfvCaBEiIwRfYaukcDS4zE
         No7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785481919; x=1786086719;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p/zSUWBhbluccRh5Y+3PaEaBGuhqo6tGCiQ6G7WtFxk=;
        b=AyeTXA7VPHf4WrrzxA7Tohdgp4pgIDEDRIcsZvVBEq9ktizMWm4Dm1RNE4YsGdqL71
         qwsCkODMUc9b15Xyph74iRazsOuovE9AgMhtM5c8HqADj7QI1ztheIP8PmhmPzy8S7Pc
         d45kMPrKRjQaEwIIOwmm7N7KosiPFxo6UBv52pkfS6Av1NM1Fm2e1yU8nCr7fzo9cqBJ
         K0joyO7AKsxTlxj7SE1z1fhdanwbeHVirXhSSTcplhCdH2YKBu5AJuymk1UrFnrXew7t
         8SOAUSTbZktiXvSkKPocmwO/fBnptUWQpA184Gk9rMPchbjUEcpBYMWOLvl40PSBpVAF
         FZeg==
X-Forwarded-Encrypted: i=1; AHgh+RptJ0Q0csFBMRU5d55efayCUfBjJB8F8p1jZeqb2nqa3RFRALlPkXoMUHiLlIUzYiQYnbImryI3MPwZ4Q2eOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcALYocCUxTFP84xnUK9CpghPJewH3F8JjEIgJz7SlYfmkBWFx
	n1jYXUz/X5/YfdVC/n73Or5S8o/jjRm1Ty7qehajiXJyQOGtqt5LoKUZ
X-Gm-Gg: AR+sD12I+p/9osqmAgDVqRyzfKjzTiC4XA1eALt485it4voDFhiDu2nmLfiZCkoinF0
	Wf8BHttodgnPorDcufVrC0Tz8riQSZiyxKhzpuzvo8xgv02svcI7IdT+KnJlrTudQYKWznjV80h
	Sdv4eEW/RjkYVZ5UZma7b4r3UYIQowUrwcCY3ZvBaveA0NzkMW6ngKivhMcfjS8KRNdJfTZzTTt
	wZFUmcUfknCggMgnoMeMx7ZOJN57WvzlNMzaGEYQ0QypBajXmDRy47dKskolpVG057MRMDyfnAJ
	w9D2fO3Brl3WhDXJ0acv8lMSdirj1L4OwsiWUJPvUvnF+dS7cQm6JJNnJyOsppqaxCsxw/dE2fn
	scqftdMJODSGlZ9j/znYB6oPuK1iVxVvOy933jOn9JCPeIX00E6VInoTFGNmQODPWGskb5qHBoS
	5fM2pTGF0e8kEmOMD4XW69V9jqjF4/LdiY5RNp64W8jVE1M8HgvHyLN44tzL8TACdrqd6BENG8t
	2RAYLdj8x88EM0hYXjdCOC0X6Q=
X-Received: by 2002:a05:6a20:4308:b0:3c3:a1ed:3c36 with SMTP id adf61e73a8af0-3c91b266a96mr892351637.24.1785481918740;
        Fri, 31 Jul 2026 00:11:58 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4f0f0sm2308226eec.2.2026.07.31.00.11.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Jul 2026 00:11:58 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7921: validate CLC indices
Date: Fri, 31 Jul 2026 15:11:48 +0800
Message-ID: <20260731071148.74484-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7921_load_clc() indexes phy->clc[] with the index stored in each CLC
record from the firmware image, but does not validate that index before
its first array access.

The equivalent mt7925 parser added the same validation for a potential
array-index out-of-bounds issue and later corrected the comparison from
> to >=. mt7921 never received either change; see the linked commits.

A malformed CLC region can therefore read or write past phy->clc[] while
the driver is starting.

Stop parsing the CLC region when a record has an out-of-range index,
matching the corrected mt7925 parser.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Link: https://git.kernel.org/linus/9679ca7326e52282cc923c4d71d81c999cb6cd55
Link: https://git.kernel.org/linus/08fa656c91fd5fdf47ba393795b9c0d1e97539ed
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 25b9437250f7..1c99645b8122 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -467,6 +467,9 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
 		clc = (const struct mt7921_clc *)(clc_base + offset);
 
+		if (clc->idx >= ARRAY_SIZE(phy->clc))
+			break;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;

base-commit: 4a0bd262df757b25fc4e2a53c947317c119ced4e
-- 
2.50.1 (Apple Git-155)

