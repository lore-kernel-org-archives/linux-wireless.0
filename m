Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D2C4CC28D
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 09:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860339; cv=none; b=ESwDG6FxJLH5hOK/MSkMMvBMilu/hkA9/WNnxniBdte0j/xfbhKpE+mUKVj3lwTNJ6g3xuLWyJSTCDkvBCscKN63gsJfHdoZ3n+8PQrSLdkRCTXacDKEZcYpv1z8iQ+DfaUSaSn8d1DPlsKxLCUkXgMD9/wqukxUgTd2EkNiHQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860339; c=relaxed/simple;
	bh=j0S4KRpjuwt3nsK0sce2EQ3T5QreZX+v22OUsOnmgx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHwwb4aZdJFemrYMtiO4JVwMocXAmWGH4Gm+uMkT8DAYbA1itq3o48H9LvfYuqvnCJ9JnuQPSdcVo7AJPIgP+kPjZ9ay2a7PMmlT1App11V+fdGQQUcz+swYuai1BF0rXPR5oqnuRMgugaSBUL/HkZEXrsbiJ/o+N2PwbjhcfI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/O8Ut3s; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/O8Ut3s"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d944747d41so46356065ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 02:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860337; x=1789465137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r8Uf1/He7wGtBx838McXz59D2uWjpQpPbZa4QJXiQso=;
        b=c/O8Ut3stdG2XtedLzqH4R7IQopB3Oketos65r7MPd60bHSTo8SPxVVVUzJOz6V1qf
         WotQy8Hn7F2r/DXjrI7v21MN4DF25pVk5G+ds2OqYlQXqH4RIL2xeZnvrHgl41JDZwig
         s5i9t2J+s9sA1IHJ7SbKC41BD1QgQ3Ca9Xoj/ki7m8chBYOLlFrDwSeOXb58wwV3hwHX
         J0wSNYA0rP4zu+EkLq6wT14XjiMMjfv652gjKg5WXbdRj2EA3Rx/GjBLuMDJK25TBOgG
         dcGrB1hqEX0F1H4pqarArRSwWzMTmKlCpZlaic+htCm0RawR8iL7HjI0hAOumRHFs6Gm
         JYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860337; x=1789465137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r8Uf1/He7wGtBx838McXz59D2uWjpQpPbZa4QJXiQso=;
        b=L8R94BJNuBrkzvv8J4w2Hx4f0X86Bqil2zQk3QWiSYKgQ4HNwv/Hsd+h1G69mDqPdw
         kTlWIE21XuA7uIZtDe76th0YxqqiHiDQg1/LLxqs7hNH48raJYiIYvI0O7LswvrYCaRm
         Dy8nK3TeWJjt7pxt2NypL8fzoNxsSOL8E0CF/hWjBx30tfVB9exnIGTNI6QDutv3YlgX
         MH1ODWT6OYS+RlKdrFvUU0NfBeWtlXVSkRaL1UMl0n29Pn8z+dqUybx3C8LW4kOzbVJd
         LsiHok81X93kWBnz9ZdSWoiXxJoO3IpO7ky3HJICRjyXlmPJBNvZF5j1fVAwQ4d6Q5ah
         EkNw==
X-Gm-Message-State: AFuF++kDAB0h7xlfhix0GQW8ahY2WIxa4QxZNNqqHV/YfzDxvHbPHCqj
	VNHFeLBLp7AMIAbOMWGRzXh+DE0aGkVefkCyZ/W7zc8xVowe2ed0w6tVSb1PKKt5CzY=
X-Gm-Gg: AYBFou2kUpP4hLL0m6bD8i09nfgwr8lj81xPBEI0lm+96V+Wqw+eJENpCTua5Cdij0E
	DzYwJ/m1So3BgWWUzO6VXXxQAuzidx4g+heU20Rsn+iehLCJtxOvQwE/LiAqY7ACQ491qj3TR9O
	LkkOKoHpj+hiq3XEO098OJ8gqQys8lkJww6ddRmewOJx5M0GjJ9E5ZSsdqtm9ddNHHUojycB6f1
	ynOAxoABmLy19uPLs1oaZ0lqCwqT1c5EK3x6i5i1VaHZMXZFhvOGI5QbKWygOAl/RKu8/y1znKO
	DygaQspqR0ooiU3yxWCuGRAYtnHuLsPRvzCYcuNC20PzwNchA0r04uSKP47QYh6f+YVKPoiVxxP
	8eHK+kr0AaVyVSLZG4PoQr2LozD4lGQy7heWby5A0EL7TPLMtbje/PHEPadI9I44G6IswxUhH2b
	y1jlaVex0u0wlr2eXAoTqL2Tutbn9rpjiO+oNLUs3z1nP8QoaG0ATg2uRNJlYgX3B8N3NKHnPyp
	MkTihSUWIEDcdfNwgKYHeHWrtdm/vPnPngiI5cuI2OGG2ziBsrr/GRZEGynBJMERMfjZRSZKO/Z
	Hw==
X-Received: by 2002:a17:902:f690:b0:2d8:d4ce:7e3d with SMTP id d9443c01a7336-2db126326f4mr367331345ad.18.1788860336815;
        Tue, 08 Sep 2026 02:38:56 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9f9sm54848085ad.32.2026.09.08.02.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:38:56 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-mmc@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next 1/4] mmc: sdio: add NXP IW610 device ID
Date: Tue,  8 Sep 2026 17:37:55 +0800
Message-Id: <20260908093758.596444-2-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093758.596444-1-chunfan.chen@gmail.com>
References: <20260908093758.596444-1-chunfan.chen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

Add SDIO device ID (0x0215) for NXP IW610 to sdio_ids.h. It is used
by the nxpwifi driver to probe the IW610 chip over SDIO.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 include/linux/mmc/sdio_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index afae93f6f245..5eff5e348eb0 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -123,6 +123,7 @@
 #define SDIO_VENDOR_ID_NXP			0x0471
 #define SDIO_DEVICE_ID_NXP_IW61X_BASE		0x0204
 #define SDIO_DEVICE_ID_NXP_IW61X		0x0205
+#define SDIO_DEVICE_ID_NXP_IW610		0x0215
 
 #define SDIO_VENDOR_ID_REALTEK			0x024c
 #define SDIO_DEVICE_ID_REALTEK_RTW8723BS	0xb723
-- 
2.34.1

