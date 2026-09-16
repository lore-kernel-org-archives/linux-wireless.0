Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F153AF66D
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 01:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789522456; cv=pass; b=YmBRu2XuV53AxtQUiPvx1O/l29gZCnlIN3MYPvI5YsTy90Gnux1z2WAPVyfBlgFlvYTgufawvErdUZNDHHpecQGdiAlITA1/lAmVZyflANXqhpCfhwq7EaTgrvWTPpWEbS1a+5meRV+n1C9rmHn6qHg+m4x3fVx4Je7ZtpI1Xzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789522456; c=relaxed/simple;
	bh=bcGw17MDxQDxC5Y3/F3j7nu7GvtT2jwlY8xu3ufPlqg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Doks8pA5wj19M4bnGfB95PAwVtcaQfaQoviawidX/I9oBdfMF8ZX0dMVdaCzMecETe1C456qveFFN/TtA5UiyPUvXSEp5PwMFP/9VE1eAipldOrpBcfu9kTC9v0UjtEkB8Xa/XTNf5eQkN83R+gBSWhy5nskHRViXmTT3g0mBsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOFOxcKv; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOFOxcKv"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a803458ba0so663795a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 18:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789522427; cv=none;
        d=google.com; s=arc-20260327;
        b=l5yS5WNcQAgfeMuHbJuejW8Xi3UIoTzIDhHhLXaz+pvT7OX150os68IUYVH5IibFTP
         XlJZzudiwnJgLiACBt56bYwlWVZzww8dQB1Xzy5rD1GA/H44cHBVZj9mf27t8g1CDZF0
         zUlvhAhJnBX5DpQCunKddGVDhkuWmfsbpSzuiVyCswzoedxkwX5cgh0vc4Cy3ysVDl+q
         0nAcgmYiLjeFLZaHxl7swaVXzmKfMxKFUp1gRIAx+pma//eXT0f+kL6Iy/9iBF9z3Qd3
         v6GzxuqDF1j7vrNpU2q5BXKw/VcKDKbI8aXTL/MErOePBTpG1XEd7FOK0BeJhe4k/iji
         Zg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        fh=KG4Lafb/UGfJGyniMd04nbwlqujRyWA+UIJFOt8+5S8=;
        b=ETekB19YUFA4kCe0YLlB3GoXQH6Nw496IX3xXS824/KavBbVmdrq2glZZSS00mlscg
         yLCcEBXcIMPNUwFXKJPcCEg3EY3MSvQhm+SSUU8YOYts4ftJWgokUu+pBzkTZd3C1hxp
         rXiJ5ZqrQnk2dl0mDN4aVK1Pp+seaYXQj1rMRddFUG34v7+uKdLqtRpeA77orV97Lxom
         Aq0mwEgPcqRsD36PbMqfurye6jm0UL3aG5QamAq/vcZGVhPPzNHMQxj6XQj377LKcOwn
         Ik/BDByng/J9RXJXenWvK7cbNu4T9zEAimM4zmoUzIrCnTSkoxegOInIuVVLQLqj4w6j
         hzfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789522427; x=1790127227; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        b=KOFOxcKvTbLEc7g0IbMgVrmdT7vheXxNIZOVuFFYFEqTrSoaNU1sITDElbSmBG056S
         uQK/hu3N2uRpNOh1D+DT1e4KFcuQszjYtGkfyXLwf/aeWd/Qfox9Z2x3yhB9g63YpOkU
         u9hifp/rYNgX+sH7O15up8eEXDsgN15dhgRzk63uF2pc403Gu0oANjHjDj7fWg63z+73
         5xu00Kv9p34zpmHQ+NnYEvsQ+YhNmGjxGf9vrZ17auYYGSJgAlw9KVXWKMugZUf75Wjf
         1hv/vV8yNYtJShn/rGbR4ZdIxv5ROidD6wJXsbGWq7bFJ+Vnn+n8tVH0LF/Ts7HcM+wq
         M+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789522427; x=1790127227;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        b=HJMBgr3S/yNiskMWoKh20PXEwkeggRERkiZYff8M2mBwFi9Gtlg9ZuotRN4OSbe1R5
         Ee9ypfjMzD2Guic+tt9ihl41x9DFuxQxo4T84Q3630a2AuQSn79Y4lrzGONHZpHhYSly
         Ul+BwxBJhWpaf1+mF9TbVJ0iTz1nYSAlTQBGbRG9C0ZoyruRNx0HUrmfSOELHGBMYEtC
         xzWtfgvbCjCsZnZPPUhlZsKJkN0Pis/IM3vlDr5VAqyc6hy2s0KOy4BeCSNXnsxC+iIF
         TOe6cJ4AetgdGYCQ2KrjxKmjguyoQCQmPZknpPCjTF2wWpgdh6ycH8pvhcS3C1JbTs5r
         iiLA==
X-Forwarded-Encrypted: i=1; AKwUvBxuPLf8ZBQwQLGGdF1pE/wb781/8hlcHaSpvJw1YWZ1jdKqLqc05xNYP3rz3JNI0bbeO3XTx1ulECeM4qkEQw==@vger.kernel.org
X-Gm-Message-State: AFuF++kKv5B87Ya4raGrSy64B+YtvHOJp5DrgJjnElqrC1q+OrotgJja
	Tfp32xWj6WqAMIpL5fYSZa8FsHCnhb9yNbN/krya/6k/S/uQFPfzWAEAQySOq2UE9kiCVD5PXmh
	+uFI/RQrJjNDnRQzYhFRY9g0TdqKhAeI=
