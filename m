Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792944721;
	b=P8YTznGoenAp3RiZP2oCKpQ7dDgAiNT9i5FhkA1XS15bIhzwxWRZsKSJSG01la9iwKwJ
	 7sATDP8eAKsCPgAhOHQq8wXw+tpT8pKCmlvGCDwHojXWbw7pGgo1j+33VVGw6srbHOI6k
	 zhdMEsozeAaZbCSEoAKVnMC38aI5vZQgf9JfJ57gZIaeoGXgTtfJTbiQK1RgX2Rv5e78/
	 J+5VVslmv+9AjaHt+VEF57/u040ej7H5oZOQx4FxX/5PflWUo//YecvczCVnbiGmFcpdP
	 Ok+H7Z4pB4Scf6xylOwu5+PyXArdnHccXz+OnrfL/jQXTJwhpDpELsyxz1hQUXWZNuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792944721;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rxJIZi5PWXRxChbJYcfw6NCe9gvx2dJ63g5LLmwA/KM=;
	b=1lLazbUZEiblTIjfo4xUc+sm5sl1L7WSFwmrJou3g2HzFfY1ATMQ6eTCk2hIJ9scyPIn
	 pidHwQ7u1p3T1eCny/uh2ttDhsyjUcZZ+/W7xwnzK/tCijOxmBJs/Ymhu2zYVSSdfgX1V
	 jZhI5xJ7hCijXl6igX1H3hnYw93fmc2tofkgqPc0LcZsXPzgB86wUKvuFEUtrS0ntrvhb
	 ZFMNRJ6aDdK5UUMl+wJvmyqpxziZMeyRUDYYueLkil6YyaNDIdB224Gom+5hslGAx8l64
	 meEtLsU3va/9yj6YOlIkae3E2vS5yLzBZ/4ztHtEOAHjFnAGIWA4Vq6RRXMulcXkOqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EWgR4x+x;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20115606A31D
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 16:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20115606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EWgR4x+x
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a070755c8cso936519b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 09:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792944720; x=1793549520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rxJIZi5PWXRxChbJYcfw6NCe9gvx2dJ63g5LLmwA/KM=;
        b=EWgR4x+x7nvd7VMDWpjTIUb+mXEffwOo0lgMC1PMyE7ZYGwlLbREoDNSkO2HCyZuBC
         HKWmyFR+9Ly0Y3mOz5RsgyWDCVATVA+7c2XsV88yG+HdAYFnhQ6ksPgrfmVXCqsR9V85
         4ESsDrLrLmkYqZ2sXPoc1m54aA2JmnIil11kt96I5aJ2Goa1aceMB2NXcHUGJaLRmeml
         iIIjYLxEu9Ypzti6mWnS2WTdrDadVZyA6DqMFImZUv6vAHGfXKL98EZrw2vKz4nAIRn+
         TD4iJeGkOgYiOYBnBnQyctyND9zLfN80woH93WeXLlmmMvzeU7g+vutilAhuQHt2Ev+D
         fsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792944720; x=1793549520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxJIZi5PWXRxChbJYcfw6NCe9gvx2dJ63g5LLmwA/KM=;
        b=j66UjmDfT/B9HvvI2fYgZr1QHsrxxOEvWK515e01qRbiz+AkvXQuql9JGmi3PzyeTG
         7FHMsfCOTYpUhKFkOYo7kvvwWFZ/GpenrkCfjDVqj5qVlYPjkDLKRVdFH7SLcUztn7Yg
         1hEfFN4Zgct/gqQuxIVh+sTSutH6I+93q1tX8Bme/ggvVxhqhI1MhNFTZGtXv2nLVezc
         JPXWfFm910bPYCmF6/a6Bq7T/egLIVRc1/onri9oWuCj/PFXk/4IxvrCid4EDM2q4h16
         Jl4otPdJ5NPCeHiraGCFMAfWvhj8ipDEZUBYBhRtm1rpzqnInCODyiz89dqwC8gxZBsj
         F+/A==
X-Gm-Message-State: AFq9FYKwyyfkEBb0eJBR6Sb/7gBT/KFsbovhOfJ6+4Z4l7zYzSEGwvdZ
	sT5H8TOXG8F2DQ86PDz4fZpGTkR3cGpPyslQjH1BJ6VZdtDmO6ysWBQ+tDynHw==
