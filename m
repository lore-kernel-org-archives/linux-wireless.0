Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF55364EB2
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788717918; cv=pass; b=ug1giHvIKtb4o7P1NAoBBbzFqp75I0iCOkF9yUgRvm7Kq4hvI2AwSknRCvtNkfPzGet6b0ja0uyaHqCCNSIMz8TKI3ku4yo6qczw4IEwtDXtHKY6aG9SIj6AjZ/cQRZnAy3T1cRikDlbcG0iOfKnrTjmXfCHiheaS2HBnZgvgw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788717918; c=relaxed/simple;
	bh=oZrbA+gqhj+N47M5MEXg42k2Lnl2gVVvx1vsYaMwzfE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=aCyMOMcyhk3Jdm13/f/+EXMjcq5cn1LiK/G6qES/XUEwXB8w06Zg9XgW+khFudFCTVfcS/VSxgfZsx8ApR00RXvpYuJYV0q0PJjqi9VzO/27GdVwbECVgKnr5ojfOFdKeDTboKYGwJHOeOo4MVl36KFdfSNcAh9s/If5kbk/ZMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PO3zhmpL; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PO3zhmpL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so4206943a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 11:05:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788717913; cv=none;
        d=google.com; s=arc-20260327;
        b=YHHIi/ErDiRNPJ/wuiAF4R76BkNd8FE8LYNYKZYElxWB43nXrlvmvwIcGrJcJuU1fd
         8YSA+hcI9UPWsz7rijMzV9eMzGh30BWYOz1T12LTWUBc38o6bmBHmSy5QK3z8EjSVgZS
         Iq7ChY9q+qY1CVcJpOTKVJwUN8uecT5zRVKXNJ70pGEJ/3QArtnDZu+mf84opnJlGXV6
         5sYLXnLIL+BxwW/SW4ldaUtzft4Z/rkFCDLxCUu40mudhWy6yTT2ZkAQARsSzcdAaN1Z
         pDy7HYbBcPMyZ6T4y9XwJ/5PLBSYg0ixQDJdoojd1s0U+SqQRgbvPsrlniLxU+ygzFol
         no+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pa0aNgWUrAXoDkrBmj85T0XzOgW1Y6aPgEyekCwvi4c=;
        fh=zmCRzwyC5X/imv2F2BPe8HbucM95be1OG6abwhHXRcU=;
        b=dbyIXrjEFTTXzJIkRF9zCD7IlRZp8c/4YnS/Wlr/y0m9TFVA70po3Jqv8iIXNfZCa/
         jFQMHrVqb2msL6XVe4ZXZjDeK814KlKi9NcQcDGCEvzE4Y994SnA74R1QQwIv41w1B/d
         1B1GJawLZPXNmmRfFMuIrfKNcH0K/hJIPKJuNo/m5mBJjQ+taACZr5EgBaK6DU1Ju2sa
         +7ZNKL6w6hmBylPzhXxNewMCUqAeuSVyw722iED+7CwQq2kmclfTA6pALCGrXTDhVEji
         UdP1kplYqCdz2sBQXd75qZiVKbeOmKtza7CZiihGvdBrcl4jAly4u8Ihu6lMyPgB0Cwe
         0LkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788717913; x=1789322713; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=pa0aNgWUrAXoDkrBmj85T0XzOgW1Y6aPgEyekCwvi4c=;
        b=PO3zhmpLzjFBBJwPpDiDhAi7SI2nOwzfbqZ6elOJM2DlQOqyZulbg/Azlq1/O9SrRC
         8By5jUyilrngzFXTc+nIr6k9ihm+snBsFlbEO9uTEow/PPCSbqFDW/nKq+E9MdSpUpBO
         kCvjAaxs89tWPf4BkbAE19o7sCzGuuBx5TgcyqJpYC/obOhRtTNfxxSjtY9iCKVQJBMW
         DGSzzYb9bPHNTyxuIII1rG8HssjvfamU8KX0Fs+3u9qPcwk4BxMZfYPBuKS8qIiLqKKW
         074rFyRkyWHmcAFfcBat/oW+lm4zcBjj8ECWvxlbteVc5c9CH1yg4FTFikxZ1Sp4JxB/
         GCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788717913; x=1789322713;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pa0aNgWUrAXoDkrBmj85T0XzOgW1Y6aPgEyekCwvi4c=;
        b=f3KVU5iHa/eEl2wOZ27tc5LASX0tzGbagA+FvNJpX55sYRXW9SiO/92p0NzHhqOhCE
         2/vb5ngJcBAf2LNi2kinydv8HmDE0KDLofAkrDpL69yLmqqaCOk7oWFBX0Yk0eZIqqhq
         rBrSbC61SYzzHYOVl1MrBoF5k1hioL1h+jiiFdvAtzx7KrselAdYMCokqUTcgk4BpfNH
         uIQFRMuM9jxG3ZPYRCIfdzEshVsWGngbQeZ6HsbS2WFUMIuQ2PZheTmfF7Nh2gwB3RA1
         RSPNZZTyZZlHxA75b0+zyYJb+t2MCMp2e7WCN+jNkdQj1n8laGQktjhHY0B8TwpqrV/F
         YOqg==