X-Gm-Gg: AYBFou13jrZnrdQIbG8E0JkSLlfekjuj0MGbZKmMQMIqpXQjGwV3lQ2WkyHLH6aoWYZ
	m2O8yfK4rhagicklMEGEPLCqlBGX1+wQMgJ4VbyduLgUlv2Sl4qKreGgsj9Jw9hZ+rJ1cDqgk1F
	MSBadKTrX88ywTzy7HJ4E1/y1xgxE5xPpXWJwNmkifY6X1WbSQAZueGgR6Of6PJjfGYnVkKhCkV
	3mL7tha80Wy1P9OMQ+Kh76EyV6IVG2xcOqksQiIlGkijMW63kfPmaZg8c89yQCSejCoxV7BzeBn
	yDRAjbJ+w6F7ZpbYxPgWH0QegzmPd9v0ubYPufjJrauVSvf/KvyBov9FdEKLdEfC8sijNE+Pip/
	jrM6s2qFqujhHS0u3LCFinqvx0IkshHY=
X-Received: by 2002:a05:6402:a0c9:b0:6a7:ee56:615d with SMTP id
 4fb4d7f45d1cf-6aa223fff67mr390484a12.31.1789522427160; Tue, 15 Sep 2026
 18:33:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Wed, 16 Sep 2026 04:33:44 +0300
X-Gm-Features: AcwNN1WRjAmPrMxRjAxEMpPlykDTvmaP0osOKfdExBpslvJPszIxJRGvBbTeeb8
Message-ID: <CAMnMt5aD83-6x8oRBo56kEwkrjPibZZ5SNR8MkwU9DSpM8HRqQ@mail.gmail.com>
Subject: [RESEND FIX PATCH wireless-next] wifi: mt7601u: add vnd_reset
 parameter to fix probe failure on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On certain MT7601U adapters, such as Tenda U2 (USB ID 148f:7601) and
other newer hardware revisions, driver initialization consistently fails
during probe with vendor request timeouts (-110 / -ETIMEDOUT):

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

The USB device is already reset during mt7601u_probe() via
usb_reset_device(), making this additional vendor-specific reset
redundant. The vendor driver never used it, and devices that work with
vendor reset also work properly without it.

Drop mt7601u_vendor_reset() and its definition to allow firmware upload
and probe to succeed on all MT7601U adapters.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301
Link: https://www.opena.tv/viewtopic.php?t=63919
Link: https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
Link: https://bbs.archlinux.org/viewtopic.php?id=224859
Link: https://reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/
Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 3 ---
 drivers/net/wireless/mediatek/mt7601u/usb.c | 6 ------
 drivers/net/wireless/mediatek/mt7601u/usb.h | 3 ---
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index bad6ca821400..979bc506d4ed 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -459,9 +459,6 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
  mt7601u_wr(dev, 0x94c, 0);
  mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);

- mt7601u_vendor_reset(dev);
- msleep(5);
-
  mt7601u_wr(dev, 0xa44, 0);
  mt7601u_wr(dev, 0x230, 0x84210);
  mt7601u_wr(dev, 0x400, 0x80c00);
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c
b/drivers/net/wireless/mediatek/mt7601u/usb.c
index 9306870cbc91..0d38644c491e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -116,12 +116,6 @@ int mt7601u_vendor_request(struct mt7601u_dev
*dev, const u8 req,
  return ret;
 }

-void mt7601u_vendor_reset(struct mt7601u_dev *dev)
-{
- mt7601u_vendor_request(dev, MT_VEND_DEV_MODE, USB_DIR_OUT,
-       MT_VEND_DEV_MODE_RESET, 0, NULL, 0);
-}
-
 /* should be called with vendor_req_mutex held */
 static u32 __mt7601u_rr(struct mt7601u_dev *dev, u32 offset)
 {
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.h
b/drivers/net/wireless/mediatek/mt7601u/usb.h
index 723025f84483..49fede310c3b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.h
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
@@ -14,8 +14,6 @@
 #define MT_VEND_REQ_MAX_RETRY 10
 #define MT_VEND_REQ_TOUT_MS 300

-#define MT_VEND_DEV_MODE_RESET 1
-
 #define MT_VEND_BUF sizeof(__le32)

 enum mt_vendor_req {
@@ -65,7 +63,6 @@ void mt7601u_complete_urb(struct urb *urb);
 int mt7601u_vendor_request(struct mt7601u_dev *dev, const u8 req,
    const u8 direction, const u16 val, const u16 offset,
    void *buf, const size_t buflen);
-void mt7601u_vendor_reset(struct mt7601u_dev *dev);
 int mt7601u_vendor_single_wr(struct mt7601u_dev *dev, const u8 req,
      const u16 offset, const u32 val);

-- 
2.55.0

base-commit: af5f12805e5cefa4fe68d6127c7e1fb78cd5535c
