Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793038552;
	b=goYhVmNe/wJIAvV0MUaoAZaW5ee0B3IJ0yWkr6AOVw0OjMYOUcIkWW83RQvmywYT7Q6N
	 Op0J0Du4bTxtHr+dfh9B66xj4aEI+9T3VsR9CNLX+ICAM2oX8wMbu7l94yC96evyZVaB/
	 k9a21uj3fkAQvot5QhZaFylwVgyid0Qm+u/KHU20/E5K7kl4Lc5VgUHKEymPh0AjH8ce9
	 OF9HfFvvRdQyjfiwJ43MZDGe2r4UCGn4PU+swYf163ecZFpzbAGVkWyn/VUR5wh5jA1Ix
	 svqduRoyznIny8AwSFfqpZhv0SZbdGb7L5SijGn4Qj7vwidVsOpMzFl/w//1AdTHQRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038552;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e/a5UC8LzaHcBIsnAWglDWLOmCzF1reqeK0hBm1thtI=;
	b=xwOOcTDnGwbWWWkfLwov1GQKDWrNa68CF9DP13wdAM6zsw8JtJiyI5MeovZDI6vs/bVO
	 SN9RHEpuc0AHQ7V/yPQ7M5cQxSe80n28IR3gMLP38sQdOWH2bvKVh2Anhwsq/gL1Cbx10
	 zEZRq/40Ye5JDSJPWqZyJzjZ1EAN45aVvs0NGhoY31RROJj775XRS8ggnbAwJ6QeYm1Ap
	 JURp6+Naq4eoI2nJLRph/m2wyMUcXxQqSJIm/r3V7C9iQB+n8IHf/dql6uEdz/CZltCXf
	 etuquoAprRKsA1TxaGJNEe24EMgkgVhYkO/mlYbgDbAJZDblvA5tFUAgIqGssgy8rWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="NFI/AhEH";
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CCA606A321
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45CCA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NFI/AhEH
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c5358fc28so3096332f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038551; x=1793643351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e/a5UC8LzaHcBIsnAWglDWLOmCzF1reqeK0hBm1thtI=;
        b=NFI/AhEHLMK0pZxbwqLvmMCYf5rhtksrAnyf7u+5ckP20DzE29qmCpmj3ha6TMhswl
         jz3k+SMEF8QGfMDqo/dF5aNeavYBQdPOc4N8oXuLzHD0NqD394mZbTPkpqq7agV4oUFK
         Ske22kcP517efhescxfjKkw/RCnfeoBLGY0vKGeTuPj5ZtkA6/ZNMjwF5Av0S4CTA6KQ
         iNgYcfGbsTcx2plMrbXw1907DGyrmqgqNXcxxfxWSARTmijhM20IFTx9y9qImk5KMSFz
         2+vVp4lOlrOys606L/eqUwLUAP/AbaGdlrhWHdRb9M4O2UHcLLflQ2XrS8QYH/dZeTfJ
         o9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038551; x=1793643351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e/a5UC8LzaHcBIsnAWglDWLOmCzF1reqeK0hBm1thtI=;
        b=kPnc51wQVyiIUNohc6UPteVW+8Yw1SeNFX45tHUqrhiwU9NPlyha1qX9UPcK5UA+xB
         xUc8WyzwMzrF49qhmB+lelM8ow0fdiamY6zwij7+Wzm7pxhmyF1xW9+kEsJyOlAH2KQ0
         1ZChjOA1K6CwLe0tGztJpxjYBN6AB2Q3LZoOMLsHF1PGf4jhaY3UCcLRlYVXYm5/uHBs
         1myRjJK++4Xyz+nIQ3Y5iMiISt185inG92Mwz7iQSR2wxqnRJtnmrw4fzTEKcPN6yQ/n
         XmvbGtcL9/rCQsDaP/Q10DBQbCqOcZc/9xuUI4ZUK+e7HOv808WVcQcqqSlyDYxHo/uM
         UKng==
X-Gm-Message-State: AFq9FYKCZukzgqGADdYvpsNBCX5WV06mLlKNHIuuhq0mQjtE6ez886NN
	/4yjs71UCrEA/netuWufcX0KD8qYtO2QbGaOTSXXpq0WZumcgYBnFZnKOLln9l3p
