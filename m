Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B203D3BC68E
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716823; cv=pass; b=s6lX60fpqSpWo+pD4S/YH/R8rJMSXBcrzP1zO2f+NHZTDO9hdVKFAfipBCOxMfEqKUSKrgm7mRHDHNyJtQ0XruaViqJxr4I1/9p4YYo5oDQU7e9X4FN3V1TjLdVisIAp3vDQ6CCOn3lNhOpo0DQFEAMLWA9+Xa941/LCrucXjW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716823; c=relaxed/simple;
	bh=RT1vKor16SWprNgN2I46rvkJPkB6+81CRIOtFBRT1sI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=HzjABe6g5jKYd3jl9QQBQeVQdMY/JzNl688VQmShuM0/QpocoTV2E0YC3XdzT4ZgHp2KT62uJYE6b+/1zN70OIdRBzawgXJ13+2Oqgmlsb+zPC7JFoU9URV/yWccNiKRJzIx4blyYWei902fuhWy+kGjGM3dE9Tag9bq20rH7qU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AkkAiqjn; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkkAiqjn"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so4284822a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 10:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788716820; cv=none;
        d=google.com; s=arc-20260327;
        b=dZMEg2ibRcK+6znyaitIqzR85ncLF86PsqK5xbch+kRN1VJtwMaYySnpQ5qPvcn+Zw
         bjZIhBenf0vidtQaeZL67xOkfgaaPkUMEcy1UkXqFCC5+KB1U23276N/oR8IIrtabQmb
         nGQAkrgJfqR7eyA3t0jxrrc1yofoUPz3U2lRqj07OlDwhOkfFUHbOLk2nc8KMA3Qmqnp
         l6gmrrgcTnOxYmE6YfajfWIAHrndI2kMlMVVXDhBv6ub0D3picWEuQxjlcvxdqAnsG35
         32ySiNsIS3JK9CKZxlQ0uE+8PJVwm6Jx0aGrsunG/jkdpmi713LRY8R8fqdyX3ZIsQxr
         yWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=sOTHRTeo1uuAeRV8y8wQh1qPhCpdcDYGMX/pO45ku1s=;
        fh=AanQbhDIV90OJFDRvd3xvwTvlbchiojB0HBCT+UgphI=;
        b=ldbzUa1QoRcc1DRdkXOwzpvIAc1oGIlWmw4Xo6eOo8ufkppMqV+02kJACizqBK965t
         T1SCdOclgIOzXR+yEFBwJ1h6QMgLVIBbUQNS9sX0KT7B+JS0HQ4ZXbLhcKXprcqb7qqE
         k9V4GsVQb6AfZCXr02vvN7i4W8/G1jYUh1Olz/wljkWewkAjdkj6cpTZxgdFRbcx/kZy
         sX6cQ3ZFx0C8LcAqSfwV9MRf1TxKf3L4oXxhRalPnMqG+Dp/+mvqcaUHXKPimBOE6Kmw
         5yxvwuGp2HsDefIGVJy4hwaajNlHviPPvfnHXeVhZEYkuAmjJPNYvXEx1uI6r5qThH1W
         yhLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788716820; x=1789321620; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sOTHRTeo1uuAeRV8y8wQh1qPhCpdcDYGMX/pO45ku1s=;
        b=AkkAiqjnJDBr3k1IVibJ5mpMDYDXKPLC1KZuLD7ewrS/elhfK9Fy/iVVfNf2oiNQV1
         n+rNuuU6YWQPJkJIAG7JmsgTz1suW3Z0Dl0lo73XgC2V8koGkgf6T7QivYGiAp+am+dZ
         W5o09bdRzFAvndkDZCkLBDFrSqIIfEVFO65zhXu0Jdah1N/Pu1Oa9pFdMEmNFSiAQFKp
         gQQDfIQPQgEqQpXYdVZbNmWwnxLGtmQvAe55qLj3MiJRpU1e5AZJ7+64kTaLXBz69sFB
         LvguadoyQYj9r8N09KJskrXsd0VIe3Z0SYQooXyehpvUtkCwnOlckvY2zjajzznKnbmD
         zjUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716820; x=1789321620;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sOTHRTeo1uuAeRV8y8wQh1qPhCpdcDYGMX/pO45ku1s=;
        b=im39KpER502yKx2QUQ8fJFNIwZ3eFo9vBowJgEFnURgQ4/j82qLWYzE3tJNY+RpIzb
         B+ZBbO+OdvAzxF7HQuZzHJddsK9RXtkYFnfupFxxu0QN0ujhKwWFeMbft7bBtZ0vVITn
         KcM7cQT53SejncPbXFCPmVvwUZGmG8FO5i+KoWaXx+dn5HaYMZAIWjXqFDLt6VbAVPw1
         ALaubBt+TddJDlmsA31i92RpMXmnLeCTpaqvBm91Te3k7xGg5+OdW0Iw9iln3CVFC1+H
         Lp/n4XzmhW1lCDDYMLvWw981u0clc0rClr0WiMv/4Hbbe8ZRf92IkFiktNlNcEXVDtgD
         1MFg==
