Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B5126BF7
	for <linux-wireless@vger.kernel.org>; Tue,  7 Apr 2026 00:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775520944; cv=none; b=Dpzbb9Ky5KT2lNiGRRCQluoe/HM/0HYQdpPGssH9IMLyuauhq5aXk67F4kp5OjIuwjhBGJafXEQwvq439sjjRNTbI2H9N/4q2AtXbBQHBtcosKzvAfHlSQp5a7iKGryZxfIApHavHVOCVuzrsy8kQRb8n15pSFj2/D7qSBLfD7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775520944; c=relaxed/simple;
	bh=Weg9q8RWcHxAwHfD9AwRGwjfmhdGLSh54fxsaGBLXFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsk/7vTeRw1JdmpQ31QrrZv31mTGqa6DrghA7DzfgOBklI0NeqtTTCpMKwxistAyANqByyO2UOt4sQLUtqHq86tT/lwMeB31nPMDjaikeHuR2Kw4nxYVI4ln6Ks+R1tzJrIdTVF0RW7COTF6n9VUIK6sQqpZIhiTiBwQhM+2zDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQaOKDRI; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQaOKDRI"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-79ab5fd969aso43583367b3.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2026 17:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775520942; x=1776125742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=05+pDvcXLwe9+/aIdTM35zjBJ4BAXYW6MLX1cTkiMEk=;
        b=dQaOKDRIhp0P/KSlmu65qoKYX6iLQ04wHmC4V+jmUsE+Abp45oYaWemndmLcMkx2U2
         UdClC3SRrDcupoh6RsXT7+YSbPlRsVI4l8Am6Uq6Ps8QzFAcFhcv/97KumzGcwPXepgQ
         zMUABnwAnlAPXPgne0LGQPLM0F9jqz7EcE4BGSJo96sBqkvudrgcpnEQW/jUjyRyti7d
         mufgcUVIN/YXunOW5ydDEk7DW3oKn+of7QLswVxDRqx9C+rQ3JFZ5WkJY8zeR8B8V2hr
         hWN/12ISahwShwKuWEtMOYoMHE5DJhRDtMLErP9W3GcO6HXW9bL78JmotqiXVF2EVMoI
         Adew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775520942; x=1776125742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05+pDvcXLwe9+/aIdTM35zjBJ4BAXYW6MLX1cTkiMEk=;
        b=bpSTva4a7eWOpvH2NgUJLupxAILhbgnH4VdUuzu+lDz/LtLfX8D5EFDAtTiESAYyKH
         CgBaWWbpICJ7adhEgsb7H2Q4/pLt/Xw1KcFv5Fw+rSbtEAEoZxgGRnT1LcVyYCi7C7xA
         G7dbKEi/q5c7IxmlVhe/9k4bXPoI+THvqigRagWV94NTw+b4vsOvn9OZ6Br4tv3F0u2u
         3eMemftcGrx2/MEniWh8uZ/1scA1LpyrgYpslkZJOqHNHmSVOy23S7f12UiUocB+QKhP
         8rdnXBk+6/btUn3Ji+CYZ8FOBWWUKsAFYk9hJpuUrX6rQGfB0eUBWGMqkJo0peVHauXv
         6U0g==
X-Gm-Message-State: AOJu0YwezZXBzAJaI/PGmtZR+Y1x3ngq3G6xbiGBYi1H0tIEHre85n9c
	fFerDKqhOJEaTcfTHrk2JSsH0n33o5GzVBues9Ttowdy5HEOcBlQ9Iiix+88bQ/P
X-Gm-Gg: AeBDievXb8hTFVUb8LoTBjjngnBWemMIWK/V6EkPdQ6ZCZHXTZU/9CNpwad7W7NRND2
	B3y+asVs6LXmDpQttc2wFgS4xAMQ/kULAD5JmdbvNbFp/2KVIAZdtGn/zSw+lO3pS3+mMCQl2t0
	rEz6R8enrFiRAC04v2KiuUvlQjQqkjgye6cWp3GMOc0yTSJ0QCGrWbO3EalZCHSp3Ik657ArT49
	kNuqQfGQeYDJmXhHg+5UnFPsv52l+LpdQwpxMOjrN4YasqyLUC7huvxan9IhhKePFYIr/GxGB53
	Xsrx3MhQAKNAoPFmD6cZeUWfvdZIWtWgMAeMLhQxbZeJ/pQBO9pMOx4SIMogPAcB8VPgKhdajrQ
	6MM6jngf7GHoe8XnPBjKkc8tCBBxGvk35uLo4Ma5FIO3kDaScRuTZQt7anh+CzqnP3ji4n/KxfH
	OQuznJopvLHzvOFLNSXkW6bBjID6M8CGn3WAM/U37bl1JG/xtJu4PPxga/tWlNHPqcZz1RfCc=
X-Received: by 2002:a05:690c:4423:b0:7a2:7b00:67f6 with SMTP id 00721157ae682-7a4d31e8712mr114664927b3.9.1775520942183;
        Mon, 06 Apr 2026 17:15:42 -0700 (PDT)
Received: from DEV.lan (c-75-74-152-49.hsd1.fl.comcast.net. [75.74.152.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a36e320670sm59858877b3.2.2026.04.06.17.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 17:15:41 -0700 (PDT)
From: Joshua Klinesmith <joshuaklinesmith@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-kernel@vger.kernel.org,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>
Subject: [PATCH wireless v2 0/2] wifi: mt76: clear cipher state on key removal for WED offload
Date: Mon,  6 Apr 2026 20:15:29 -0400
Message-ID: <20260407001531.31207-1-joshuaklinesmith@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When switching WiFi encryption from WPA-PSK/SAE to open/none with
WED hardware offload enabled, throughput drops to zero. The BSS
cipher state is set when group keys are installed but never cleared
when they are removed. The WA firmware retains the stale cipher
value and keeps the protection bit set on WED-offloaded packets,
causing all plaintext frames to be dropped.

Found via reverse engineering of the vendor MediaTek SDK
mt_wifi.ko driver.
---
v1 -> v2: Rebased on wireless.git (was mt76-fixes)

Joshua Klinesmith (2):
  wifi: mt76: mt7915: clear cipher state on key removal for WED offload
  wifi: mt76: mt7996: clear cipher state on key removal for WED offload

 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 7 +++++++
 2 files changed, 13 insertions(+)


base-commit: 45dbf8fcea4dcf28cabcf4a1778e908feadf4c90
-- 
2.43.0