X-Gm-Gg: AYBFou0QPW6tkcPfoA+AIR1QKaBfDUXu8P6+pKr3rs4lu2gCToFkl/K0eJjTrXUVofV
	KAgQo5gUksjrRpHKVVOTjR3aPur0SRiGDbtqE44m/PbGQv+uo8/ZsJTI0K28JICmZ+YsxIlb699
	W0cPAZjAobFnWWrScouEbSsJvwQ0scU6nj9K+h511v1XWxE7XODlViyTX+/+p9xB1OtiafnWCxr
	yu68ZHN6IC20mZUvLUfsjTLgHTS4l9mZWaVbWJOPKO8n9b5RbknkDMF41MTr8TILsqEhv4VSISC
	xAUUil2hAyRwwgsoF4BYrxwY9L6OJfhDK6+4B7ms8Zm3N3ZAxv9AyG/jYyPcUAnO1nldCEERAIt
	OJuuH21IOVOoMIKFe52eRZJ+L5vfdKpJPyh1a2miV0+hIRaHu7jzwtWFu0dzKf++zuwOb5D589W
	j5wmR6xE6guyKDdr8JZKP3EcRYZ6aqiBtUArghv6kZCIB8OqPRXpOKqShoae6cw9BgOIWSdmGne
	LlZxK6+Ct8sgEf4G/VpkFXA6n6lCfmYC33VJuDcAq/p7/Ol4wTtlOlYQlaoAV/RNqd8dh+SWD7k
	eKmYzS5OXuLajc/R/kqiYTXy8lRSXrfk
X-Received: by 2002:a05:6a00:92a3:b0:8a0:70ff:ab27 with SMTP id d2e1a72fcca58-8a3681f00d1mr3448798b3a.28.1792944720395;
        Sun, 25 Oct 2026 09:12:00 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8a368d85e51sm718049b3a.6.2026.10.25.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 09:11:59 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ho Jie Feng <hjf3108@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless] wifi: rt2x00: retry RF3053 VCO calibration with higher bias
Date: Mon, 26 Oct 2026 00:11:40 +0800
Message-ID: <20261025161140.66990-1-hjf3108@gmail.com>
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
Content-Transfer-Encoding: 8bit

VCO calibration with the default RF3053 VCO IC can cause
RFCSR 4, the result register to saturate at 0x7f on 2.4 GHz,
leaving lower channels unusable.

When calibration fails, retry the calibration with a higher VCO_IC
for RT3593. This should allow existing devices to work as before,
while allowing devices with the VCO calibration failure to work
successfully.

Hardware: Netgear WNDA4100 (USB 0846:9013, RT3593 rev 0402, RF3053)

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 66 ++++++++++++-------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b62475..68755e388fd59 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2794,6 +2794,44 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
+static void rt2800_set_vco_ic_rf3053(struct rt2x00_dev *rt2x00dev,
+				     struct rf_channel *rf,
+				     unsigned int attempt)
+{
+	u8 rfcsr;
+
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
+	if (rf->channel >= 1 && rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1 + attempt);
+	else if (rf->channel >= 36 && rf->channel <= 64)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
+	else if (rf->channel >= 100 && rf->channel <= 128)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+}
+
+static void rt2800_vco_calibrate_rf3053(struct rt2x00_dev *rt2x00dev,
+					struct rf_channel *rf)
+{
+	u8 rfcsr;
+
+	/* Initiate VCO calibration */
+	rfcsr = rt2800_rfcsr_read(rt2x00dev, 3);
+	if (rf->channel <= 14) {
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	} else {
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT1, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT2, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT3, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT4, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT5, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	}
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+}
+
 static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,
@@ -2977,16 +3015,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 		rfcsr = 0x12;
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
-	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
-	if (rf->channel >= 1 && rf->channel <= 14)
-		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
-	else if (rf->channel >= 36 && rf->channel <= 64)
-		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
-	else if (rf->channel >= 100 && rf->channel <= 128)
-		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
-	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+	rt2800_set_vco_ic_rf3053(rt2x00dev, rf, 0);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 30);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
@@ -3046,19 +3075,12 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
 	}
 
-	/* Initiate VCO calibration */
-	rfcsr = rt2800_rfcsr_read(rt2x00dev, 3);
-	if (rf->channel <= 14) {
-		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
-	} else {
-		rt2x00_set_field8(&rfcsr, RFCSR3_BIT1, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR3_BIT2, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR3_BIT3, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR3_BIT4, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR3_BIT5, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	rt2800_vco_calibrate_rf3053(rt2x00dev, rf);
+	usleep_range(1000, 2000);
+	if (rt2800_rfcsr_read(rt2x00dev, 4) == 0x7f) {
+		rt2800_set_vco_ic_rf3053(rt2x00dev, rf, 1);
+		rt2800_vco_calibrate_rf3053(rt2x00dev, rf);
 	}
-	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 
 	if (rf->channel >= 1 && rf->channel <= 14) {
 		rfcsr = 0x23;

base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
-- 
2.55.0

