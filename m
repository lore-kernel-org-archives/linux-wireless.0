Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792481423;
	b=rBmskSqDe8kf0TZ2RRVszlOjIhowq1Tb7eRb9LdRl/xIq9oMi+qEAoDh3BasrWnAOrXy
	 MqjlU4zy/M1D6nrjFmb6pN6zHXwRZ0buVXyRqkOVS6Dp7RBUM+UmtEgxD9Ak8O9W5qnKr
	 g12LKrx55JmMIPhkGhZXBNyvH6A95ekUV+hdNiHcV3ktzEo8jjMTOY6N15F3cq9kgvPwQ
	 ESQ7kn6MOdub9REA40mqJiXp0pvIb4/5gHdruLQxdP0cfaPwMpD2g4qBRlLb0B88OxhMG
	 G8azPzY1ZxDu39CLAwHmi58wWA0StujdVGByh7mQmO7tmwgBy5HX7UmQDnY8pGCXDJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792481423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5tXRrlu6pVIT1vr+YhxUcVgo6aTbfODu2mQd8Xde0q8=;
	b=vkS0xOaMiJDISL4ats0bx005ETs5l9g0ujCocc3udga1A985FP0MaZnYcYHQ2En03A3I
	 Nde0KXKyoJwQcfCYxisDC7c5yn9U9gT2gg4rkJdWfvfHcyg6+vcQDIzXzunmsevRi96bx
	 9fobcKb3tCuA8Ct1FmrN5x9yTS9PAPsaEFUcXdrhhhggYMjXRE+VNF5jlyfoFkLs2wcFa
	 SWKPq0ctr99LaBEKuhWgBopI2FiNNhXOBIrbpvhOJOmza9JYNovjqkXI/0zhI9auJjBGN
	 44k9VsLQLt1OhdVsFrrj2cWzoPVmtG/+EvSiNY3V/fLA0+bGRdRcX23d7DQzo1uAm9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xb5+MZMU;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B92E606A31E
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B92E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Xb5+MZMU
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so330424f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792481422; x=1793086222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5tXRrlu6pVIT1vr+YhxUcVgo6aTbfODu2mQd8Xde0q8=;
        b=Xb5+MZMUDvQCaCZuh9EZ4ZzyQco/Zspi9lD22QhWEte1S5PDxeukLjC9KIi0HEvQKy
         6Sm9GOBmq7J51BwM4vWqnGSYKfpnJBEk8XM2ZlKHOUAdfJlOqr+gEI64dDEu9NXM/qWA
         cADorGr8FaZnClXEgvRzfs5qDEjqaLAURGiBtCZ3lZonwccV8/3soVLsR7QMc1QRf5ON
         eT/Ws+oxEpzU5ssn31xsAwyTH0Ef0vvi9hjXQogflHJng0XPGcIQmfZR5KiDzq0BKqOW
         sBsP1BilsC9NDx9OLXlzFmye6gWr23ytGoW/NLK0CoSH+fPdSImtDBNFfB7rVDXe6LFE
         Q1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792481422; x=1793086222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5tXRrlu6pVIT1vr+YhxUcVgo6aTbfODu2mQd8Xde0q8=;
        b=mSaSd9L6UYqdUDBmHNffEyzsN5q1xMEMlx4XTBA5qZtZe8hxemdAeg0gVkCIQWCGG+
         j68DLMmgwrLzRgsD9L+7/Sv602QHo/aQkErW1kGDKiUzwi+alNya9pKvxDPtqmCbMob/
         77Ar0wgwLm7uKwRNzJlAGu/Lib+kBPc6EcQfhOzUg6lNgInOmvkNgbfJoCFSPEz0odtL
         OKTrqzyXaGigTtr3HQ95gXmMwMz/fbnlKDdtIyWcwE9TuqbeKeBAu5DY4CnFnaYlOkh7
         3+/9jQDXpXR8nD3WXjDXIsgUtiHpMrUYx+ljqYWD2+Rztrq9L+CRbYTpdLWt0QJD3fG2
         nhNg==
