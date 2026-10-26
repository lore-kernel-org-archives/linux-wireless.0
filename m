Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041847;
	b=uIHNW5CwkGqAmAN9R3spRbjeiLnDNQ8tH7YthkmEhZ32Ob0f1wCLoKlimQHzzdAm0mrT
	 7TaUspWO27FwAhH9dnw2ekOu4AJdMQWWfIneWpaoT9tv35kmBBK8VYxphKhHY3eG+NL8d
	 kpiscDbFwmm8sN9iUn28RJ/gXM2YnJXDZ+vaVI1qjXkbWnqUXTRXdQdqiZ8tmkzH+SiLJ
	 3mCW9QI08zhaMLn+LyZnDks3i6xSnFlkveDMndAWlx4ItjO+7n5T7k5+5Zlxc+iMbklVU
	 4GWSuH863rgS6B3Wg5mWLzaxN5dOAx00GyXRSYnwnx5lPIbktkynncuMR5oYx26IGTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=DMuTtuJ1h4xjmqX6Q6LPbxG38lJtzTTle+6VtZKNkrY=;
	b=BeRrR2QTGbR7bE2PNgUz1dyoHcnAuylevBTOSXYGCR45HtlAvu20hIHxM44jl6R3XCDT
	 co409D/+8jyQtouFR2uQfNTY65GkFoXNdjvmCaSEAAiOolb43pDHtygScyR89qtQbAOfc
	 1iU7rPm0BdQkzx5mH/hxNooBkhB4WWVKdA0QD6XAgf+PzVOHgCpWoqBfT2Butlk8xhWTu
	 G93L1los/V/DDJlCX0yb1qRxaelueUJbMDwMHXT8P9SybfAfhZx0B46KU3S08lCgCM6P3
	 ITqi8AY5E/D0vrfJRAs3kpd07EcWdefr95FMdmlaR4n8g/xQZ9luHw1Wq2UmX2OQzXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TN4ytapC;
	arc=none smtp.remote-ip=74.125.231.133
