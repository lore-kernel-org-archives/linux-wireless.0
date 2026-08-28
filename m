Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA636E49B
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787929366; cv=none; b=qtahFmw9AnAr+F/JRlTXAaNqsKNSw5Sf6E22A/mEvFAYtMDzwgzf8SkPYRnGU4Rk5AAsw0JF5rDyy+Xc6dTy44WQy68WBW7y58hfCxEcOPhjwReKCR3jGhBiaiIGGENb6Yt1uJVm8hbrw08dNzR+k7yTRoMeCLSRcP0pQ/rve3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787929366; c=relaxed/simple;
	bh=3PzgDiqiy1oNIWRe2oB+sNV62Q+Jw0+EhuWagGqurb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nSTfxBeepP6nO3aaVnPG+DOqoCJ9EcDjGwacoqOQ1YhvLUNP4zvvEH1ln+BDGOgCnB0qI0Q8pEq+YNbCogIAhd+EOylrPV/EJB2E7wOUneW6Fibi1nv/r0vXBlYkZihJOHLorGkaFQZRhx7LI/Uz7nlnArowIMSuAi8BUwHMilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DC9l9AWh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DC9l9AWh"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-39686abd426so1088706a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 08:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787929364; x=1788534164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NOOUEhwDmB12LFQNSiGGCOAzSpgGLKnq2vsZHwr0Wgg=;
        b=DC9l9AWh2tEERohee0xTeMTX1jaMWPyFSqqJrgyAi+O+9AomXM4stMgrZu9EpZ0CO8
         VTzj7daDu4fZlkKT9QaSHlMk1GV8SFKrWMGlom+Meh9c8LNZiLCwTO//We/bpQtRTuZg
         QbCS3SoGX53dVqjo9abU/wkJL6qIIWVfLLLu40tru+akgdd+HW74MBiMyR/5R3if9LCN
         FUJeJNrQdUsCpW6gKcx3NBnkAESilUo+L6w83OTj/KokRL4vq4iOJ3sRjlD+/UPeJgxw
         6O7h2gRCxZkAHjax096yG5UQFrO95Oh1PPhqfwIHJR6KJvDPZbvyYVCHZ9BN35vDI2XZ
         OkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787929364; x=1788534164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NOOUEhwDmB12LFQNSiGGCOAzSpgGLKnq2vsZHwr0Wgg=;
        b=CoB3Ocs0ZdPBRARIBerrnunqrYupRjFrABxMzvkSQGf8SSTwmmqcxhl/P7LIyHQJM4
         +kRUYl2EkkExxA3FXLpBUnE1xrfqmakEBuxMDuVDQpKfNkBFZ+fQEsOj9Sn5Vg5UDmNt
         RwesmObQMwkZb4vOQGIcJRHbr5Aj6hXJhhc//nXnVxhXfa/0U0O14Wcq6qGsILh5fa3r
         WmhTPT36qZI/q3pu0dQZBCF8Kf141ESg7he6zlFaDC4eH4s5dxlOncUtOzKJtpl/N4A3
         Hv5vgqOlv8l4xBmylgQ/Q1QpXiYsNr/d1u8r6vd05KiEISfjVYdiK4CWnz76MrPLyufz
         hmtg==
X-Forwarded-Encrypted: i=1; AHgh+RpinlknVRoGD58OzNMkqd1zrn3tZD1b3lNO1OhRKq+yI3LftEwydRfHmdmWRgULpY/AUA2GHsASZF7YIftHQg==@vger.kernel.org
X-Gm-Message-State: AFuF++mVqLBleYO7OGnwfvWaUU6O7GIxIgVefKH7d+Hgfo8apI4YSgzq
	Xn3ZteZ1gRLyAIBzNIWKBx52AWaYEyF5xAS/XnKMOGeZtfLK0PbAFwnL
X-Gm-Gg: AR+sD11Bt26okvkBlHeoSyffUN4+KJ7H5qfq+T4UNJOnPLcdQivlO5z0bLjpCod1O6A
	k8RpkJwp1xRPOL9GaKqBj1KCBPUhDHGfixaBE0qUZxbYaB0SLqCpMziI8erU44KjSN4+ssxJrhN
	Qmh1V3sOZT46S3RlUB4htJlLU+3VTt6sqUz3LWXl+eDiVtesvAUDZ+sKSIzA+1JaR8I2qrC670e
	cP8zpCbplmAu5pfHrp+TWf/AWbbUSUYsZuKzatLilCQ0ClELPnxuCkHN0cRoFXY0RNE9+uBTnTW
	uO2rBtAca4jhiI/OV13Dwzvrcdu+BkSD1FRuub3bkognpe5+4Af4+d7/NRo9J1POU1TbOssD248
	t4WXkeuB9amsCXXbJVmrAot4xUEfqSxp4k0atYsxu4APM63ugpUgu7SMHRMG5X2T5a9Y/51Z9gy
	ePkZRIOzUzfKLms+K1VNK0gpVAKk+e/k0e2T3+6e3uWWg+BFFVR9OaeaTrbimrmIJGIce2Ts92m
	7QRMkmYAA==
X-Received: by 2002:a17:90b:5188:b0:396:5fce:8e24 with SMTP id 98e67ed59e1d1-396d0ea530emr17557004a91.4.1787929360339;
        Fri, 28 Aug 2026 08:02:40 -0700 (PDT)
Received: from cfarm424.jing.rocks (cfarm424.jing.rocks. [2600:3c18:e002:2e11::c424])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396db196903sm2911068a91.0.2026.08.28.08.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 08:02:39 -0700 (PDT)
From: Ridham Khurana <khurana.ridham222@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Ridham Khurana <khurana.ridham222@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7915: validate default EEPROM firmware size
Date: Fri, 28 Aug 2026 15:02:22 +0000
Message-ID: <20260828150227.1062217-1-khurana.ridham222@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7915_eeprom_load_default() checks that the default EEPROM firmware was
loaded, but not how big it is. It then copies mt7915_eeprom_size() bytes
out of it, which is 3584 on MT7915 and 4096 on MT7916.

If the file is smaller than that, the copy reads past the end of the
firmware buffer. The extra bytes are whatever happens to follow it in
memory, and they end up in the EEPROM buffer that is later used for band
configuration, chainmask and TX power.

Check the size before copying, the same way
mt7996_eeprom_check_or_use_default() already does.

Fixes: bbc1d4154ec1 ("mt76: mt7915: add default calibrated data support")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
---
Based on next-20260828; applies cleanly to v7.2.

 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index fe7b29ebc0bf..145d14a1012d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -111,6 +111,12 @@ mt7915_eeprom_load_default(struct mt7915_dev *dev)
 		goto out;
 	}
 
+	if (fw->size < mt7915_eeprom_size(dev)) {
+		dev_err(dev->mt76.dev, "Invalid default bin size\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	memcpy(eeprom, fw->data, mt7915_eeprom_size(dev));
 	dev->flash_mode = true;
 
-- 
2.47.3

