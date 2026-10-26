Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053928;
	b=sdGG5cQB+ULO6vOhz7OvwXJxvJ9tdw1zt9NbG0QlsHwXfQ2gD75T71ALjuhicQ1RJmh7
	 MHV/HfQoR5Rh6ftslnFsozbGrHDe/cqYWHkMFX77gkWE0nhiTzknbH/0gpxT/v7m/Q3R3
	 xEsc+D3pNnuHOtZHr5u9yj8MsU3BicLkcnIViWAc7SbYKomDf0MOFndeTX0sT4RpyNrXO
	 JkN7TXKtdGwWGVPZyQszMasg3I2H6QQFF/+TcpnQzZ2qRkWJn98Z6d8MzSv/KbQJ6GKoS
	 IEiI17Bcun3aHP6IZj1sRHRoCG8oUV1kr8Qljh76hBdqI+tT42RLEjQ5cHeR8PQmCTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jI//he41YR3FxIYVnv4p5xMdPmJqhOBHXdSZfWcDXws=;
	b=R4a+7Iq3jnsOBXEdkVIq4EEfpER0/xi/8e7Us3nacsJXczqK+Tv4im9EnvM+pURkEY5p
	 ADsUuB764yZdyPwOcPgOQPmW5iN1s5uryJspc7dpmTIaUvGPWPYKbaHGGQPcYDPirz90/
	 sy1451rxXnmBnZsh6ZYBGJRAWWOmIWuCi821LPzQrwrs28Kyu5SG4aKWKg3pbgtScbHlF
	 /v+NzwwEOGdQ48gndVDSlfF9rviBfLUpbSIlD/sVUqc+ccNSgHjZn31bir0/AiMBYF3bW
	 4byR8WT5PtnWftL4w6QGey8v/5fhIg9dubGX+HwbEUqwRNBBMh03Dbk3fB4KTLRZEKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QwaN2o4s;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADECD606A31F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADECD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QwaN2o4s
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so23969785e9.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793053926; x=1793658726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jI//he41YR3FxIYVnv4p5xMdPmJqhOBHXdSZfWcDXws=;
        b=QwaN2o4scPcmHdg9Wj2AFz9YXm1aUVPhXirWyQt7UpzE40980ubcjbufSw8xBvwdeF
         vQGoUDL/YvS03zir97lepYKFGKWMLqiD6ozMWIlWtrDQT08L8I2KxBYB4zjdsr3ySB+v
         a8TAZyu8MQoHnoeNQ6KbBzMI87RrJeInZfT6MWaj2IW8/Xz6E4HOPoBTQ2u3bG1o1f/3
         g5srF7ux3CPbVFW3x0W2XQlcG25DAv3bJbwhX3PI02kXp1C/LhfcT+ji3/gR40z83QjF
         M/zupQ7I4CfwqnYyh4p2d1DYTBWAOECTfVeFykuuPHbPgp/StdT7q7NKYOZkWVcwNyVK
         qg5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053926; x=1793658726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jI//he41YR3FxIYVnv4p5xMdPmJqhOBHXdSZfWcDXws=;
        b=CWyuB1a2uz8kVknWe86JG1iOA/P+rejS+DnvIf9UHhQDanQ54KGbfaxljKoy7eOrzU
         31JpBjeGzDBtNUtxKmXJDzodeIIf8GIPQmJIV8UOffmj7W0dclPOFu26FTfIVRLxO5Qa
         wsmy/7WN2St8Q2+Eq1rPZYot2Vi0bgIZyTjOIM0OpF9Tb0A1/8OT5EnfRpvhDJJjbA1W
         R5M86AxRU6fI1i6yp2uTpZtCUTH6UKdn1ppuDh/+u67LcVPN0wnx89ZVLoPNH6s0iC0Z
         J72WLYS10WxlO1J4ymDesqGDrwmV1+oJdxkEiGVYdiWHOwTmKsiC8mMC0O+mQ01BZJ56
         GoZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXym51aVm94dDzcrBI0f7aqQPBOYccYYdfNpNJ+RPvMBOey1IEmwMx337EcejAtVTHCuEYy1pWFga3FIsYGA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLfDS3JGQvVt3f5z/I9wygqfon7vVBaypHOz5OLv1PE/+Cg0BjU
	eRThouCJiCjCmyXwBoBSLRK97vFGPdQsUFp98IUQI2dbcCM/2ToK3oY=