X-Forwarded-Encrypted: i=1; AKwUvBzaTxw09FJAS1ciNmv1pEjv93BHhSuxaponBrgo56zyXKT4pHrKG3Nv8EWDNgujSFdBfhY8LOOMfo3FyiXLGg==@vger.kernel.org
X-Gm-Message-State: AFuF++lHq8Nt37yhw7TK7NsLSxk5QwinSW+2TNYYYO12eHei2Grp11TR
	F+s+pmACvKb4IdG8Dx9PV+mqTemr49CDn8UdqiMdCRF3ZJpH5Jn8JEmOgAvWLOun/InbrxW9ZVh
	D1TVlQ2DY1e7/bu0IL4nxzqIXUeQ+MQ8=
X-Gm-Gg: AYBFou2QfYmpX9n/S3/epJ0Gb3bbzBgs94b3hokcC57cgTSa2KlY1xfNcOE1YOdLbFR
	ajvmCs6btUlmUh8jDOzWHC7Qc3wVUgDZP6UFzGxbIcBhQof1pgF9UBbMcwEboGezeeNPPmhewnF
	nhak6bb1uUIoa20NOPi+IFcTSqfBAXZQNDkq4By+eDm4jBB3Ndqt/RT+ctVd7Lz+9RwsY5EytOy
	xkbulCqhz95F46vO9YvD951MhYG4xpasnCng/xIzLvJQmfENm/xGBrTMT4DrPRLhyfu8twSpaZw
	pypESAP/d0RJ1sngHY0tl/fU+mKo5TntKMG3uZl6XvHRhxJ0GiIaFGFsQVjts2blKdaE76SCWgS
	GpCPJPJSbqN/bcm04R7x/2Q==
X-Received: by 2002:a05:6402:2709:b0:6a1:b515:d2b9 with SMTP id
 4fb4d7f45d1cf-6a7e8e95b74mr869492a12.14.1788716819865; Sun, 06 Sep 2026
 10:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 20:46:53 +0300
X-Gm-Features: AcwNN1VWBWqQMURRhY4OdGyiXXIbhwwC9IMfYsou_S9_mMyXq0_U8RCPF8GcX6A
Message-ID: <CAMnMt5YqQBn08_f1diNrb5z7=Qh-a=8Ju+QvNc6bQcCf62m2yQ@mail.gmail.com>
Subject: [PATCH] wifi: mt7601u: add vnd_reset parameter to fix probe failure
 on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On certain MT7601U adapters, such as Tenda U2 and
other newer hardware revisions, driver initialization consistently fails
during probe with vendor request timeouts (-110 / -ETIMEDOUT):
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

More issues with Tenda U2 and Linux:
- https://www.opena.tv/viewtopic.php?t=63919
- https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
- https://bbs.archlinux.org/viewtopic.php?id=224859
- https://www.reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/

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
