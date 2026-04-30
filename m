Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A7D372EC6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2026 04:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777525158; cv=none; b=H8mRhHZM5AnHr9/JY+zKOl5+sDOYIK+Kn3uYyHx8hSTnPafvBx3eAExZjpLLqa0STUexjWMa44UpIdRBcGZ4etHI7nX2iOYlYI2y8E/chK8RK/u34XIHqgvhyHNMNEUvBO9fqW9Lpo/99GXuafHkfprCx3iTo16DIvTA2VTe8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777525158; c=relaxed/simple;
	bh=ZwVU2urQpy/QQ0fKIj5VurGhH1ajOHeOc6EE7xNV2SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzLQgA2lrhyAUcl6T04BSBvZ+mug4DuWwy63LhSgrflztsdxdO+OjC5QP2dhxakHVygztjZ3oQAxxvNhronyzZOS0lWYU1ZJPCvI89ub0duw6VII3gDcHkGioiGFAx44GHZbiSPYgdof9CuAtFD7Dnntiib6I0rKL0nW6Ln6bFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=GiiP12w0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="GiiP12w0"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so382982b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 21:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1777525156; x=1778129956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpRnGjHscUyU9r37uJg079OfgXJLE23KAufHZZ9FZiY=;
        b=GiiP12w0p3PcVQfuw/HG3hER1b5+8DbH/tysdATJovYpDXfl1rtXldZ0b6zzdT5KaX
         2M8eav03bB+z49TCXtixkV4/mrnPhAQuS46Ze0W/XhwGCh/sdbBmsz45kQniTtAtwss1
         iZYKdsTDt2NAdBa9d5q1DaDbLbxLmDKufDqBtYt9wM9qFCwrGFxBRu7sC9tD+zhqABWa
         jcKOBVHZHZkxIhgoHAoM5g+4zrN6NXw/Kfv2S1ZOz1AA9TA8m0MYfBCoDmixwoZqJIgA
         Do5WY+82vdjPtRM3oYv4Vy5EsI37neTqtKFchK/o4JOg+IFmJknK9XtMTKdngB0WTbrj
         G0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777525156; x=1778129956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xpRnGjHscUyU9r37uJg079OfgXJLE23KAufHZZ9FZiY=;
        b=jzc/yPOdLF85EhNj6I9zmYbJlm6YHcIfELzVZU8VWYliT3VsFXPMHpTXw6+DLNbqJQ
         31KVWFD2dViQQNrIdk6kUm5fauDEHAzPq8XhljRZwrVgPg4FMIKrmD4+1eFaQsBGSHEt
         vrGlOqc2yXzoRkfCDWOBtXxzUsJd4Is7Y8jcQbqfIS6+0DYgztzdc087XrRztcP7s1+L
         1V67U8kE968QoXb4wEU4Pyi4mNxz0LuAyccQk9BtSzJMu3bT0BsOUj5G7pKg9sqm8HuE
         StxarohHcsnmUJiqUOGNAVaDdMvaFCKHdivo1l/434CPNiydBTwg6AHet7s2sSLaTX01
         gfoQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V3rxd+kuEYm/ChN5pWS6r2PesnzjiFhgbVIJ9079Fr7wmLNzY16rP1FR4DQJa3Y+Itv/ySpvjMvR5tpWAWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFlXuLQxHtQ/TKZ2FNBsOM+AR7+/FtBT1BK7LyKqUzeL/Ypifl
	PcFO1woOXk6PAIz/gkMK+K/7CqXz97S0/cfU+Q5R08OeckQDJrKDXywVIempBRTcbAGWSFPvDQl
	mLh/3
X-Gm-Gg: AeBDiesZHIXz85oXkY8sdjcMtOikzEzKMoWgXP8MMlN942+ms+sLwz+aGv1VUrTmCzi
	AqzTTQdA1OPsGGvssLAnM/gwqx0sPv6Yux1mRC86DVnOQdJNsoE5DO/KrC1MMSJA7HJRe7C60Yb
	MREB8+03+B7ee/xnPlmEinuJv4pyjz5LOy5CM/Fq6FiRfdGsM0byCWzU0lAV+quaozoeah53x26
	SrpWyas/qjeWd2mOny18L/9VyMKFDAPvoFdt2q6Tn0Ts2ZUG+1haeOlELZaw4UqXHGmkU9EHl43
	2J6SeWoMudb5izzn+Nm5DHOY+DuBzWK0OkhRP3gPY9OUmPDWrBV7oie/V35EcIs6IbzezTDwB4o
	kBxMImTgralKet97sJpQ4ksHFewRM176UmvWZinG926RvWnawpnR34XeVfKFLK9fKeaX/3ykqXb
	7aTRoagDKdQt4sO6bS6kXWNZDV3uGuFFytqIEdQhA0Df9zE2yuwMNW4mJYrHYQyZWt1HDqI/aAN
	SMkT0vFC9Wbnni2WI/+eHzl9Uwi6XiFtp+RAKjd8g==
X-Received: by 2002:a05:6a00:28c5:b0:81e:e09d:2687 with SMTP id d2e1a72fcca58-834fdadfccbmr1806349b3a.1.1777525156295;
        Wed, 29 Apr 2026 21:59:16 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed80df96sm3595073b3a.54.2026.04.29.21.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 21:59:16 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: arien.judge@morsemicro.com,
	dan.callaghan@morsemicro.com,
	ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 31/31] wifi: mm81x: add MAINTAINERS entry
Date: Thu, 30 Apr 2026 14:55:57 +1000
Message-ID: <20260430045615.334669-32-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
References: <20260430045615.334669-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(Patches split per file for review, will be a single commit alongside
SDIO ids once review is complete. See cover letter for more
information)

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..980d7658fc75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17988,6 +17988,14 @@ F:	drivers/regulator/mpq7920.c
 F:	drivers/regulator/mpq7920.h
 F:	include/linux/mfd/mp2629.h
 
+MORSE MICRO MM81X WIRELESS DRIVER
+M:	Lachlan Hodges <lachlan.hodges@morsemicro.com>
+M:	Dan Callaghan <dan.callaghan@morsemicro.com>
+R:	Arien Judge <arien.judge@morsemicro.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/morsemicro/mm81x/
+
 MOST(R) TECHNOLOGY DRIVER
 M:	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
 M:	Christian Gromm <christian.gromm@microchip.com>
-- 
2.43.0

