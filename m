Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457F822FDE6
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 08:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784449547; cv=none; b=CWlHNEQDtfMAzJr9BnNB2q9eM5KFejS+CRRlNp7mbtxbSJ1IDEpdksnFRyDIJ6D3gCkgA8w0oPX1hNeJe93w5uXkvGriy3VTVPxRTZYx4pAOZBZQW2GKy8ahjkdMLvNYPLSRWXvodc/WOutHPtTpyyDCoZ4n51d/j+nQFwRtRV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784449547; c=relaxed/simple;
	bh=WOTKlbs/b47viMXwyal7AoPNGA1CSvpWKFBDtupxkkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WF8ya1EjI9H9mDnhdaali8enlcyMzJ8Bk+Rg2w2R3D2V8uaFGlEcMg9GAjM3K3XE5nbBzT4COr0x/5lhft0U9yqaMYgwp3slNinEQnvPXA2qORzkONPqyzw8PMuV+mvJSi3igVEFpWvoxuIgH0upq+TKLeftmQhi0GaQ8iC6I8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPRZ52Ge; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPRZ52Ge"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e347638adso4186781a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 01:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784449545; x=1785054345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rxtd5Q/pDjtbfL0tvsekDL5RGMidpEpCQZcAeYntQgM=;
        b=lPRZ52Geke5blWtEQvYd0rzJIC3h4TS0yA2E9CGDUEK4aPEl0hMBf6soqj7CvhX4yj
         DelIOJKppdDssnu9YntxUn8tkhJxe85BwfqPCSfk/E6vavwq3IZzxVB+TFcqyZttY9/O
         x55g3DlEQRpOZ8iLYmhmHnRFKPsZQJofv8Vl3KTM+u5m0RVBIVyD37+PEsC5VFoWtl7G
         U/UcEsO1ggvQvbMLRXhaVX62pwUwk/UjirXMuE5GrSMgO8gcGN6PU9TfYkyw2mV7PKcY
         5sXIbnUpdQDvZinJnaZDkn4eXuecnUg5Tk5e5Klc9skdqoSj3LMV7JVVUH3J8nxTyuFQ
         /nXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784449545; x=1785054345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rxtd5Q/pDjtbfL0tvsekDL5RGMidpEpCQZcAeYntQgM=;
        b=s/Uqq+FA7GtVx8agcZshqXN0VDbfjiSH63iYeNTC7TbvgLm7srVLic5p9b+GB+XuZk
         X0HlIHcCM+gLoYdETWmL/7gOj9NmWIYwtO6ljLCNcQ9DghepQU/bZNJt6isKg2tcpo/7
         d/bBez9BCI+5IVVe8VPfQLMMB87NuQiQB4BX/7lU5AbptXvuL2gOPVUoCisCW9OswdeL
         wzF869Hg99lOc059En1M/yEyYtrlMMoNmN9YkLDMR7dW/BsB+IsG0DjfmbI0nQv+mqnI
         CZ8V5x+L/BqcsxEpUn5+Rvc3S+t56Z/lZLXx/daZ7VuqWoZNUaaZ/8cdVF0zCyoi4XKn
         2y2w==
X-Forwarded-Encrypted: i=1; AHgh+RrZIbzfNbLCWtw849rq/0vqvmU76uUe5OZruGwXbSs5Moqhzs1L8nitxR90dlcpgBrZEMHPafh1V0cWbc+Arw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz06/8TpBQ8OwjVcTj6HgO1qKyVBk58ii2Jy8UlShaDXQP7il52
	sxZ7ZLXkSQuFY1Ooh/bONtvXwEDZ8Zymy+Y5WAZEQ/lEmdrocC6ldAcV+lAHnO58
X-Gm-Gg: AfdE7cnBW3rLH4tWR/glSJ+qeiZwu4kKHlLkmZ32tcQmXnROpqkV0JmiDs5j3NdV7+J
	a1S6QL9HJd/NpHg2/GZiwgw1gULJU0UWGjsf09v2ZdvxvNlV2zUwB28FcozFXLthXb1Cusyb65C
	SRca6tBK4+LvbFesvujZKK3KlCNUq5WjXMPuZAOXVwH3LTDdTem5MAYsvEzsvkJ3n4KiGFtJCna
	uNPSM02s4rj+uFuBbWoSwY8O9rqHx2NzJ2RXqoaWmKlOcplMtyK4ULC5kYpDINeLwCNKysQYL9B
	GSK74vIMMoByJhpr11ovl1zySmqmjFTidBeTkUhHMW16OI9tR6GUft8InI3lRcsKGsT+LLA3cVt
	RTuABLa6OVaq3bClwHDN1n8Rn/tjutLERVGC6yVWpail8oD8rjfrD2xPmKyZpY5+urmfmOAhzli
	yl3CYkZCgh7A==
X-Received: by 2002:a17:90b:1d10:b0:38e:659b:f366 with SMTP id 98e67ed59e1d1-38e659bf4d8mr2833691a91.0.1784449545591;
        Sun, 19 Jul 2026 01:25:45 -0700 (PDT)
Received: from DESKTOP-TIT0J8O.dm.ae ([49.47.198.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29e340esm19585964c88.5.2026.07.19.01.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 01:25:45 -0700 (PDT)
From: Ahmed Naseef <naseefkm@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Ahmed Naseef <naseefkm@gmail.com>
Subject: [PATCH mt76] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Sun, 19 Jul 2026 12:25:30 +0400
Message-Id: <20260719082530.3879831-1-naseefkm@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some EcoNet based routers ship an on-flash EEPROM whose chip-id is
0x7592 instead of the expected 0x7603. The device probes as PCI
14c3:7603 and the hardware MT_HW_CHIPID register reports 0x7603,
independent of the EEPROM value.

This is seen across multiple EcoNet EN751221 and EN7528 based devices
(for example the Genexis Platinum 4410).

Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index b89db2db6573..05f7aaefaf89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -142,6 +142,7 @@ static int mt7603_check_eeprom(struct mt76_dev *dev)
 	case 0x7628:
 	case 0x7603:
 	case 0x7600:
+	case 0x7592:
 		return 0;
 	default:
 		return -EINVAL;

base-commit: 50a7f9f9d48eb50c0e95bef53358acb5af5cb3c6
-- 
2.34.1

