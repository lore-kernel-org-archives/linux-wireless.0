Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D71227603C
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2026 03:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771816103; cv=none; b=V/rZw7OUnZ/nW/UzN5vwhxRMh99ykT4GTPp6zcdHlLeMm5hT1RUdTvH44SDfy9N163m/5HCbM0wBMcDHwv6m7KHO2HSdGZvyT/wNETtjeY5jfhelF263BTIQ5M7OkETEmzOBVwLUadpdTQPcS7guytOEK6ycCL7zUGPSyDkwfxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771816103; c=relaxed/simple;
	bh=+R04XDRM3J87nFo8ABDoEFj5H4PIPEXeJf38qX2Lm/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UamUYDuveSB8d2P34wI1eqXaFINVrVXzGkYz3nFOupPza/umSnVurQJtOjlsDfjX8ixu2nlz+s6ogkanjPX0/nWYjQ5wE38KFb7k9E6mpT/OgiwBCUltUWRf0h5uCae+qLFjthWXZmrj5fjjuxv1Gh7qxWbeIH5E6Q7/wEK6Cgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NyyRjfc4; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyyRjfc4"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35640ad94d3so3089457a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2026 19:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771816102; x=1772420902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vb/gp6A5BMv0njE+FDxLMqKZqOn11Vak7JdV5uhwrbk=;
        b=NyyRjfc4fcFf53xlAdnX/WKeEPmRl3h+RFr9UWGRw1XtKcbX5pQhuJaKOdABhqlMfb
         IXIrBgfcsML8x292dkDuvHn9Qs3hXSIIY6HeulpBGwSHvpIbjYtXqBrJVPFiSQRrnFmh
         KjgtAH83sd/Y8DhIUxIxSkZ0QTdM7PHEuEDkCessR84EF/YxH0RlJ1qRWKCKlIgn7+yz
         Tc9PlDE8WJkAHQWEmBN8jHBygdZs8PL5WUEg+3duWx6Sdxwk3cXrBqKSzWtjLgYpcGwR
         reecjeM0ukHqNjd/UOdvMeVMXjUTuVW9qfhhIev0yeH9ClxPMBM0yowygrp57qkDBujn
         roWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771816102; x=1772420902;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vb/gp6A5BMv0njE+FDxLMqKZqOn11Vak7JdV5uhwrbk=;
        b=gFc63vBDIrWUj6RHfm5m6EplxYtiPoaw3lzFdyNNNOjqpAoCukqQ+L2PJpw03BAqsm
         BLLyVulocsMMUc6z/m20yRQMJuiBkQz9qYSsH1bD07S+omtHn/cGrQGR+xuqOefXNizP
         9qmd+L/qK4CNxQA75yZE41Wiqqz+xMy4tTOA3FDk2QeW+RP9j1mTNp2/qFXBIpno0Woj
         AvN9ZVy3VE3Bm0yrzWqXBacnEDXJL/g5MQHSPTjIrlSGWqumu5x/DsibRmcJo0x48bSM
         j1sd/sGKzvzjxJS/qHw7naPeHtWcUcaupL/48grdLvG+LO8bDNP5RxEhXj0tTHnI7SRJ
         2/gw==
X-Gm-Message-State: AOJu0Yxl9NO9u3Sbv9U0ZFef/YsmEvSFghZ5WOiTcj/gtvpxuckxgszC
	lnY0EQ4f3IIEp0+ddwID9B64Xtr8v6Rar+AXF4vaJ6+Y5JAx9eVMNuNzVP885T5F
X-Gm-Gg: ATEYQzxAqUTA9S+4Lk2d3nscj2Lipa/u58tmj6pzwRRmroO02w+acvwQuaRPHrsEe2D
	QC+KJQma/f5tjzhXh3SZ6HZG7cE4NiRbLFdRco1sYOUwZYO1h3pJPrHJ7kuLzhWhBZFfnLdPWjO
	1c2gw1fxk7KY4Bjx1cUibStWE/eykwz0dWig+zdRqRRUtybdUD6otLnQ6pI2QHZ/SvVAzq1JCoL
	1yL6QVy5fhzOKEUb80uQ57x+EoMjHz0qUf4vG93HYozWtXMl5EtO20N+vkV7eJ13ZLKMsp1UKby
	6JVcOtPVqW3eQ3KEojwnUJoRtoIMhPrrMx1QqeJgem8CrAmSxWoDtgTAwlCXvNxNyOjn0vMvKvk
	2kP1CgObIbwMR02tWXQK9KB74gpzoFZClVBRBWB8cUEN+YiJkk9NZJuLU5yaUVC+X7ZOtyCCWxF
	gWBga1CPoYoVIevkrfs3zfFix9e1ANK/jh6Pb3dFVsxzBqtQMsr4GqfA/cm10b7Nck
X-Received: by 2002:a17:90b:390f:b0:354:a284:3ff9 with SMTP id 98e67ed59e1d1-358ae8cfd90mr5507700a91.26.1771816101544;
        Sun, 22 Feb 2026 19:08:21 -0800 (PST)
Received: from ryzen ([2601:644:8000:56f5::8bd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358a19b242csm4177601a91.0.2026.02.22.19.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 19:08:20 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath5k: ahb: use devm for ioremap
Date: Sun, 22 Feb 2026 19:08:03 -0800
Message-ID: <20260223030803.19451-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplifies the code by quite a bit in probe.

Also allows removing a goto and returning directly.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c | 33 ++++++----------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index cb3e891ee1bd..f34313568d9c 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -87,7 +87,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
 	struct ath5k_hw *ah;
 	struct ieee80211_hw *hw;
-	struct resource *res;
 	void __iomem *mem;
 	int irq;
 	int ret = 0;
@@ -95,35 +94,21 @@ static int ath_ahb_probe(struct platform_device *pdev)

 	if (!dev_get_platdata(&pdev->dev)) {
 		dev_err(&pdev->dev, "no platform data specified\n");
-		ret = -EINVAL;
-		goto err_out;
+		return -EINVAL;
 	}

-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no memory resource found\n");
-		ret = -ENXIO;
-		goto err_out;
-	}
-
-	mem = ioremap(res->start, resource_size(res));
-	if (mem == NULL) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_out;
-	}
+	mem = devm_platform_ioremap_resources(pdev, 0);
+	if (IS_ERR(mem))
+		return dev_err_probe(&pdev->dev, PTR_ERR(mem), "ioremap failed\n");

 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		ret = irq;
-		goto err_iounmap;
-	}
+	if (irq < 0)
+		return irq;

 	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-		ret = -ENOMEM;
-		goto err_iounmap;
+		return -ENOMEM;
 	}

 	ah = hw->priv;
@@ -179,9 +164,6 @@ static int ath_ahb_probe(struct platform_device *pdev)

  err_free_hw:
 	ieee80211_free_hw(hw);
- err_iounmap:
-        iounmap(mem);
- err_out:
 	return ret;
 }

@@ -213,7 +195,6 @@ static void ath_ahb_remove(struct platform_device *pdev)
 	}

 	ath5k_deinit_ah(ah);
-	iounmap(ah->iobase);
 	ieee80211_free_hw(hw);
 }

--
2.53.0

