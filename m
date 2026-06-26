Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E0A233951
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 06:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455443; cv=none; b=VROugNPFFN6AXVDxqm2Z7xwrALH2U9eG+kMsrWSif+hUQXuoiague6s3fekqT2U6rfw2SSEZWDG9Bhgls/4vhbcGjuhK4Qf4oL1MKu4btPdY9cVO9gLU1hsxciaugAbD7kHH7jDpQaEt/C1kMyY9vKqKpBDidgdQHIdY4E1BXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455443; c=relaxed/simple;
	bh=KVtBG/HpUUebr8Zo+05BkRHLHmDZ6qeDE3lhMsW/i9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8pJVdmlKsv4F9pws/u3aqvXVk3JxrAMTWG08qW/Tv3/m9q2bMLLn9sEonKi/G1gJ5tmaol96Jov/6sS28FyDyU998+hvy8itQ6bTSU1Bblbs3xJraYZjEeoMJB8tkGig0Nf2DK5zfVvM9mFdR+9qdGyaxxRk/lThsf6eWrwKCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=dBieENqz; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="dBieENqz"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13986d61b4fso905786c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 23:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1782455441; x=1783060241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxT0VQTjRIITpzEvpcYDow1xF37UJV5EWTCXkmmApIM=;
        b=dBieENqzlng5NmzzAodgV7bxoZE9u/clYEivGMVnOf0PSQsyWg2XMxiDS9nK4YIlzp
         +oDILKpsnVjeNqlfXFiQuQrH0CwYOC+VOwsJ+30GyamBYxsh6K+rBgfaGYyOPreURHBy
         mIPyK7+tqR3audwTSC4Wo3aVkBfHAxkSKHtJtoldq7dOd9+yd/Ha4r8MqbHEgEHNrK4J
         eke1NrRlO/YKeX7kUPkahgLN0poqnA1c2gd5HxDacTLNcK+EQcIhopahTqRIh+0RAsEJ
         lBKVdkdkwBlDRzpEkHwCxcErGTLfNnKqnWf/TqplwH2D1VuD3lltn2/rto5E7u40T1KA
         vxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455441; x=1783060241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YxT0VQTjRIITpzEvpcYDow1xF37UJV5EWTCXkmmApIM=;
        b=DqyGEONS94lg4kUbbSy2P7pWyKS3P9KeWiBqSG/vg8wXJW2cwfvzSUFWzchOwV2MXk
         l4eY0AAq8cIdA66pNSQHVIx7T5OMqkexPMcNwuxQi8mzaurYazCIpy2QM6y8HUAlW5Cs
         iMsR2BzNdgcdJsE2vHuAsrxd+quAdCcKxxCYilGov3AlhT9cE40Wa+qywBvG8jksXQdV
         f+Uri336dxRSjWtrkqovIXgOSE6vVfMT1OOFgNcuKF6LCh0t9oSYn3CA1LtAGxAxHO5n
         U0dKLFGsmz+mBKMl97UxiDyxUmvE67ucuPDX22e+SGUUYgdcEZLiqCYcN8OP43UsVnry
         52hQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mc8xpvyoO8Y76OlTUVIZpURqFlzkkaJw2U2O8NP0VhQSoLVWYpgdRcm4Wm36HGEa+OowZ3XB5kGAVj/ueWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUhgjcauNhpaIF6GVzhOZl7SHxqA4AzEa9vbqA8wsBCtMLC1Wr
	2wtlVLc4RdlSSG8a6WJS0MKFfpZqJrR0DtYcxtUcaVwXZMrgOgITDj5D1MiYVnwM3YI=
X-Gm-Gg: AfdE7claobmD7v3cXFZSYIRVQjbxsbb0SDcOIlJnv2D0Oit9sg/LF16/l0I1R/McZ5j
	7xvyu2NdEOimxWX8dCr6EsKMzR/wctEXA70GJ5MEDGE45w8NrBTMpBvJP4cleLxM7kqbWD6Cs3v
	egOL1Bx4dtMGlge0EYLXjEvUVzDalaczobnXzsHD0WhHMyHD8ter96/x6XBaf3pUaTdXuslMga3
	C0CuXBey1790JE17wBG8GmoTRnWxgOP5SupuC+74b6lDUkkpxWmRcD+fefUdd/9IoDfWXrg+aqs
	JeEnDi96XleQzZHEHeipBxJhvhsltVB5Nctfn37mw98dbubTg6XAgBRh7yD2tqA+OBwqYwMPjBM
	EuzU1ZbxodHsjy/tr0r3dx83VOy2GEznKvc1HzO96+UuAp6BWlghKxZJph3YMgcU1vlS0rHYCzJ
	pZdh0B1gd58se6zj2tQiA97Hwtxz5AgxCKLGttbEAE4QxQpnATisoPvwKR+u58tkpPLhZ6S0Wtc
	bzC5E2PZH0TjEtiqths
X-Received: by 2002:a05:7022:1283:b0:139:ba7d:84a9 with SMTP id a92af1059eb24-139dbaa72a2mr4935152c88.24.1782455441159;
        Thu, 25 Jun 2026 23:30:41 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm15463687c88.13.2026.06.25.23.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 23:30:40 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: arien.judge@morsemicro.com,
	dan.callaghan@morsemicro.com,
	ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v3 02/33] wifi: ieee80211: introduce generic KHZ_TO_HZ helper
Date: Fri, 26 Jun 2026 16:28:58 +1000
Message-ID: <20260626063014.1275235-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
References: <20260626063014.1275235-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Useful for S1G drivers due to the increased required granularity,
but may be useful for others so include it as a generic helper.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 include/linux/ieee80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d40484451e9a..084ad45aa2d8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2616,6 +2616,7 @@ static inline int ieee80211_get_tdls_action(struct sk_buff *skb)
 /* convert frequencies */
 #define MHZ_TO_KHZ(freq) ((freq) * 1000)
 #define KHZ_TO_MHZ(freq) ((freq) / 1000)
+#define KHZ_TO_HZ(x) ((x) * 1000)
 #define PR_KHZ(f) KHZ_TO_MHZ(f), f % 1000
 #define KHZ_F "%d.%03d"
 
-- 
2.43.0

