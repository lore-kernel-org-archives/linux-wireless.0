Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896CD379ED2
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346580; cv=none; b=Zl6qAbyqT9Jy4UD2SeLcsCOQma35piX9y/SYJlgq/Aq9ywdnW+FEN0VqagLXnkYDlcPEpEnCoO8dKicrgzBffNN6GEgWSal6sgXrhGV7bt6Rf5xhRhmRzaRNelGhjii894O+kzhSCIY0CRtfHh9IudZLkclw08Jpf60wxCU1FZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346580; c=relaxed/simple;
	bh=V+iuPuLHAKheUEPYobZhw6wwlEloMhRxcZxA6HJh9OU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A4lD+yxLtfdTovlU8EwmHFcWVFNtOT9Rxa4p3stVob9i10AhD3wPJhFlF7am4wj92sjIUZDlzmpq3fG72z+52ETeBw1f7Z52lmnd3p+Aaxfy7xUI3xoEqYBnZAuCO9HVBVqOu+gghjDr3OfyOuiXps0LsyraextVjE3xwQ0z5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rrfikCn7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrfikCn7"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cca0c5799eso13107335ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 10:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346579; x=1785951379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uhRNnUu6v3iXVOcCWlWtprydRHy1s6GXmSq+3+8Dmcw=;
        b=rrfikCn7qCxutd36XAPUqKbenIIe/7PaTgMSAW0a49yvHXylEDAYWdx4KnzZpn6Yw7
         XXmOP4Oofd6cPia7bLmrjkxHCPR4HtIxuXdlH4fWHD10g2P2BIFxQo7/NeTviWi34JCp
         0O6KwncFdjfx9aSKPlDtsfDHkUKh3KU3qtHtCUbFNqE+Ty7RsAdI3pT+YsV6G/CKqZPL
         Y1BWNOtLNA1zHylQznE7c8qNsrEeF0rIy7nfFZ15zYv0wroeaV3el8rQI1q0SDq2/Sdx
         ziFTe5L8cdVuV278SSS7cL9EIoHvxRHiUofiLyfsaoiJHkxPkQNqQeSC03lQIiU05047
         16eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346579; x=1785951379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uhRNnUu6v3iXVOcCWlWtprydRHy1s6GXmSq+3+8Dmcw=;
        b=Q4RZ+qU72CViH5Tf/WyKrbToat5w+mYajC89S3xLFM8xkcvMHu7DjHG/VxZ7ywYZ7k
         ZUJJ9kyfxf4QefJpiaIIl1VNWSh4w0+5A8BD7gdSlr7tIGnLJb+M+omPKPukl7Im4WgF
         +pRi8VqFtWmlpRyUBZLqSLmB8PLDLazk7n3EsNaP534tM28nkQsRZeYXs9biC9C6YppH
         UPXIlcRag+O4OKt1mr2dt3WqTL0IkY/GkFy4/Mdg3YygSRbwKWykFTHd9mjoUkTjP++c
         /0BKBgwh6ejkg1SHr5NPFwl3H/6t+8ZliUngCXVAViLgP3kshGFIIiU3FaLXmepJEeGd
         HhmQ==
X-Forwarded-Encrypted: i=1; AHgh+RodQCZRZl3vnFmXnt9okkJW7HJJyYOWwVQKGBiPswyZKhDTMnNdXLZFdwK+TXUQwCit7MqC4tgtkLG1bATJwg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQsoZTnECTUleJPguiINy5BVId2FQbTSwNwTBaNQZ3synOIuP0
	6rGwYuN9t+I0MdtCDQBBAhbSXYjoS4m0cnzEojhnpZnSqK5Q8eQ6w0/Y9steTHbG
X-Gm-Gg: AR+sD12QO/7F2kvcpRQJpkrUGhYCW2g29KFioruBApL5xoQCcfvVzbwHTk6irREocYn
	7BR/L8DAN5+E8fYYvXEeKidlrf37qUJMQq2oBIwhy8TEMQKfU1iqT2H1p+YwR2Caa7zSPwvDL9w
	3Lk43HfHgM8QmyYrr3YRh+OQVgpY1dzVqHQrHDxNaqd/Vmm8yEsYNOBQgxvEpWdD6FHpqrHDJYe
	58RPHM8meEqEkZ519RTZlKBoeC+s+5ARb7XeBh9kKhTiAKC1YMif2w56ixP6Sq82w16dZPl8MbF
	cwuV0JEJ/oIClcK5PzKxSoEOErVDjG58dshjf/Sg6QGXe+OEM6xKbFPJLfa9ovYXNUqEvddSePX
	5AHBCJg7n//CsZizqPqyhoqcsWZZF11wU1uYYycDY0yw3pOp27X6/vtFy/dykzgONNfyAZvp9Yk
	Wes/1+VIdZ+ozvV61EaJbRmnbWm0gQ+TIQDZY+7KLn+hyweNTo1uBg/doCVi5equnIWeOZih0eX
	Wta/lg+rN9wc0cgBJDF3bC0yh4=
X-Received: by 2002:a17:903:2391:b0:2ca:ce92:6e44 with SMTP id d9443c01a7336-2d015ac47a4mr90613645ad.8.1785346578717;
        Wed, 29 Jul 2026 10:36:18 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([58.250.106.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf8880sm14628745ad.66.2026.07.29.10.36.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 10:36:18 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: send TWT teardown to peer after setup TX failure
Date: Thu, 30 Jul 2026 01:36:07 +0800
Message-ID: <20260729173607.13340-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an AP's TWT Setup response is not acknowledged,
ieee80211_s1g_tx_twt_setup_fail() asks the driver to tear down the local
agreement and sends a TWT teardown action as the peer notification. It
uses the response SA as the destination, but
ieee80211_s1g_send_twt_setup() built that response with SA set to the
AP's address. The teardown is therefore queued with DA, SA and BSSID all
set to the AP address and never reaches the station.

The in-tree driver callbacks update local hardware state and emit no
action frame. The station receives no notification that mac80211 asked
the driver to remove the agreement and can keep following the TWT
schedule, leaving the peers' power-save state desynchronized.

Address the teardown to the response DA, the station to which the failed
response was sent. This also matches the station lookup the transmit
status path already performs on the same frame.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 net/mac80211/s1g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index abc338e22e59..bd7baf481836 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -147,7 +147,7 @@ ieee80211_s1g_tx_twt_setup_fail(struct ieee80211_sub_if_data *sdata,
 
 	drv_twt_teardown_request(sdata->local, sdata, &sta->sta, flowid);
 
-	ieee80211_s1g_send_twt_teardown(sdata, mgmt->sa, sdata->vif.addr,
+	ieee80211_s1g_send_twt_teardown(sdata, mgmt->da, sdata->vif.addr,
 					flowid);
 }
 

base-commit: 57aa1718d5953dd532137d43b696c68545c2e0b3
-- 
2.50.1 (Apple Git-155)

