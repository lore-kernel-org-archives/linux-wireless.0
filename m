Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792429310;
	b=Wl3m6bO43pIMcoXfRgDPw7Fn7PsinTcQfrwK2/oDf79r9EI6GJy0X8CLKCo50qpF5DT7
	 XGTUvjuholzbl58froKss+aypTa48MsctjcmUK2N8nC3iKRyPksnFf8CMq8xHoxozhquV
	 nPE0uDWCGhnlFU4ub/EtLCZS4dGx9MkqTbHKQb4Hwmjg/R8JiRsvczCYPXrTAYUTb6l+C
	 JKg+uQygH+BeTpeHXQ6PzrprCiStJy/VZcyXyCnp6ifNvZvJOXeFSaUmV1S6w+X81slbA
	 2/S108N57foQ0ougs7e44KEzKMTjaoW5LcuvPgIIKlSQ2yv+cNeDvXt8c033dJSK+PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792429310;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zgt+mU6G66DdJESP7PBT5F43QMVoZCobZpjIWBiHJS0=;
	b=SXHwnRiXI9t3N01AXteKsi19UAHHh1HF89O3pch+4EZnE5XjxjrHZo43Nw9PGdICuBhb
	 F6Zc9L5aTDMt1uKndunEhjf+E/7kExhLD1heKcQyBfqZdpQ1QaUMWrhdifaonWhHI1YfZ
	 KW5pdHTEZ0PIuhXIITaDEEAyvDNUmTJnR8FRDPSnNRxy37zSI7VBFbABy9Mst0wtFFuX9
	 isY0tnbAnx5pUpMTWIf/ur73XsRXktLHyfLN1Hofheb4/gJ2RAGvMZmjOW7/vK/4R7kH6
	 JkEtnTWVdYW0dB55nYwT1HvFZSJ12jHLRiWJRFcqKUnzpm8a1IwTLornQSxVqnJZ0aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+cl5aD9;
	arc=none smtp.remote-ip=74.125.229.2
Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393E060A2618
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 17:01:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 393E060A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+cl5aD9
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso2363942eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 10:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792429309; x=1793034109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zgt+mU6G66DdJESP7PBT5F43QMVoZCobZpjIWBiHJS0=;
        b=m+cl5aD92Mijfn2SvERNlR707N94YKxIHz23ACoAkT0gZXTz23HIcdu8HOPuIvAzts
         Ncivv/QC50oyp+MSO66PpBTLeAy4v2i4oaAWoaScJkUN60ZhmPm8XoolLEZ67Pngrckg
         RnQV1heFz+CSJIZp5PcSTkzkqxRRz9V4jPK4wiPIYUxynjrEU86TTW3tJqnMH3JFmTkr
         KhqQECW1P0dzg+BhGDzeTIBbG+PJE8jImNSFIusc7jLnU9PJ9e1ENorjoEil2vDKiLzO
         nB+/XRjD3Psq2G9KH2uokQDBE+tzAxARCsRcBjsgY5E6RS+1ZD/sc2BSCSsvmczbyugG
         m5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429309; x=1793034109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgt+mU6G66DdJESP7PBT5F43QMVoZCobZpjIWBiHJS0=;
        b=q++0MJvwDI5/hlHo3POPdqAm6s6N8dkZf6t9jrOmYmWaCdyyHTGIKPDsfqaibf9iZJ
         6U6bqnCgeUqQ+AS3Mob1Jt2EBxBzjyIiFtlklRJOinsqhiPf/4Pvrn7LSBEpl9ve1j/D
         Sb/KpXkvt7EuLXZcg1X5bNNAC4MZZzkMZ2tut2VJgCnHU2Tz85zf0tyzRpLk5sdGQHZL
         4DM6pSiPEUH9tBxC1sNwv5jMC5IQ6/Q+0aPonYdODl0FFjqhL/ytroRZNpGST6vsrYI+
         c7JkliNlyDMxLM+Zmg/e0lWT9zE++xwIfQqkhaTzhuh5L5Nji8B1K0vF3fKTnll6+x8A
         wmFg==
X-Gm-Message-State: AFq9FYI8YN0ICTwz/qNy1SJIOfreq2v/AbXk8spv3P5oQQ18h805WbNa
	qauZ5QL0sRY0qCqne6Kje8o46l0UkLQJcvS3Uaxo3X3n3MRQQQqJ04P+
X-Gm-Gg: AYBFou092tkpiGPD8EFOz3dQQLGKchNSmCGPh0fXp7NW13sT/pr3pyokzmaBClqseCi
	+sT0C7AqEGqowWDw04fGwiPaxfFDhCQWTUMsICcMgLHHe9WUdbKaDb8GLvhVQT+rbto2jDtNWab
	KA7RiEgKeIl1kbXCKWJ9+MAcycrkDYwCy8SX2ZkjtMfhAjjXSb+rWhsk+FXv1drm8slRDMUBG6o
	JkuEkgWQ5LQd86gQMNRc2iWK+CdqUbmjjLxNuBC0T1v8LIlcypaZWW3yHVQDHJyYGDYUAkNYige
	DThH1wij6dUif3aqQPSnm6qv+ivledbpGTbper+A/EhP0DpdQu4P8sJNexYWqQkDQvR3vvtePex
	TMus+ZGFONgEZScU8yErvisDYilz5pI5IJY99/Y57qfDCxph/fjY3Jwl0hH94DpcCr1wjHkSt0r
	x4wDC3mcNlUQR592SNsPSsXVMyvWGedhob0i2L/w1xJU/YrixLwj9BuzuI84RyP0Yk0CD4FP08T
	L2npdXTwn/CGrvhfKKU1WEtB2bYOygPvUQhEscLlqYERx6G1Vlp0bHalpbOyMMw5D9Npius+YIa
	e0gx4mTC
X-Received: by 2002:a05:693c:65d5:b0:343:9eb1:9940 with SMTP id 5a478bee46e88-361a1f48482mr12961659eec.26.1792429309185;
        Mon, 19 Oct 2026 10:01:49 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360813b6ca5sm31748945eec.9.2026.10.19.10.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:01:48 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	reza1234khan1234@gmail.com,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
Date: Mon, 19 Oct 2026 16:51:03 +0000
Message-ID: <20261019165103.5990-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

rtw_ops_set_key() looks for a free CAM entry before checking the
command. When all pairwise entries are in use, DISABLE_KEY returns
-ENOSPC without clearing the existing entry.

Move the allocation and bounds check into SET_KEY. DISABLE_KEY uses
the existing key->hw_key_idx.

Fixes: 10d58823cb44 ("wifi: rtw88: fix out-of-bounds CAM write when key table is full")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 2a9b09fa76e7..5e40cf06a9e3 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -598,20 +598,20 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	rtw_leave_lps_deep(rtwdev);
 
-	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
-		hw_key_idx = rtw_sec_get_free_cam(sec);
-	} else {
-		/* multiple interfaces? */
-		hw_key_idx = key->keyidx;
-	}
-
-	if (hw_key_idx >= sec->total_cam_num) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
 	switch (cmd) {
 	case SET_KEY:
+		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) {
+			hw_key_idx = rtw_sec_get_free_cam(sec);
+		} else {
+			/* multiple interfaces? */
+			hw_key_idx = key->keyidx;
+		}
+
+		if (hw_key_idx >= sec->total_cam_num) {
+			ret = -ENOSPC;
+			goto out;
+		}
+
 		/* need sw generated IV */
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		key->hw_key_idx = hw_key_idx;
