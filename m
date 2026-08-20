Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFD93C197A
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 10:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787221066; cv=none; b=Emc0kIl9RMfcVcgLx8zXoktQihmajROM9ruFeZJ2uTvGw2sQe9joreX/im2EPOQYCKLr7kW8/g6UKR5NP+QzUnTTVazFvKbRkcNoJAe1FvifV50pe+95LQqJ0WQ4XhI/U5dCqssrhpLFO+iRM3TKVeyU4hX86Cz1hmaq15hJQeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787221066; c=relaxed/simple;
	bh=FzKiSyVXWsBYqTPwsS6JTxJpaPkuu+hLQ2L07LSBJy0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YG5nioRPgCK2DNs5SRBZYx097Zpq9zaYsyCByFRS0f77eUCC3pa03pEEVfCDeCeteyteT/+fy4hXhOLbK0sRolJTopP7UQijHyeeeCQywwGxT3eaijuhyw4lMgIp4IKRuxCFp/OKWr8q/obmschEY0r+AORhQ3/SKlHEE1OxCCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yd13Dwvr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yd13Dwvr"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f71156e1aso949020f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 03:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787221041; x=1787825841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t9pi9PH8xYnrO4Jgi0ob9qz/6sng3fddk7IxPmgzfb0=;
        b=Yd13Dwvrup0NyktHUjRz2kVR6MA5IBWdehrTFb2n6KkEt3V5Gvdj/FPh5LQfFXgmmW
         tqhN5AQUY4mdeftpYqlVR9UFjMHVkPg4Rdh/dTxE+xhIADB6Shw3fpBTqP3aYTkr1FWs
         Ocebf3/pFOCwtpkuJsolfO8AxhNg5SoXbKki0yL9U2yHz4jjQCpON7DKfbHNRzJl/LCP
         OdZfJ/rc5AF6O4MSAb6nEyUTMvLCWnq/UYDXHsss8X70D7L6h3Dd2SmumgxtF6oUe3zt
         iPaodMtF16LJjM3LHpWJWJbVa9z83M6rRyXzEAs/TFmOwXeA4aUyEPvi6y6j9Icxspwb
         7Dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787221041; x=1787825841;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t9pi9PH8xYnrO4Jgi0ob9qz/6sng3fddk7IxPmgzfb0=;
        b=cViVz2vW4qdcL2dS2e36zosdK9JCu6uBAwCDT8ffiPysaEG48PNvjuXHH7bF52jyIT
         dh6E3iAbn4c81uJKkiY8IoSq77U1IzsHdh1lI2ZMXzJ+8yLDyjLE4eiq0FVqR5oS7UPh
         YvXQDVB37wWdbnuzRBaM5roqWAiLkhqMmdjHU5JavP2zX6J2ad64vaeQtuTSY7khH3gg
         lAJ23GJFG84mNz5MsXT//eMw2mQBI5J+N/7ywiA4387vEB4dle4/3pewYNth+q4qCjQx
         WA4wRp6Fv1pJGgbn5ZFqW7KzcFOO+DtTsPo4N/WIEy+SNQDUOmPJud3Bo2Xi4194Rzhr
         B6sg==
X-Gm-Message-State: AFuF++mA9HvfCP7kmU+D5tsfflcHkvxCyebzS+/Cz+yqNO/7uhK5Fbtj
	qXOUgB/5UXOcuNndeAHrBl9GMmjaYAb3kzBacsZecEPDQ18ttI60mhBq
X-Gm-Gg: AR+sD12D1o7at+3v1FZUyZirbdCjB55o9BUDAAI63Ka7g1nV9zC+dUzJTykCkg4nIG2
	Wc5ht2denBg6HdIvWvL4dSlnYuBN1/czsnoq9RPmWFebybWN7i3KWzTH1J5LnL/NkIhq5vab7RZ
	7cxlbsVVtH/GVa4lU0d+Nsoty3zfS5HCXH9i/9jZjykRniB5wtGKCA78ZJLj+txDeFpJJwl4Rku
	z78FHIqgxzjYayGzm2AYRNkUCKQGFzE8awQetO3v9EEzLPHSPYfksGuTeEN5eGyySbJrPp9vYQ3
	6vBnd3b2YCeYKW2sXsj+LvnwMmij5/T1LhCth5BoMqpUcpSGBFTWiznSVOJneYudTYAY+RiNZxM
	n6t22S9WusRINzYrRZ6jAiwbOlTYEUycfjHn5H3GGuu2KOlJtVr3DcRaLW9+J9BEzV4dnSOoVMW
	Sqx3Ci5XhKfT3KWVa2Avcl4N2HtGeR50CuFX19UlgVQt1mPZ0eNNetq4EA7oj+HMm6OAcpry+Z
X-Received: by 2002:a05:6000:4b10:b0:481:5657:5299 with SMTP id ffacd0b85a97d-482b1e1bfcamr21026944f8f.0.1787221040442;
        Thu, 20 Aug 2026 03:17:20 -0700 (PDT)
Received: from NBLK-WAX9X.local ([81.214.178.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1441c85sm13622883f8f.1.2026.08.20.03.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 03:17:19 -0700 (PDT)
From: =?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>
Subject: [PATCH] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
Date: Thu, 20 Aug 2026 13:16:42 +0300
Message-ID: <20260820101642.35003-1-atailhan2006@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Lenovo IdeaPad S340-14IWL (DMI product name "81N4") experiences
severe connectivity issues with the rtw88 PCIe wireless card when
ASPM is enabled. Reported symptoms include frequent disconnections,
kernel panics, and the driver failing to load.

The issue can be worked around by either adding pci=noaspm to the
kernel command line or by reloading the driver via modprobe. Add a
DMI quirk to disable ASPM automatically for this device.

Signed-off-by: Ata İlhan Köktürk <atailhan2006@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a30467228..9df8954d8 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1779,6 +1779,15 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "Lenovo IdeaPad S340-14IWL",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "81N4"),
+		},
+		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM)),
+	},
 	{}
 };
 
-- 
2.55.0