X-Gm-Gg: AYBFou2075z5yWuZThlbRPtlV8gAk5gBq71bKy7t9Ly6DQEeYYTJP3GHkSa31RJf9Y2
	yN934b0hCjrcv/mBuFyLYSEe8V5qN8cYd/fqkt0Rko5P2EPReah6lFw4YCNJB5zWFcReGL1iwU9
	kseSrT9M4Tjs3Qv/4V7Ol7jbvYsmnGipdmXvJQMOOXnAedvmdF0gPr6dJHKgbg9gBv8KNuM+0iv
	hu0uGpUO7hBdKHx1i0Rw4Ge/HU2hS7MPaMdG+27bwcv4PPhchJpipiCFqTP/oPEvo+uF27+j5IA
	gzYDxkJKqWq7tNtlFTrzslLR2S+2v4Unx/z0sw2c27T2kXUyNGO/xi85VJB4zkSVm13jPJuHtMZ
	QiZKDGzKYB2KIYsIH4tkK4LQa9GIVQc7FA90tZWMFfI4UYL57CV076hVKwu9Hgl5hxSXIXxUWDT
	n+ydl2/gkb9u9+d1eMVHnCRoL75vSjKteLpe+jpOIoFw+/Q72c5sy0nnFLb4j3+M+naiYaqwX3y
	rriUq/xy0NbBvNBX2ID9mi6bo1yUv/4Hle9ow==
X-Received: by 2002:a05:600c:4743:b0:4a1:fe26:24f0 with SMTP id 5b1f17b1804b1-4a35aca078cmr145695625e9.20.1793053925890;
        Mon, 26 Oct 2026 15:32:05 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0bac37sm238538735e9.6.2026.10.26.15.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:32:03 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	tristan@talencesecurity.com
Subject: [PATCH v2 wireless 1/3] wifi: carl9170: replace open-coded IE search with cfg80211_find_ie()
Date: Mon, 26 Oct 2026 22:32:02 +0000
Message-ID: <20261026223202.2089824-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

carl9170_find_ie() open-codes the IE search that cfg80211_find_ie()
already provides.  Replace the hand-rolled function with
cfg80211_find_ie() at the single call site.

Fixes: a84fab3cbfdc4 ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 27 ++++++--------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index fbe46a5e4e415..9db6ac9d6d3c0 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -490,25 +490,6 @@ static struct sk_buff *carl9170_rx_copy_data(u8 *buf, int len)
 	return skb;
 }
 
-static u8 *carl9170_find_ie(u8 *data, unsigned int len, u8 ie)
-{
-	struct ieee80211_mgmt *mgmt = (void *)data;
-	u8 *pos, *end;
-
-	pos = (u8 *)mgmt->u.beacon.variable;
-	end = data + len;
-	while (pos < end) {
-		if (pos + 2 + pos[1] > end)
-			return NULL;
-
-		if (pos[0] == ie)
-			return pos;
-
-		pos += 2 + pos[1];
-	}
-	return NULL;
-}
-
 /*
  * NOTE:
  *
@@ -521,9 +502,10 @@ static u8 *carl9170_find_ie(u8 *data, unsigned int len, u8 ie)
 static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 {
 	struct ieee80211_hdr *hdr = data;
+	struct ieee80211_mgmt *mgmt = data;
 	struct ieee80211_tim_ie *tim_ie;
 	struct ath_common *common = &ar->common;
-	u8 *tim;
+	const u8 *tim;
 	u8 tim_len;
 	bool cam;
 
@@ -541,7 +523,10 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 
 	ar->ps.last_beacon = jiffies;
 
-	tim = carl9170_find_ie(data, len - FCS_LEN, WLAN_EID_TIM);
+	tim = cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
+			       (len - FCS_LEN) -
+			       offsetof(struct ieee80211_mgmt,
+					u.beacon.variable));
 	if (!tim)
 		return;
 
-- 
2.47.3