X-Forwarded-Encrypted: i=1; AKwUvBwK6oRf+JUZA7hRvW7dUcwxRqY/IqfKT7nKsASETolczvnKks1nazMwILgBUZIzMgQzz1kFDEeoQin2fR7MKQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lzHKGwIKsl17d5haEJqjEaO1HSx2KbhvR0enMHK21pkI7sKJ8y
	RnVVbvldNBMKiJ+izzb0eYRmDSFAFAXPjqeRpTLDE3Jty0I1oaSU8F9fXymCLiEIS8vyNTTZr3H
	9+2DC5ZKZmyTkjKYn/Wkt+WaWJxENpXVSAytG2A0=
X-Gm-Gg: AYBFou0/jJqZBsvftCKhFl4YvTl8Ri7WZLCEtT8w0UEjG3QDp1SyWTucV7LE5dfg/5N
	F6TAW4c6O775lK3KIOcNW9KRpmrArq8MeFK9uDFwJNtBZfhUXTrTuHw8IhPqPdJ+U52gJI8vO6u
	zd77YXsMD3RSrYiAZ5XB+EC7UR79Dpw6Y+MShwrdoJ34wsiPbTz7R1W0bK10YIV6mQYbB1Glt/O
	N7BmHD07awl1QSYxv+5xVxET3ESCvD3nOQY0nyJila+Pu6Q9PCV1mp/xK5r4UpWL1q2Da99AYYY
	EegD6r/vv9CuqpIAlSo69NVmLFsc7W4nC4NQAfz89Wdlf288xGj+GWIAYc1p37dV7bxNjVfwBWN
	YgJcHh2wI+tuntyj8akCr
X-Received: by 2002:a05:6402:3552:b0:6a7:ee55:dcd6 with SMTP id
 4fb4d7f45d1cf-6a7ee55dd7emr5195426a12.37.1788717912975; Sun, 06 Sep 2026
 11:05:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 21:05:05 +0300
X-Gm-Features: AcwNN1UFEVFNvQf-_X8sOKVlhKXXkSgs5UqaHugB48_TROvAqilevHmYdWT9u90
Message-ID: <CAMnMt5aEXztCdrr-rFMOv9rEKgxVir4Oe90mPpO9duQoxLJxCg@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On certain MT7601U adapters, such as Tenda U2 and other newer hardware
revisions, driver initialization consistently fails during probe with
vendor request timeouts (-110 / -ETIMEDOUT):

  mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
  mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640 Build time:
201302052146____
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
+ msleep(5);
+ }

  mt7601u_wr(dev, 0xa44, 0);
  mt7601u_wr(dev, 0x230, 0x84210);
-- 
2.55.0
