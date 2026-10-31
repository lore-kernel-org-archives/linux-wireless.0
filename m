Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793476900;
	b=mbQnIbvALFioQq+T7crIPTUkm50EzDhuUFv5P/c9bSkQ1kmqcpK4T+rVeiE0+8Om8GIL
	 C5C6e4dYjz6LVgDhal0ty42dY3sZsB42ugbWLXd5ZLJx24Km1rmy+WqOPQYSvhy47SEK4
	 dS/C1rG0Avk+hCvPyO0Woi4IgMW6Xk3n5RTi8KlghQbe4DX5qCRW+ZB86NHzvwqbOb8/p
	 Jtb1CEivHjY1gKBBZpDIOBR2M2C4MKC+L7O7vXk1eEg/QUzsZMRUljI33jcZko5GGWVAS
	 fdQ8ZiJnRzeGz5GUPYXlG2g8N1h1yPKE8Y1WvCpeMJCqmXl7yaZltXYoCPHhLdN/bEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793476900;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nF8QWNalgOhe92tcpQzuwmgH5FtwIG5LTyzb5xD3w5k=;
	b=HQUhhjKJ9LQM8kHEJDAK00qp3qEEJHb8HLupq/bJTEg6zOR/8U3LdNnaplfAMboTH895
	 cfg9LNb4nUzhBiXG6mhj40azHFqwHznzHL7XRLFwAjht/jzx6fhYSz3ZWTdT45d509CP2
	 iLL1a/6/05iALwA2fVUJdP2Rfvy6FmryjJ+tgdFxHNFw9JjekOd0xL/CGdMsf1GZz/B0D
	 3AdRPdNz2yXrZFOapeo6GHGMPHucMTHN2am1D4XjGLtGh+2UTDoExgK/wDf79A6KVuvLu
	 gVcKGRXfQzgJ3KiDwblh23ML98Um67RqNTUg6PeG4MT1HKkC7+oETO6mU3UxZILPMxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tZK213An;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888DD606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 20:01:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 888DD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tZK213An
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso15807625e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 13:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793476898; x=1794081698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nF8QWNalgOhe92tcpQzuwmgH5FtwIG5LTyzb5xD3w5k=;
        b=tZK213An9akluqenagV8+crhbr0O7YSPvgefVvnAkHWVXYvYlsGuovWCQiCI1qzNNW
         czl5tS6fglK3/BaFc79f5Sokuxlzz+pN0H26Lbc0s704JJcpVHYstOIMekCw8djqW0DI
         gOsMQggN+hM4f5bWfRSpUvxKJIJYaMn6+3gbjNxgGy29449/eN0Yxdfi+7TuXdswwF4z
         RiQW8KsjRv+eovnMrOk+0RQp2tYc+dqrafT9sLUESzHpGZRtUwg4dFF1SUQzaprebDp4
         nUuDSUOz5v2A/yieaqZTOsmyAUTBP8NprA9Bj89XDscpL6egGy7AAgk5Mc21HlUJYXtO
         QVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793476898; x=1794081698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nF8QWNalgOhe92tcpQzuwmgH5FtwIG5LTyzb5xD3w5k=;
        b=uWid78EiXlH3GFMHyR9DzA9OnCvH7eutp/o9i04dC5Qh4Ahbv2lFL/LPfaPYzfONxq
         VpbANLh01SRH0YJezpnt04pR/+da4Zb4577pEYwN5HOuUapJ503piw8DNcQ90o4DmhRy
         MQTQt/7kwmjXBxXwG02gfBVoWwg4zjCoUNXO6FJv9jC/q+BFjXpRWkdxpi+OZZgHdlHA
         9RyJjL1kORJmsTiNvYXCAkDbGHXOETzsNdMedyte7lHiRK6tDoPpjyoQKh2ZJ8D2tkFx
         rbR1Q5BN2fbUEqT38HPeZprn35A9k6ixEZ9jgMoZLxF6JawrVF9cCdijy3W+TKnKG4fw
         WW7g==
X-Forwarded-Encrypted: i=1; AKwUvBxM732FKbSObtmSNHqCdB3Z2bLLjshG1/pREjn9xPb8Wz4eS0wPxAvaaHFjeEhpLMMDyH2ZZ7la5kY8e+rzFA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKqDvPq1kLL7Njeo/7meg83kr8XSrOuTqWckeEz/f6ZqPNNtr5o
	CoL9SyxU+vP8GUzfj3cGa2dDvr2uHExVVeYlZVwx4RdjTzgm5wJCb5XDmsgmJw==
