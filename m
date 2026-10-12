Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4F3CB907
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812325; cv=none; b=odDb/GBLmbaGYHVmBOnocwPHZf1zDvvsjrguSD63w5p0pkZTCmkSdIi+O3EVWB9cVYABh3vauJh/5YI/sGKRZOI/9XxW2HPR3RbtzO86S5QSTL4Va9Y6vQYei/z67HhLJVU5UxTUG+iIyjLU97wR0PqalURo/0RfAmM0EK2GWms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812325; c=relaxed/simple;
	bh=ABYJ/Yw1TjXHnufHGoB3nTim9TwHZ+4hagkepnUn9j4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bpz0f+uSRjl/YvPc64qozw5GHqDxKE+EqUy0DKdTnqa/R1tgBUkIUV2Va1RIcczjx6Am6Ek8HBlh74NvDdAlleTYN6IRL168cn4fqB8oXsgrhMkARKz+8MW9tUVU/Rz4Dl5TqfOxUxeYjW/pwTTPq9OPR+ofPQDvKQT+KmwOl4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n/yAk2jg; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n/yAk2jg"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1213397a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791812324; x=1792417124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9UKhi6lcTuujnu/BWozq77KZubAfuSehI6HN/EmzOgg=;
        b=n/yAk2jgl9KRpWEIXbmYEpgcr47+bi30Fxb1zEbYwoZdCqNFFn7fQsW8JVE8lY2Jxu
         6/kTIwd2ozWCbOKPHABDriTT0utMuA8fWBca64QT0a+posDNTCYaPjkq13RF/tkxNiWf
         sSfC8en9lI4H+DqVW/vmFKe1qB9a4lTOnVtI4+TfvmqaHoLA3KvB+1PpZtLd0Fz+VpJ5
         34BVcpHfr1b6ZZmd4WXmjA3c+NdYL0XItWIGvfF1FD6EHxkwVIme9TUakJi22N07crHN
         FndTkncN0HbSH7UbVhbu7zV1LSZX+dtaQlWVx3Ezh8wiogmYDF5gseSwZo0MI9sLtOvp
         MgNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791812324; x=1792417124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9UKhi6lcTuujnu/BWozq77KZubAfuSehI6HN/EmzOgg=;
        b=X1JxtbX8yc2nQYV+FvVshzB15RdSqoEMTilOoaB3G8lp+3x7OW0ep5s20dOafJd/YH
         qTHH6i0dSzyN66r00hJZueXtINvt6bxd/vmbwtKiXhBJ98Uc2w/jGmlwMbnxgdLMIiDq
         OgWLkXR+Eo6w673l+JabW3sf1d3e0cIe0DR+OEG7a8J/9i2tcaN+DvkU7Jhv7ZmCvtrJ
         9g5mkILirG5wdoznV9IAPLmip6zjB7ezIREhQlRpWJMLpa/bFD/VPLlWbi71rzROg+Gl
         JMHNJZQTKIBI/OP2sukbebNErmE9YkLT86Jmjh74EUm9ubRJA06jm8Tqsbr7J/CGVdQo
         N1+w==
X-Gm-Message-State: AFq9FYLd1Nj4xI4koXsxd/Mk++pRKRwOv0DaM+9YqoBuaP5/vtCa4+m7
	tul/gacICb4OZb99qYZqkmbIMkFPv2pFkxv5DVsnDmzVNr6GPf9+9uAR3fr1fpfV
X-Gm-Gg: AYBFou3UfhHSiJ7yfJgZYXK7VU+sezxrJ4paIkDDXbLYPHcv59Vi3JO9B468agy/vDZ
	KAiKrpuLew+GcU150BD1tCPn1QMOwkNW0KzGBASMS3UpLGrhC8BNvH8h6vmqbMTVYsw5fDk75w8
	l8UF2KhhmqYnXMmu9LN/P8V9jkJUEYW+MGnda2CLbnOUNdVGNFIwPye7GVdtXnDzc5PRLiBQKT+
	Hk2jzLA2/JQogaEXsO/ExeAx7yaKUgC9+SdVVOQvst1QshS01zHF1f/OR/yd8QAFhgMkdw/qBdh
	hXkC3u9m9asFO21/WfqyH4ZnFyFTkc+kz/+Z87/ab3JB0UUvrHv1L4kQnUlpX8ho7CqtbyV3fZ+
	pp9gI0lXPE1nn84VxZLgylBA2Pb8wt68PWV7ed1zLd6Ceh0TEKNEcOu+mvBVNdq2/KXZMCh0Ixj
	yzUbrLpB2C4pGao29KQixDL4PG3gdXFhzEtAjiMogvjE/sxtWzh/WTyfSfEjp6jQqQ+BJndoCRo
	S7roPFouceDjaltEI1es/88jRCrUxSZQGWNubHfylJaCQPpBUVph2dthXeO
X-Received: by 2002:a17:90a:909:b0:3ab:884b:65b4 with SMTP id 98e67ed59e1d1-3ab884b7122mr3314878a91.59.1791812323830;
        Mon, 12 Oct 2026 06:38:43 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:a144:150d:733a:5ba2])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ab36ca0033sm16423579a91.2.2026.10.12.06.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 06:38:43 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ho Jie Feng <hjf3108@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] wifi: rt2x00: use VCO_IC 0x2 for RF3053 on 2.4 GHz
Date: Mon, 12 Oct 2026 21:37:27 +0800
Message-ID: <20261012133728.77780-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using the 0x1, the VCO calibration result is 0x7f on channels 6
and below. Using 0x2 fixes it.

Hardware: Netgear WNDA4100 (USB 0846:9013, RT3593 rev 0402, RF3053)

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
RFC for this since I am not sure if it is a generic fix, since the
vendor driver also doesn't use VCO_IC=0x2.
Is this also a known issue?

Testing on different hardware would be appreciated.

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2e2e382b62475..4a44a0222210d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2979,7 +2979,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
 	if (rf->channel >= 1 && rf->channel <= 14)
-		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
 	else if (rf->channel >= 36 && rf->channel <= 64)
 		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
 	else if (rf->channel >= 100 && rf->channel <= 128)

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.55.0