X-Forwarded-Encrypted: i=1; AKwUvBwcom+Z0W0Ad81PH3h7+8CA7VBkLEisjQgA6LikoSG96fPgD9p+1Wjdzb/BmMehWJH9WDoVLUl3pfzydJY/Tw==@vger.kernel.org
X-Gm-Message-State: AFq9FYI0dPLH5FPA9tE5ODffZ4qNzbKnj1W9d54no69DuFu6M0qoms6k
	GDI3HXtcNFEGZbHw9iovZ9Q6EQgUDxGTtfbinY6qTmh+vHr1KySwmYHa
X-Gm-Gg: AYBFou3EHBFFKYsqevlYPcYANei+oKXJBxEX+/qDFo6dB3XAtQhTl+1X4TJWXu2i4dm
	yQHIQaR0ZMYtDEjfCo47SXC+kbAoNmAw+lgCRPeTRvFS69UrMBjIEehM//CghAbu54zU9etyq8/
	m8Vk2WUnemhBOqYrU3bta54KCDYn+twotzEkkK0Enpxt4jwhTgF0CB1ouu+7p4LfrQzOjw2WOzK
	DTml/jO1Qhk0COprZlnN9ncpd2QfJ8nWClCWLTbR1Qv2nGTaag88Yk9BPNWmYwD09Dg2DgT4vL9
	BqexCyPakiypMc0FknUauymStsk5Kz0mVd+GHPZzbF8IwbBm1ismWD/m7Xteh3Ul5jsCfHSD3ZW
	EcX8OUuVgZMt+vtfOXoLJ9gDBng8nhLe3/8aFCRfSZo28r0CUbtijAyhTPVLsKS3QRSy3okhl1z
	cn16cfl+hBOWNhuCAUac+CvgiZ/uE161x+7i4ApcBlyS42RC9S6JJHHHbs8WPTdympit6/PVoMi
	0fZpYGPRyEL1I3iy39KHoQ=
X-Received: by 2002:a05:6000:617:b0:48d:f160:efad with SMTP id ffacd0b85a97d-48e1e9f12c3mr3046877f8f.30.1792481421580;
        Tue, 20 Oct 2026 00:30:21 -0700 (PDT)
Received: from kali ([102.209.31.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d817d75sm4747712f8f.25.2026.10.20.00.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 00:30:21 -0700 (PDT)
From: Bashirah Lawal <bashirahlawal017@gmail.com>
To: outreachy@lists.linux.dev
Cc: Bashirah Lawal <bashirahlawal017@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt7601u: remove unused ee_read tracepoint
Date: Tue, 20 Oct 2026 03:29:46 -0400
Message-ID: <20261020072947.124586-1-bashirahlawal017@gmail.com>
X-Mailer: git-send-email 2.53.0
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

The ee_read trace event was added with the driver in commit
c869f77d6abb ("add mt7601u driver"), but no call to
trace_ee_read() has ever existed in the tree. Building with
UT=1 reports the tracepoint as unused.

Each unused trace event wastes several KB of kernel memory.
Remove it to avoid that waste.

Signed-off-by: Bashirah Lawal <bashirahlawal017@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/trace.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/trace.h b/drivers/net/wireless/mediatek/mt7601u/trace.h
index 07696b672161..208ab8b0117a 100644
--- a/drivers/net/wireless/mediatek/mt7601u/trace.h
+++ b/drivers/net/wireless/mediatek/mt7601u/trace.h
@@ -123,21 +123,6 @@ TRACE_EVENT(mt_vend_req,
 		  !!__entry->buf, __entry->buflen)
 );
 
-TRACE_EVENT(ee_read,
-	TP_PROTO(struct mt7601u_dev *dev, int offset, u16 val),
-	TP_ARGS(dev, offset, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(int, o) __field(u16, v)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->o = offset;
-		__entry->v = val;
-	),
-	TP_printk(DEV_PR_FMT "%04x=%04x", DEV_PR_ARG, __entry->o, __entry->v)
-);
-
 DECLARE_EVENT_CLASS(dev_rf_reg_evt,
 	TP_PROTO(struct mt7601u_dev *dev, u8 bank, u8 reg, u8 val),
 	TP_ARGS(dev, bank, reg, val),
-- 
2.53.0

