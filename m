Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FAF3B14D4
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788718494; cv=pass; b=nTEiqgrJRi3pn2uvnlUpFd3AkDHJznTLnkMzoB8DDC9CLVH2WWEGJ31li48AElHSk3dXPH76Qya3dgiicUXpIpUkurSM2CNw0PVPT96rtOkaygu5+MW+G4SQa73SFx3Os2CpR2mnjwcRTLvuUl0mjy88Q+Fq2jbc8cRcwUMAk5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788718494; c=relaxed/simple;
	bh=2uIeKFJ6kSyQmOt/lS7FHOi4SRMwZSiVnijYyxEhUYA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=S1WrbjPlB1cOrfuvqcDW5/Quhbi/jwJ1bNdiR0x8SgUUUm63YgyCB+UCYJhYHCvYzEX6H66oF03DOMU5IHLWjLX97xQ77GuKa79AsneEFpJzC+jnPStQWqGSN5znYVplStF4B8OofrOEQNo6wb5IAA0WgQo61mIn3jOKkPr0z7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjxlB6QY; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjxlB6QY"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a5ebf75d62so4038975a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 11:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788718491; cv=none;
        d=google.com; s=arc-20260327;
        b=ApSmbWl2t1Rto9daprPUXc8kMJx6H6ClWn06yfapuM8w5j0V4oceLePvHE+VnCf7u7
         a6x8tSu5S2r/eCsdv7z4yKw1mtwrdYVvT8J6sXAAHKQhwGnwMl3gT+7KQ0Ks/D/EbJ0e
         u8u4MartnPedA9r8oCe4gLNy9Yo3BMCIxK4C4WoGF0YuaxSsGvThvVLUvqbkJWvib3Zx
         le0iiML1YCT92BqTpAQN5xTdKxaJ63cutDG9/RECrkuGq/fevUJwWSSW+o8xesiAQACU
         ZzDaBRGU0OStKx2ngib2Gvy8sfe4Q5zaq/sffdAHHdk1W97rCC8BHfVEHDBH1kykpITe
         Wh0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=BZBDbjweCgWN70lZ84c1vU1QYkRvTglzhT8uoQ1WdK8=;
        fh=1DTF61ZHMCVb9QAn/D7ApugNTuN8UQi3nwhcK4Lo2Ss=;
        b=eWlcUj/XzujUOOAw3PbFq1oAw1rPSN59+F/LPIrrj9c5PKwOzh7FmL6pTeDVbjEbD9
         Zytw6/80XBgeQO8Cn3WaawewX1CRcsw+54AOA3YzBoG73qranw4UeI+9WN2bA8GfLucl
         5F3zfbpxUJ1XDMgXQSyVflB9IDV/kQAmtU7zRKuveUpvAgOi92lAu2PPBIVohzgPzZIw
         ZSaKV5SURWFS1pwP6uYhFF5i4vcBn2g0ko/6CoTG5fnUuljuUtPEtFOjRUj3H0hjla7S
         oO6KtnHyG1bgZ1IVodDuv1nD7PfB4uSwCQVV2ls9OQNOmZPhDeO56P6KE8ugZf9J/mJ5
         3NWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788718491; x=1789323291; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=BZBDbjweCgWN70lZ84c1vU1QYkRvTglzhT8uoQ1WdK8=;
        b=HjxlB6QYal8/2wt1oQ9mvMN1Yqgvcscti6W3uLUro/e/AKBDQMFYPI7HPukQjVoSNE
         Gj3fEL8dKp8Oiq9qcnYqcCN2HmXePqzhQi7wDxwfJ1ev6+C6ZIeKUBrQ+g4TOZmWrpTF
         3M8VeYTrMgofoZ8AKeXV0Y18FgyhBjLcd5kEGGtZBFJlf73W00B25lKIsUGDhERv59hL
         WcMRcqmo1zJjOHq4OaaU113dYcHPbGbOQ5Iss00FjWug7XvbYYjPhLtBxQFZYZ9sjLHP
         KVEG1DlXaOu+wrwZjGC2YzheaUTdSK1mNodLfJcy8ZnxpagV1ZZZJanfoWVFLOpqu6hE
         2O8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788718491; x=1789323291;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BZBDbjweCgWN70lZ84c1vU1QYkRvTglzhT8uoQ1WdK8=;
        b=b2vnbFty6sRH2PSOdCXfgJ7FAhzLdd+2yBiqN7pZ66txbKIGIdaqJHfYEzCWIQ1rQ4
         Do5f0NR0wLE6dgZ0Ixl2npdKJM/Zo825hX5vaYU8Y6jD/NryuqqCUp/f9OBBYsFya8+h
         +dW6Oxi2pUVSuX9tq5aJD8euWtkdeX+Iao6a4M4PZdQV9e4fbtmJa6MhGmIJECfKfxm2
         5ULNBp3hQBXK+CuLOOEewERufbzpNNcO6cMOKH3Ntb9TqMCF1CPYnkDughR90fVO7pYE
         dJcAaWPx1oRtKmcoOqTTUdTO6srbVch5IA1XvZE7/rcSqb0Ehv2SvuiqBYIJiOy4gq26
         5Qfg==
