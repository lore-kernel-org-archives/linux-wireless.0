Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281710;
	b=dlkS1TVHu4yeTCmK/H4+Ht5SKOUt4oPfdXacUl41X2IzYKEbTvb8P97d8m/XHsMfvvps
	 381yRhrgbVyl8BEna5kCvghfq3DC+UiBidcHHGFXeXxwgxeUm0zyj+G7gkRHpUVgqFofH
	 kQn1Xuw1+lw+vL68gurMykJyp2vmjyjO5vRxqzbjUAwzVykZYuOcfbIB1SIdV48REuUah
	 VXL1Pzc/qR4q8FZuvjhKFeJMMeZK5+oD950hZU5NkVLITHSeyNkY3Ku0nTgrZY6xd9kPM
	 yMYzMLRLfUMPDridb9OKr1fQJ4GeP9RnQO3C6uQ+wl9wyRnbtdpuJVa0eN+LY+QHzTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q4L/mAycK6YCXG1/sVTRANwnogR4r/JWf4K1sYDIIxU=;
	b=j5aOiEIk1QXvcjCsrOsZYoSlBYCQiV0n5lnuKNAR4cTxJU2JsXhaiM3T4Y01LnPZ4tvP
	 EnZ3tw0g1JwkuvRobSP8Ia5Ay60WnO7eBSqcQuLyIPVtQRgpnuSxh4OJ04hVDiwkcdRKM
	 Mu+ODICqUzMUuggYSzPGAPjl9m+WI0i6wJGQ2FcS+d9Y2apZKJDJ4T4jZaCq/xkSTfFcS
	 /eHeXCOE/FHNboPBsuiAj6eFYrrOghogvTDxF8BEU3BTrOuXHTp+ooREAfaZo2Y08M3AD
	 gDfOr96ZatIWvDjDTrF3xafADRIZg2KM+X2IVz+noy/o1ifxQfTPz+HiSW+CZ3Nzu7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rp1d00sU;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D4660A2613
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42D4660A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rp1d00sU
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a070b3f44aso953184b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281710; x=1793886510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q4L/mAycK6YCXG1/sVTRANwnogR4r/JWf4K1sYDIIxU=;
        b=Rp1d00sUPN+JDGOfu5Djofok0ipF8RfEhXUERS0FFOpY71L5ldszGflh/13yTj/gaD
         Cd410ULtkajVaGh7YSBdYCTeYPOO6ghm9dJzmm0EbQ1nWB8m3cHaiqWqyCbM9ISetGKG
         zVyW/sNDfw8WoOhGDw4cPejhNCx7l3Cu/UfsmiroLzdvxS8vAu9vj1zNVCSvRE3cu6dc
         TuHkILurZJrKFdDe3DQ+kMk6t4mEAFuWX+0MK2Oz+osSfhA7BeyGvp/WwTXhn+ouPYhB
         DnE/L5HJcq1VssS6guPYZGqtyozFl40cX23kRK5oG+2QztUnWhmtVmC1IUX48RCIGC2E
         hCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281710; x=1793886510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q4L/mAycK6YCXG1/sVTRANwnogR4r/JWf4K1sYDIIxU=;
        b=f/3wHSWRuuEe/L6ZGLqrWtgEfpouffdeB2JwTmFzsfyRJbGXXdOSOVQczrLKJ2jbYj
         GsKMuIdZoPb7iC3acXVHRoHmPe3BaqQpVHJVirgZL9yZX30OJOU7J3GgZ0Xl2Zk+uOWW
         xHAg1PeM/a/G+IaFmKzzHXIfRJgJwqStHWnkPxlaZTToW5jcF0H2LfcdRtPvZEoRiaHM
         OPwBdMSvahlPeUpn/QfAfIuxGuWGXRe6fhfzJ99NzJWj6ZtvzMx78DjvzE+NRBgdj7kw
         ptiXg75ru4GnRzTJeVryuMxoof6NZk4xDVmu48fxZ15lWDsKTT9wXNsyU76kTGEu7pdU
         QeZg==
X-Gm-Message-State: AFq9FYKf0CG/bFPNo5ZgT+JtffOUO0wrqU7blsK+57b1Jqf2WSWLjc/R
	Jq1zgxFgqJFw2zny7y6zjN92tBKYsqigD3urpk+b1IYBqCg4kw0879f+HgqfQ6Ax
X-Gm-Gg: AYBFou3tBHPvBBg0ocR3xIscmEZE21gIJrVl9oiEOYwMwvzr8z941/EjNirX7n+Zsc+
	MRq8Blc2//jz78sybcd9oZnr7/1G1t7gtDcaxkOncYpse4DsD8xHvOqM9R/rMJJqHMVksUD5010
	0TX0r3o0G0xkZIJNWQSYdSM1jh59wQg1UrqHjAzQjKEjNi58YYPhCWJDmydxY23rDuVc8NcUutK
	fLiOQg4CITUvsXOz/mc6zVLsl9FEXSqeeLjXjjEQrxN4GBL9rgi+ouML58oXXrQXCPLJHrlFBaF
	YU5sKEqdTj+wtMQhkyGWKO19US0aEL4bdRnug3QRyqh4QBOlWWDekYGqeRHAC56cLyYxOn6kvLs
	XCcHGOj8niPV3U3ciVhrASmD8V/dEgk/9K2TAsNI3j2xzws6sF8yLOKijEr5dwCXMpaOSST1A4c
	5rVuGfm3FG+pOJzlb3+c28d+e9bZLwWU31ztEMpsZbzbXPoDxGFuI+5W9/UD7GTM+KkHLkO36JT
	GadDRg9kUurxu8w1mxGCq7fw+5hhreIq7OSBpGUY9IFE7vjt5l9+SVwupO1RurP0+V2WCg1/Rp4
	XpHrAb4Wz2BgAk46z81kr2HXLfpicOQpNs9xcCP1htTx7Qd4Yz3YYM9R1O9idCNnwYcsKcTNSaP
	qMU2t5QFt
X-Received: by 2002:a05:6a00:2e94:b0:869:9298:ba59 with SMTP id d2e1a72fcca58-8a6e08d482dmr4610317b3a.0.1793281709636;
        Thu, 29 Oct 2026 06:48:29 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:29 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 3/8] wifi: rt2800: use the 3SS fallback table of RT3883 on RT3593
Date: Thu, 29 Oct 2026 21:47:44 +0800
Message-ID: <20261029134752.1299130-4-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
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

MCS 15 has worse reliability than MCS 16, since 16 and above
are 3 stream rates, and 15 is the top of the 2 stream rates.
Falling back from MCS 16 to MCS 15 does not make sense, so
make the fallback to MCS 8 like in RT3883

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e7b6edf485099..9d88ee698b854 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6303,7 +6303,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);
 
-	if (rt2x00_rt(rt2x00dev, RT3883)) {
+	if (rt2x00_rt(rt2x00dev, RT3593) || rt2x00_rt(rt2x00dev, RT3883)) {
 		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_0, 0x12111008);
 		rt2800_register_write(rt2x00dev, TX_FBK_CFG_3S_1, 0x16151413);
 	}
-- 
2.53.0