Received: from mail-oo2-f5.google.com (mail-oo2-f5.google.com [74.125.231.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3C606A321
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0B3C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TN4ytapC
Received: by mail-oo2-f5.google.com with SMTP id 46e09a7af769-8458555b6a8so949822a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793041846; x=1793646646; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DMuTtuJ1h4xjmqX6Q6LPbxG38lJtzTTle+6VtZKNkrY=;
        b=TN4ytapCI4BrQ3ZcXC8tKkhy7BXjIBziqzswKTCOUIfrvA35hhHia2p3KheIpZjwrf
         SxOT0QbjpA2ZKqVlh393VYXOpgIeM7vTyDbBktRHrX4ygwbU9MxAyF76VFS5z/BPpeJg
         I2Up2uSxn1h0EcNtFjGbUkz1+vtRSMGtbAgmhBxtrc+scShGOOgLtdk2AR2lCGdOaDLT
         Tx4DyOwqqsWFAlLIXplEPEaU/zr0q0Q1gTQWs4Vykn52/h7uEHW9WQUU7OsgjXgFNyrH
         3/LJaxmKsOi02epciAyHVg4kiJ5sq/VS9485eIVngpjmlxC876tjA4LPVyvrQyKhcvmc
         khPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041846; x=1793646646;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DMuTtuJ1h4xjmqX6Q6LPbxG38lJtzTTle+6VtZKNkrY=;
        b=nmEx3+dRbZCDEJW9JEBgDOxGgIC2mUWiO/dxxjXMNkTY96S93yoBJGct+irA0gBbBJ
         3v3FcejgHRcDs7ncxU+agNcEP2gHk1fOh0E6Nsg6MCTXviwaGzpTS+J93ZX6+leX8k+e
         hxbbB9eQYxQ1c47TY5M7C5voTcH6K7nEW7h78/0apfytITKwxA/K3H5T5CJ48F7HGvxD
         3oK/CrBpPNIqy50WClHisF+GoatGyBBFifeS/0K3sgw3PXunDkVFnhlpzLYSdRFC1btk
         RL4HG3u651mbj5bWSj7+/pAsAxdcR3I4Dw8y4H+jGcuCJzvqiRf6bfOlfR4Cr3XIqsy6
         ZmXA==
X-Gm-Message-State: AFq9FYKkXlWpSoHq9kPsFnQqtXkRhLCwBJbRAbog2/ey3Vk4wHuzB6ch
	QLrq+N55H7Bbi2tbfKYrB999eEHHUy3DH6e2BoajtarJ8qgQc24DQTop
X-Gm-Gg: AYBFou2s5nZYi8ZCb6sMGsPPRDZDCzNqTjsYftCEyAvSsSzmFB+zRc1rQR489587n4x
	Qu7MZjkBgoSI8oKMYpVGS6ZAdr//jHMnDEeoXXi0gGe/8efCku7owvZv+dslr5sfKBTC4mRhvVQ
	qYTKm2/w8ZPCoe3oRJMflDNXTkoFjeshZL9SKKouZzXdkDNjVYPdgGjLI+uo8pI2ZVwU5jnG3D1
	l5SiLl3Hx5suKxBWZUAaBCf0wDPHjEytRSD4qpCzHFHey4U7cDI9VaVVHM+tVxoWUzMeOL0wDS0
	IQmvuBXNVqmg1V0wJP3pwChlddp6AA3ggIG9TU/jFos4VGp90C0AAxvOCFx/zU7Xx5au5EEO+QD
	41SbXOFVPkZ63i+VEPdwlyA+k3jlCjepbUwElYdQeLT1ddRTKLp7rqrKykU2WC0Ig/L+k/4aHaG
	nNc8HybFB2CnwkjBgSFCCOyi+gA5QzH0MBWCo3itwzKWvkTPO/reKlihfJewDOGxT3gTbdFYmuD
	ULxzzLHwnHEqAm481QHqEm+3tBSy0GLH6ufVSSv+MWLW6sejzR//kayNM61a+Qez4PfSzZgi2tD
	IHNyh/6uReiQ8x3V+kJ5aUliSl8eJZe/GTkrk1X2ffqJxJ5r2ijWF8lg10Pg8+cFjjs=
X-Received: by 2002:a05:6808:1919:b0:4d6:90d4:6bc with SMTP id 5614622812f47-55c002d9eb8mr6575517b6e.46.1793041845770;
        Mon, 26 Oct 2026 12:10:45 -0700 (PDT)
Received: from [10.10.18.223] (wsip-64-207-253-118.tu.ok.cox.net. [64.207.253.118])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c03dc3524sm5740834b6e.0.2026.10.26.12.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:10:45 -0700 (PDT)
From: Ryan Brue <ryanbrue.dev@gmail.com>
Date: Mon, 26 Oct 2026 14:10:37 -0500
Subject: [PATCH 2/4] wifi: mt76: mt7615: wait while Bluetooth downloads the
 MT7663 patch
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-2-944b1f7e63a8@gmail.com>
References: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
In-Reply-To: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Ryan Brue <ryanbrue.dev@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793041838; l=2027;
 i=ryanbrue.dev@gmail.com; s=20260906; h=from:subject:message-id;
 bh=HkEhUCJzkwct3RuygSMeROndtW02Wv2ZhGyJ5rVshHo=;
 b=Xp3Ukesylfb4khPHpZ11/Jn435KT1nrvFR8ZhqyM/mUHsf6//IDNqy25niqgUN/TogKP5/5MO
 H4QgjZPCBcVCwSr69a0/W6h771CNP1sQjSp1Qa2GvYgSEJiwTO2+/Pa
X-Developer-Key: i=ryanbrue.dev@gmail.com; a=ed25519;
 pk=KsUvVaP//v/2q+ZBuacc7cLbsyEYn+AD71Sn28oZWKo=

On MT7663 the Bluetooth SDIO function (btmtksdio) shares the ROM patch
with Wi-Fi, guarded by a semaphore in the firmware. When Bluetooth wins
the race at boot and is downloading the patch, the semaphore request
returns PATCH_NOT_DL_SEM_FAIL and mt7663s gave up:

  mt7663s mmc2:0001:1: Failed to get patch semaphore
  mt7663s mmc2:0001:1: failed to load mediatek/mt7663pr2h_rebb.bin

Retry every 100 ms, for up to 5 s, while the semaphore is held, then
find the patch downloaded. Tested on an MT7663 SDIO module with
btmtksdio built in: across repeated boots, whichever function downloads
the patch, both come up.

Fixes: a66cbdd6573d ("mt76: mt7615: introduce mt7663s support")
Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 152b75178b27..e5c2ad5fb458 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1241,7 +1241,7 @@ static int mt7615_load_patch(struct mt7615_dev *dev, u32 addr, const char *name)
 {
 	const struct mt7615_patch_hdr *hdr;
 	const struct firmware *fw = NULL;
-	int len, ret, sem;
+	int i, len, ret, sem;
 
 	ret = firmware_request_nowarn(&fw, name, dev->mt76.dev);
 	if (ret)
@@ -1253,7 +1253,17 @@ static int mt7615_load_patch(struct mt7615_dev *dev, u32 addr, const char *name)
 		goto release_fw;
 	}
 
-	sem = mt76_connac_mcu_patch_sem_ctrl(&dev->mt76, true);
+	/*
+	 * On MT7663 the Bluetooth function shares the ROM patch, and the
+	 * semaphore is refused while it downloads the patch: wait for it.
+	 */
+	for (i = 0; i < 50; i++) {
+		sem = mt76_connac_mcu_patch_sem_ctrl(&dev->mt76, true);
+		if (sem != PATCH_NOT_DL_SEM_FAIL)
+			break;
+		msleep(100);
+	}
+
 	switch (sem) {
 	case PATCH_IS_DL:
 		goto release_fw;

-- 
2.55.0