X-Forwarded-Encrypted: i=1; AKwUvBwF/UGu49Cjw4XSbDPV5mrpQY9GT6ULHIEnoJz+gagD7OZMuVX1Sy2DO1MMOJfQFSbnyIkeIHoQ7kXeo1dbqQ==@vger.kernel.org
X-Gm-Message-State: AFuF++m7X7E9Ik4okdKKxWoWC0W6Etu8QR6v4SA5o9GQDM6i3VKWYUwW
	iVZx9suEo0tDEZnhZbExekNafNgFF8M8z0s3NdqCH3jFqmvG/ysTtWz9T218sIlUWIvzgUCeoFy
	32gBFyN6s4kxF/qj5WJXH1JztW6qWSLc=
X-Gm-Gg: AYBFou2ILt0hH7sWxalqlFNBbn5TSpVMBvryyAE+AUUKpm7qohXvnAgLuFb71B1AZ28
	LZEOKZhrMusjJQhfLcj+wPK94FI2Dg2dvsdP9SKZQMPPCVbZtAYn4mdHga1839lYTtMrpvojh7M
	J3By9vcFK5VCrm8sEwjep8ZlQJ3NOZ4fv63C8mSe2xX63dD8SOVBU7enblBovWJ82EYluXRkSy2
	CD5GP52BhrKlkRguV/XADtvB9q8UUyM/mcg4ycSQ3w9lbp0SPT5/G6yoy1pGRBHYr1eviulaWd8
	7T7XmMZO6E4DXQrziP30gklOGFpmlloT1REsO/h8/zLGi1UlF9L8HvkObHUbQhWmK1J5qLFuuMh
	pWAFQ08tzD02DgHC2gG8kFNoRmBNjd6Q=
X-Received: by 2002:a05:6402:350e:b0:6a8:151b:4f8b with SMTP id
 4fb4d7f45d1cf-6a8151b5117mr1163910a12.9.1788718491060; Sun, 06 Sep 2026
 11:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 21:14:44 +0300
X-Gm-Features: AcwNN1XQea4JVeKlgosC4Fnb06TVn9_6OLpz_KP5Kh1YLDKOaHMdq7n0R17mMXA
Message-ID: <CAMnMt5bi7417A8gRAZMKA8GJzwR+YCUEUQZ0Qeh4t7Vp=uq=mg@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From c03d73d37df440d0046d68406fde2aa1f62fe0d1 Mon Sep 17 00:00:00 2001
From: Herman Semenoff <GermanAizek@aizekgroup.ru>
Date: Thu, 3 Sep 2026 07:14:32 +0300
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe
failure on Tenda U2

On certain MT7601U adapters, such as Tenda U2 and other newer hardware
revisions, driver initialization consistently fails during probe with
vendor request timeouts (-110 / -ETIMEDOUT):

    mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
    mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640
    mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
    mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
    mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
    mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
    mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110

The failure occurs because mt7601u_load_firmware() unconditionally calls
mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
chunks. On these devices, issuing this vendor reset leaves the internal
MCU / FCE DMA engine in an unresponsive state after the first firmware
URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
(0x09a8) immediately times out.

Introduce a boolean module parameter 'vnd_reset' (default: false) to
make this vendor reset optional. When the vendor reset is skipped,
firmware upload succeeds and the wireless interface initializes normally.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301
Link: https://www.opena.tv/viewtopic.php?t=63919
Link: https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
Link: https://bbs.archlinux.org/viewtopic.php?id=224859
Link: https://reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/
Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index bad6ca821..abf4767f1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/usb.h>
 #include <linux/skbuff.h>
+#include <linux/moduleparam.h>

 #include "mt7601u.h"
 #include "dma.h"
@@ -21,6 +22,14 @@
 #define MCU_FW_URB_SIZE (MCU_FW_URB_MAX_PAYLOAD + 12)
 #define MCU_RESP_URB_SIZE 1024

+static bool vnd_reset;
+module_param(vnd_reset, bool, 0644);
+MODULE_PARM_DESC(vnd_reset, "Perform vendor reset during firmware
upload (default: false)");
+
+static bool disable_usb_sg;
+module_param(disable_usb_sg, bool, 0644);
+MODULE_PARM_DESC(disable_usb_sg, "Unused compatibility parameter");
+
 static inline int firmware_running(struct mt7601u_dev *dev)
 {
  return mt7601u_rr(dev, MT_MCU_COM_REG0) == 1;
@@ -459,8 +468,10 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
  mt7601u_wr(dev, 0x94c, 0);
  mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);

- mt7601u_vendor_reset(dev);
- msleep(5);
+ if (vnd_reset) {
+ mt7601u_vendor_reset(dev);
+ usleep_range(5000, 10000);
+ }

  mt7601u_wr(dev, 0xa44, 0);
  mt7601u_wr(dev, 0x230, 0x84210);
-- 
2.55.0