X-Gm-Gg: AYBFou3ULTdN3C75OguBwytrLVoBQqL2yRG6fAQQUmcgxHvK4UCYvJgJ/57+VLOyN7W
	qi6bFm2kEXkCBOsoHEBwJrgLnFlhh7vs41fsaQMQHNSr5D/11zKteAoMijpvJlnzHQkyirfo7lQ
	I6LXNgOVc0byabJLSgD9eKGxDJK7xP/HDxPblE39bwlQ8Va3TLMS7yJqunR6yrz3MUbFNFUoPgZ
	QEgWkBH4E7aGzgdsD43QvJBbHISXQJiOuTrskY9qEfySJiGOoLZzKJlwzdbV+mgxl7zdZclAHUQ
	Ax+tTY63d92BSGaWuFWkm2hmbj95bJK69IKDqlKICgbmL2oTl2UnTmv8Xmt3LZthHoJ2aK91zsK
	BdqzXGQDGQqncorKSpCCrvFuy1sgQuDq5DzdxcYjqHJ4qORw9KDP1WWZVRBzSTJL5RkG2XSqSVH
	EhOrHYCO3wqkp6U5UNTLSKdKFGXIUatEUqaMRJUkNUDp8fbzgV4KwuRg6xOR0sAtq1L+tHetlUy
	qOrQa1m3sd/CWUC/GeD8HZezFcMkqarLSuxHI8/b8auRJK0gXzEZtY1L6j2zGyoeJsEgRFQRWbw
	pxbBc8brQdWACUHYzElJjE+jwg==
X-Received: by 2002:a05:6000:2281:b0:48e:4f1e:5e24 with SMTP id ffacd0b85a97d-48e4f1e5e33mr7260221f8f.14.1793038550554;
        Mon, 26 Oct 2026 11:15:50 -0700 (PDT)
Received: from luca-HP-ProBook-650-G1.lan ([2001:b07:6454:c33e:6c42:b004:d90b:d191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20967847f8f.45.2026.10.26.11.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:15:50 -0700 (PDT)
From: Luca Casati <luk00casati@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	arend.vanspriel@broadcom.com,
	b43-dev@lists.infradead.org,
	Luca Casati <luk00casati@gmail.com>
Subject: [PATCH wireless-next 1/5] b43: N-PHY: fix the TX tone sample table
Date: Mon, 26 Oct 2026 19:15:39 +0100
Message-ID: <20261026181543.77763-2-luk00casati@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
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

b43_nphy_load_samples() masked with (0x3FF << 10) instead of shifting
the masked I value, and b43_nphy_gen_load_samples() fed
cordic_calc_iq() a 16.16 fixed-point angle (CORDIC_FIXED() of a value
already shifted by 16) held in a u16, while the function takes whole
degrees. Together the sample table ended up all zeros, so every
calibration that plays a test tone (TX IQ/LO, RX IQ) ran without a
signal.

Compute the rotation in whole degrees as brcmsmac does and fix the
precedence.

Tested on a BCM43228 (N-PHY rev 16, radio 2057 rev 9).

Found and fixed with the help of an AI coding assistant (Claude Opus 5.5),
by comparing mmiotraces of b43 and wl on the same card.

Signed-off-by: Luca Casati <luk00casati@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index bbc30cbad..66565c14e 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -1515,7 +1515,7 @@ static int b43_nphy_load_samples(struct b43_wldev *dev,
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
 	for (i = 0; i < len; i++) {
-		data[i] = (samples[i].i & 0x3FF << 10);
+		data[i] = (samples[i].i & 0x3FF) << 10;
 		data[i] |= samples[i].q & 0x3FF;
 	}
 	b43_ntab_write_bulk(dev, B43_NTAB32(17, 0), len, data);
@@ -1531,7 +1531,8 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
 {
 	int i;
-	u16 bw, len, rot, angle;
+	u16 bw, len;
+	s32 rot, angle;		/* whole degrees, as cordic_calc_iq() wants */
 	struct cordic_iq *samples;
 
 	bw = b43_is_40mhz(dev) ? 40 : 20;
@@ -1554,11 +1555,11 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		b43err(dev->wl, "allocation for samples generation failed\n");
 		return 0;
 	}
-	rot = (((freq * 36) / bw) << 16) / 100;
+	rot = ((freq * 36) / bw) / 100;
 	angle = 0;
 
 	for (i = 0; i < len; i++) {
-		samples[i] = cordic_calc_iq(CORDIC_FIXED(angle));
+		samples[i] = cordic_calc_iq(angle);
 		angle += rot;
 		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
 		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
-- 
2.43.0