X-Gm-Gg: AYBFou3ZdOeOSQPZtWfDX7gJ7VWawOEISx3msqkBzfbb4RlQJYqSSHFo3ouUU3mZ5AJ
	a2jGuHmeXVjbElI2w3k/pffiOcayHI0sbHCKae/TSa3Ruh2qIYj/ssydNeSOFlTmOVzWA+LB7EI
	iFnxLDMz6oIO/BYz8izRDLsIhVefbK4H2edzxEzR928dYJe7YjxVYLvcH5zjuJC7J+A02S/pFRF
	q5AhWb22SjcIBuVzqXQWMR0Q+ClKSnJp+8uorTD5cKfQ/y/XaRxIwLz1IDAe6fifhZkx7dmhVPs
	2rYzrIcDKm4DEAK831XElhiLjSe6Rr50UwcvJP9KsM5plid4JsfI3jQ6nDMEDa3jKp/l0x7ErAF
	ANPM6MM0RiPdaiDANnTpvg99ugNMk9bmoMKfwd8f0CeCYJ6uBZ1Oyu5fAZFVRr2zBVZ7C0aX3Lm
	WOzsAOBqEuDkrJ2El9q+w1kE66DoIimMJgHQSMmZf1+d6xpx+SnGpW1GcRZ1OHXGNQqk9gJbill
	XLKIjStqyL5B1khwTtA6hRvFxlHt9zAHNRghm+MmVVi2P2eboCZMAi4CPGViEW8FhZ3+xNfoaP3
	y0kYNgD01+Urgg+XUpnr70tsh9ZGRbYQT7sgeLLZ7Rjzeqcx1smjSHahCUSJRt+9Rj6n0DMPqY9
	SequSK5nA6XGyTYA=
X-Received: by 2002:a05:600c:354a:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4ac181e759dmr147569495e9.31.1793476897685;
        Sat, 31 Oct 2026 13:01:37 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8c0b6sm9845387f8f.41.2026.10.31.13.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 13:01:36 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH wireless-next] wifi: mac80211: fix unlocked STA statistics fallback
Date: Sat, 31 Oct 2026 20:01:33 +0000
Message-ID: <20261031200133.473693-1-devnexen@gmail.com>
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

The unlocked station statistics path returns -EAGAIN whenever the driver
has no atomic statistics op, even if it has no statistics op at all.
For drivers without any statistics op, which is most of them, every
get/dump therefore falls back to the wiphy mutex and the unlocked path
never helps.

Only return -EAGAIN when the driver has a locked op but no atomic one.
The link variant also checked the wrong op before calling the atomic
link callback, ignored its return value, and lost its entry tracepoint.
Fix those too.

Fixes: ab5d6dd9c9b0 ("wifi: mac80211: implement unlocked STA statistics")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 net/mac80211/driver-ops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1f3e0765a8ab..d19ae7fbcb6a 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -659,12 +659,14 @@ int drv_sta_statistics(struct ieee80211_local *local,
 						   &sdata->vif,
 						   sta, sinfo);
 	} else {
-		ret = -EAGAIN;
+		ret = 0;
 
 		if (local->ops->sta_statistics_atomic)
 			ret = local->ops->sta_statistics_atomic(&local->hw,
 								&sdata->vif,
 								sta, sinfo);
+		else if (local->ops->sta_statistics)
+			ret = -EAGAIN;
 	}
 
 	trace_drv_return_int(local, ret);
@@ -684,6 +686,8 @@ int drv_link_sta_statistics(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return 0;
 
+	trace_drv_link_sta_statistics(local, sdata, link_sta);
+
 	if (locked) {
 		might_sleep();
 		lockdep_assert_wiphy(local->hw.wiphy);
@@ -696,16 +700,18 @@ int drv_link_sta_statistics(struct ieee80211_local *local,
 							link_sta,
 							link_sinfo);
 	} else {
-		ret = -EAGAIN;
+		ret = 0;
 
-		if (local->ops->sta_statistics_atomic)
+		if (local->ops->link_sta_statistics_atomic)
 			ret = local->ops->link_sta_statistics_atomic(&local->hw,
 								     &sdata->vif,
 								     link_sta,
 								     link_sinfo);
+		else if (local->ops->link_sta_statistics)
+			ret = -EAGAIN;
 	}
 
 	trace_drv_return_int(local, ret);
 
-	return 0;
+	return ret;
 }
-- 
2.55.0

