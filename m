Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A54CA289
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448334; cv=none; b=oTkck4rti0J9wR5tME+PdzOUeEDbbmDqvwnirAoPcNDhUiI5MdQxeXhi7KlBbeBJLBjCrmkCLgi+zHMiPp2z55abWR6nHPA5fW23+pz+kKL+S3DWx0bxadxX83PZF2N5Nm620o1Ki4s8hlq6r4qS6JKar3VJtZahVL4g9IqCQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448334; c=relaxed/simple;
	bh=AypfK/aOKqjDcv6x3JX0uwcWctZz8kqyktBW3Ip54EI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fav9B6IyzhvXYrPm76HedaMz4X3fzzwVlyfaHSZIo6i41uIDpDLTHnJM1LMMYza3VZq9nWhu7e0ujbdZ0pbb/Ns79iV04Y6CWf9ltiRLKKn/LRWjjXgCIrQOtUIUAdihHI8kXo/LGQqz5W7i2EfAQ0zM9VrBCcmrIJxg61G29e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzOUIIHR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzOUIIHR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-482e067e908so2197640f8f.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788448331; x=1789053131; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pjlizrWboIfwnZS2oWukdlINpTQI4dn8vHdtaiT7QzA=;
        b=jzOUIIHR9sRjKRgnKc63T7QLTdWlKVM+F10nvxX+yoxmvPdpyJCVEuA8J3iOXwFxfE
         9qb7TBbXYnuSsfOyy4sCbtKFCWA56T924WUv8xM27urbD4Mse+e+gN9CpFsNRvDLdGO5
         tzs1B3cMvEfs+++r2T+4YOJQXSD6t5eWlgbvJCsyUplV24NyNDuAvbmiljrxk0SbjRpN
         2+rwThmPekNC3NgHcIJwE/DbHO+ZUcUeQgujDFd8WhBIgmFRXSd1FvXoAgyz3JwIT2Kr
         jjzLIGJ0QXCJfhYa6D9t2AmMDNjlT60zonbEQIMLd6Flio1RQdHnY+3PkJ8iom8W2xfr
         Muxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448331; x=1789053131;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pjlizrWboIfwnZS2oWukdlINpTQI4dn8vHdtaiT7QzA=;
        b=lWQuqVc+S/cd5kCsT+117HCvlBM0NtshWIDeP4Fe/BgNfKwf3GFBVcmgv1Jr1QrHT0
         IQx5qyIPFbgJG8NGkLl6kbldlQ2FEWSAbxm3UKIts/kNMzSRPVcuFwXKGRfIY9oP2jG2
         iXV5EVWqYstxokrF9fnq5GEEdoYfT6lDuumM6TUd2uZBShI9OsK19/iCx4ziCzKw6yOj
         L0ZL4VWIAq6qJFm0pMNBo4e6ouRwcGfpbTqFy9AUq68MLm+qs1Y2btL5f/KsYHPZxJBG
         PJnM2rXWQPSxRaZlbW2inswVRuVHvB46deti1g8DLqgkcaUJKXKazdd8GyFb/me095cK
         ZI7Q==
X-Forwarded-Encrypted: i=1; AKwUvByHwmw2YCovJcLbeSZfWI2qkgkakg9MhLZFrTlWEkttniDrgzPgGVwdxRAjM4NkqeZj2DCeAPZYtiKrxspANg==@vger.kernel.org
X-Gm-Message-State: AFuF++l4biOvkNYa49XzpeJRnEMQyqan1mUNA/lHu2GtJ01KEJklgvCD
	SXXs5Z58rQ4jEpu44AGQeHoxOzOV4+iKEhW3GZq7337IGz895SnAmzh5
X-Gm-Gg: AYBFou3fsKwAJwJV97Pshe4Vsv1SW6LILCJRNQMdAiyYSJ4n7BefydJ0CZwmEZgiD8W
	nxZuMshHAFe0euHKlI8nNkeS948Zgx9WEVJ16Ub2vwuf6TW38mZXWHTrStotTjlEP55dHuHo+We
	D+VeaH/1lh1vha7fJI2/wCbbOrIi2Tg5jeYwgshFINF26TFvknXVVnFUWc8dhMtWonx2F4tHp12
	Y5o/Iv0TuSA7YF+OC2zbEMYNoosJwWp3xrFfqCla+ER1QRGQ3bGh/KmvCabFhZImktE4HWRCrDw
	2MYYXn6Mw2aXoUSKw8e0XMALs8XNXV7wg/2niheTtrY+NvIzDYZ8bXZ+wiMsmj+LzluRYG+Z4mP
	Ndyu95jEX/sGGaiWO5kuV8KhA6CEfQpEbOzDQO4wWOmjPC3tBah61jqaDx95CdQ8EY1LN0+iONb
	BFiC7NBLp8kapOXSkKYvRHBf2r8gdj4vA6yEjsCHf3/LJ6dHh0Ii+O4spI6Jc=
X-Received: by 2002:a05:6000:2f8a:b0:482:e64d:a1f7 with SMTP id ffacd0b85a97d-48488e0371cmr21537891f8f.11.1788448331284;
        Thu, 03 Sep 2026 08:12:11 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448e6f604sm14396587f8f.2.2026.09.03.08.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:12:10 -0700 (PDT)
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
	linux-mediatek@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: mt76: Fix spelling mistake "dowload" -> "download"
Date: Thu,  3 Sep 2026 16:10:07 +0100
Message-ID: <20260903151007.14832-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.55.0
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
2.55.0

