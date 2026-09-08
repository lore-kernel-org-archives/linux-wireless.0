Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC254EE878
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860346; cv=none; b=GbHiavM8IzPVdiPhQ9tWOMuHT40WyN85K7uAkKAcuMRfe6XZ+TYQbSHUTmX5eb/f9FD0NcNZ322mrT4cIDD/Xg6sGB20Okdf1IoOm7rraOt9Xu1P+KadtZt6RfLtw7brjU7oG4lAQxnNaM+4+mJo3SoihDLrwfD7kwo8se1egXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860346; c=relaxed/simple;
	bh=znCoxd6YU0vaytcLOKCB6Mo6LM/P8R4MM75M2jk8Ivs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kaANL7EwCY16uOjDzFKWC8q01n689xYGaM9FWCHlAAUkpj99wafpXNJOhbvahloWy5dRedBvxQy7lL0vnIA3x30bC12H5XqQp197RMNyeGxwtS/aq7kUimDuiYems1uq05fwJupM5g9wHjejez7Xej+0wV0Ehwb9MgyX5KDbs7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BIn2LAOX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIn2LAOX"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2db3305f94fso31562195ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 02:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788860344; x=1789465144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=veiyGrZ979vQEs7rWnsg+eWwwTfAHUYngaFq2JYfcfY=;
        b=BIn2LAOXolZATB7eddG2gr2Wd1a5J60cdJtuSGFOWF6fItW7VoILhHMQQi8/rKbw4F
         5pLVHp6L+p1eTX1QLlPKR9Q776mkqThDUOWqHd2IBkfMcTMl8hz6pjZl+3+StPOiJijD
         /7HdkfxnEqKkmjlk9zXSR/3Z3aTkDjEXhQOVUqpQ/QhajGwjepV3q+QFWmCmaq/JWKmg
         uHm6VVZSVjSGGYWS3xSWePNOHMRx7DPZJq/C6Bpj7PKhZZmy848jyn3eX/0ldVx/RPaa
         TOH5VipxPSLUDmEJw09OY6bvzpCJjYc/SJ/1z5jWIGLnj96RUMc8OEUecYqkxejTVWnA
         WklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788860344; x=1789465144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=veiyGrZ979vQEs7rWnsg+eWwwTfAHUYngaFq2JYfcfY=;
        b=QbR1l2gaa/bHANOrkN6Bt+mpXzRAZe3T7CYcFWrBTEo29/5amVgjbyvRAbSXowTVZd
         zB8p84r4NXWTOZxzZkfiDn4xuzdyXtNdxuIlaof6T7qc0EnsbNbtLisp0StGq7FLoGiz
         zldd7wNWjFi9+OXusV1EXcpeDGR6TvQldxEDoKyTS4iuRJax3e4xArPxBv/Whc0He+JM
         eJnNHgem9VQ1p3bg80L999IZxsGL74w3b95jUrUufu1dKRdCDHyn/9Ia/74npVQ3/EPI
         YFBsJgSttler8fdymlqQL3uu6aghKG+VyEiixF+gh1YFqCponIBD7ulluOJRoYOAoPAa
         AnfQ==
X-Gm-Message-State: AFuF++m/petOH0aj3wfeJf/pE3kRRc8/hTnc+qRcqd+dzk1sjZD38tzv
	bCuInfiWGGwWplimQYLo9o8BA2Xgewqj5xSMEL87mSGMLTZyXaF9nzAOTD534pbhDFw=
X-Gm-Gg: AYBFou2M8TV1ZMfkc0UWiIptq5fsHB+AI/X7sHKjJ+0c6Ly9Sms9MkefBR/tb80RLMu
	dqtW+r/8HGbZ8Xwjb1SXVSbnD0NIUBrjltYTTrl94Ny08N0e62UupD5utbECEwLyg3cnhWR9I+A
	t7HBLjn9GluHNzvvLc5lGFdg0jG8namBA1XPDS2P4qGdQ3TAyDjlKrMhzpnkdxXlTMEQWzHFUz3
	Iy7EbXlWKiYJzQ9zfvYi5eT/zV4+g18yJcPoDyKTEW38IZV1I2n0MUA2Unt8j0/uKSZe6rl6mfN
	lPQqg84kKqwcR6qDNIR50pSWDy1x90FQFy29zOODRHzUmF/mIUWaUP6JHrrecUE+8KaZcQQlyjD
	E4m3QW/0BlGKE1HAkyPk22wdD9V2hbJE+EiMexsP2rToORI264Bz2bHje/sA/MmLH/zO6BZ25yA
	+eZ9/ii0wHHrvYG05NWJ9q8KUF+xWIVKWiozdjj8uOWBN0YjNXxwp69Zl6fB3Fpv72+NrHUY3iM
	r8wEQOM3UMqwDxe8Lri45hF573ODm4wlIBSyeEK60WUv5NWggW0DVqk0v7G9+bnsEoQuVK0c83U
	xQ==
X-Received: by 2002:a17:903:3910:b0:2d9:383a:30f1 with SMTP id d9443c01a7336-2db6c699f35mr115521875ad.4.1788860343901;
        Tue, 08 Sep 2026 02:39:03 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d9f9sm54848085ad.32.2026.09.08.02.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:39:03 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	linux-mmc@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH wireless-next 2/4] mmc: core: add NXP IW610 base ID and block size quirk
Date: Tue,  8 Sep 2026 17:37:56 +0800
Message-Id: <20260908093758.596444-3-chunfan.chen@gmail.com>
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

The NXP IW610 SDIO chipset identifies itself with a base card ID
(0x0214) during the initial MMC bus scan, whereas the WLAN function
reports a different ID (0x0215).

Like the IW61x, the IW610 requires MMC_QUIRK_BLKSZ_FOR_BYTE_MODE for
correct byte-mode block size handling. Since SDIO fixups are applied
before function devices are enumerated, the quirk must be associated
with the base card ID rather than the WLAN function ID.

Add the SDIO_DEVICE_ID_NXP_IW610_BASE definition and apply the required
fixup in the SDIO quirk table.

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/mmc/core/quirks.h    | 3 +++
 include/linux/mmc/sdio_ids.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
index ae3ece89d0aa..98cb680e3ace 100644
--- a/drivers/mmc/core/quirks.h
+++ b/drivers/mmc/core/quirks.h
@@ -211,6 +211,9 @@ static const struct mmc_fixup __maybe_unused sdio_fixup_methods[] = {
 	SDIO_FIXUP(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW61X_BASE,
 		   add_quirk, MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
 
+	SDIO_FIXUP(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW610_BASE,
+		   add_quirk, MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
+
 	END_FIXUP
 };
 
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 5eff5e348eb0..dfffda3d8002 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -123,6 +123,7 @@
 #define SDIO_VENDOR_ID_NXP			0x0471
 #define SDIO_DEVICE_ID_NXP_IW61X_BASE		0x0204
 #define SDIO_DEVICE_ID_NXP_IW61X		0x0205
+#define SDIO_DEVICE_ID_NXP_IW610_BASE		0x0214
 #define SDIO_DEVICE_ID_NXP_IW610		0x0215
 
 #define SDIO_VENDOR_ID_REALTEK			0x024c
-- 
2.34.1

