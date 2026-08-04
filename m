Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC4C4399F9
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 09:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837522; cv=none; b=Wt9Z0+kA4/wUXhIEyx89rlvlR80Ergsa8aCyxJxLv8vRe4rJ8I2fJg417WPovhCTsUimq9alAa5IIqe/XgKOq7g0vSzs/Ye0VY6tH6h6mrk90ygCoqtW2CgWr65Js0idDBgwqt5/vzQrVU6qJXuUwUFq+AnJ6Pll8RA56zNr1yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837522; c=relaxed/simple;
	bh=xIfllDv5AXGp1J2F+PRj8VNMR8wYNazZCRMnO7uPsdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SY1Y+G4kkl+9wKkHeQy5mdq47+YFEBSqVEj0wK1T+dj2rmAhlfOcJoaOmLoWtexvyvkvKdMzHGEDcmSJ9x8VIHS0Aw6IyNG50UwY8ze0BDCk+3KzjGPqx8lehxEuJugTMWxCU/dA9DkTwW7Ioz6DjVl9X2PYKnZTpuxAMCqiMqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4Aqg5DK; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4Aqg5DK"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f703a9d05so2634529f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 02:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785837519; x=1786442319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U8iBjzi5EB2WI8WP3SfXRiDKDZBVj5v7DS4s8b6g/jk=;
        b=R4Aqg5DK+Z+sPO/CV2IixvFbn9i3d+OVqOl5K3ExRB/Y3tuR/Iib1Kl/1rU9BOERGZ
         7s15jPHLD1beUhYrHl3khcyRAXYZrQEYNsVpjfh9EmuGDXwl0sVAS4VrGsVz4Qor5MgH
         plpr0HAFg9WdILVjibF9RXsDCjLm0KdpAasp/EUQ2lhQKitP8dqASNA89pVOfGWC91wH
         FacwFuHHECGu0QXRf5FTgeB42/JD1UMrfINzu0RZ9FMtCeKjbPUbTrhID6AvZ3NwYiX5
         1fKRQvNQqAaP3007D4uNdRYb9uIGUEFYwgjdhanoiW31QSGj19OTJJvgdImKP6+B9932
         dYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785837519; x=1786442319;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U8iBjzi5EB2WI8WP3SfXRiDKDZBVj5v7DS4s8b6g/jk=;
        b=TdngUcJPGfJrodWaSqGypJy1NBUqf04gJsGhGXnuX9jkuIcCuEO60QAADdp6t4F00X
         RxoQauLbItWaN3OQ8t1/JvfcZY/ExG3OycmABAsyOhsQoZoHuSdTFtI0PIffoR7mgXuH
         1eC7zFZCnDcbllaNknvFhr9OpXDVKGc+MwbkBZgqh+8Lmlw6+6krdkO28gzGOwngWAhV
         POJd1ffE6x0WZUt+lA+8R4jiYOjPcs+F8I5NK65MWAgfD0Y+H+hOQv31xfikZ/Zioi17
         h5pQnDVvAsak6QywD4OA6L+q9Ib4KXn5BTMuq5E6KAW4UIcfJuTZPekxp4MsinyGH+FL
         gykw==
X-Forwarded-Encrypted: i=1; AHgh+Rql/2ib15+ttvqqr+guhk5KDuhWJM5J+U6TJX8XJlPu8hc7tSET02ChWKMGZy6EGMU8wW4JpxzQ0QyCAL4rIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxuqW3mcpw0OV+HiYeB0cDNHJ1DKal5XkL8OBrp2S9DuaO44Il
	xpz6aC5W7MX0BonbkN2vKUhe/XzI9raYkn8ahigVOyiaDpXdaqpIroa2
X-Gm-Gg: AR+sD13RCvjUgkbmkRZeWqTa2dsOcRoOproaRfzhCPaByMRvz0ieqHb072Y1N5xaTZk
	69laXEyqG1M5TGCMAlG4MgW3dqYyF36KFYTDRTUp3QFq3/xtauJQD96qlW5+WcRmd7RjeYyaEXM
	6IRkKGK4JdiSiudd9f/0oZpf9nssxgsIoI29fOTFvr5rIFiMRhz+CMNl+nxvS7MPmlqTbxzW2aN
	4Znyb/fnPCZfD7TryMq1C8squd2zjNPhGaFJVD1DH3s9Lk5Ban7Gx7KSacCASbFkYAgdlISIaYW
	FO4pXSDzHosrz/KXZA5/TgaWo4ESYG/HLHs62aJZCEw6dFF2oupJnEhJt16Q29szveHqBEUc7oC
	0sdL6ACKHjCAOvtWG7Lw13Sn+6B1k2B42OmJyyvIRJ8dTWIw8Pdoy0wWXC0Rs0czM0S9QeqiA3Z
	888Pru/gYxqCPfZMJpEle4vuuS/krnYWnrfKdu2EhhbXuP5XTL9O6lInMHVIo=
X-Received: by 2002:a05:600c:524a:b0:493:bd2a:93be with SMTP id 5b1f17b1804b1-4980eb5cb45mr288946725e9.6.1785837519077;
        Tue, 04 Aug 2026 02:58:39 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807eb12c5sm186540075e9.3.2026.08.04.02.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 02:58:38 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	hlinux-mediatek@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: mt76: Fix spelling mistake "dowload" -> "download"
Date: Tue,  4 Aug 2026 10:56:48 +0100
Message-ID: <20260804095648.783881-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2f925d22b9aa..9552fadbc17b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -3130,7 +3130,7 @@ mt76_connac_mcu_send_phy_ram_firmware(struct mt76_dev *dev,
 		err = mt76_connac_mcu_init_download(dev, addr, len, mode);
 		if (err) {
 			dev_err(dev->dev,
-				"The request to dowload PHY firmware failed.\n");
+				"The request to download PHY firmware failed.\n");
 			return err;
 		}
 
-- 
2.53.0

