Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792862854;
	b=3+Jryxm1yMI2kLj++ZppXFOOFixVy2cdt6hkj0seGr/hG69/aJf4VAhB4dHQ2SJQIyXV
	 IsniFE0PN1Kx+ma2fj5Bg90hdPMTsenPMpQkzjUvWnXhX9HVneOUqj6O34iEIkdxDPbcT
	 d5CFroG5kGhybGnSwoavhkMQsPaMHbS1pmaagZetpLeoID6IOGyhxhPfSPIvQG1rSCF9w
	 T/JqWRa6hn+udC+5kp1chJF7ABDR/AzIvwKw7YkeDCRU1vileFyzeBQ6Qcncp0SH/o8lK
	 6J3ClyTTpJJsVBYfuwEV8Vf04LN2BXiouSrCtFazODd7w8dSN1GWycwtIgiDGip6yDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792862854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Content-Type;
	bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
	b=QH08K/hyrktE+6Wnfc3qZoXgRsCY63bjmhXNxUeBXUZB7VvSJ1CO9bjiAlo2INj5juF5
	 Ok98/z33wwiepqIQK2wdlDP/8oMiniW9/NT2cgfSgEnBg56cCDhkq8H+IT41y/5XWEcmk
	 oec7z7KL54ggu98YU/98EBQh4k3L61m7rHwsVSVKr9oazvXNpsZ/MnZyztpXLhVu+DO5u
	 aD3uXg4nmhomdNBL2S4ERnbtJUh3uMuUX2dmNqPM/xQWSCg3zSENLwD8sD6yhG1lvghCL
	 9rE1Sw+IQob+tMyBWCk6uOKw0O/YSEs2+mPHtQ4NJWuJoYAAcjhSn7WKE9oKMZwcr+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZXuotAtr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C2606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 17:27:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D55C2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZXuotAtr
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4697404c2bso230570666b.2
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 10:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792862852; cv=none;
        d=google.com; s=arc-20260327;
        b=L3Vo1XbgXEWe3e+Cw2jmz71xdUr+yN8UFtGEkvofsiDfHkZGkxKe0cKZSNH11obOPZ
         0xdffbunrDFDouQKOUWK34FEV6e2gYDSWUCC+19DcYLP0TitS1NZbSGnwvJKwV681A4P
         AwHSl35xHUXXFKT7zFvRKICnzOdn+Z4COI0GPImCsMSuLI5NCRZ6oG8WGqMp3Pkj/e1L
         tyD8J0z9871uNSzAR4/mgpSdiGncZdpjOKsPMVoqpbbFzjcpJVVePMcYCP2kNxEHC5oQ
         FePilPtWI8xlXu8Oh3puu/mocfrN0gUdP4gCLjZQ1hjvS22DBzVoynsxEpncjXpP1UeZ
         v6CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        fh=ogUKfx2enzzC9F5ch4D/iv8Gvq/xmD6aRVL9l08lbgA=;
        b=Cpo+9o3u9RQAZFQezpcAQqkUJBLXiemhxIqvFCHcnygEP5kh9E9PXrHgLrIft0BaUr
         XlJJ1JCQErvlcxTOumDbsuXrOrdXiDB8g58DDt56IKYI9j2FG26dt/OVU2j9PX3xJFuA
         lX9QqsMoLkhrnaMJ5gLTNrunjk1LzDmKLkumpXyW31yPhhFfsyzmlJMbpnM4slXh2hV6
         xDLaM8KZs4ossbHV8ccZi18Mwb2tD0+CR6sgP9iJTraW5Yk/G9gXHNb86NwhqD1lvYUx
         T9DHpiNnTOGo1tAX6rVbwg0itROLH7492V0yv19NPCJ9nll9LSK78gwfF89CkhrgmA2d
         hBAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792862852; x=1793467652; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        b=ZXuotAtrFBfoMY9IT3TTNwOc53F8IKS+lv6jmrCdvM3lJSpbGYgILBC3NZpDCVoNJ8
         JvjQ7EMGG43zZTTeNHdL5JtMRFqjYTa/oWg6R2VJKV/1eX8zFljinDRiXXYtIB5bv9NG
         BYzxjhb6OjWVVL5E21vhWCbkO/uk9w9cLDcf005+M8ze+FzyxsLBlXAJQsCYz+zfO1+g
         nKE/DqMSfaiHkrq469yKtR9YbLC/Fl3g/uODV9kkXPX3RU7n8M0Thy4l+5nVV5Waa1X8
         ttol7mVlTn9QBc4p/+WEkAA3JfN2Uy4LbuPSu07W01CeYdxSsCeMoLKgmxVV31DmuR+T
         2FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792862852; x=1793467652;
        h=content-type:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X8ZJ80a/z4DWnRGcxZzAaCGtkR0kxX41wBpZTWuSpAw=;
        b=Z+koHUSmP2a51W6u3+61pnnrtJCprSKYYvmAtnGwdIL/2xyEiIHDFistoYiYt6xnTg
         2sgrZZblE9HCsW6q7Hyec5Xq8wPIk0TRWv3Mgfa8LGuoGYyEzmMUzVb4hRtF8H3uNjNt
         W3sscqZJv9+J8TCZmXOdu6oIz8crKbIZiSOgnDS71t9fbqWhCCIXo8kIJwmmOq/peklt
         wnAd9fgWtFnKNTizNbk/MEpSkL8IMonyeFtYdardmb/8sy/UHl7Pizey5JdUhbhG2ThC
         aBwJ/2/lIKASMZn2vxuWmLcEpQtk/xFxdx3ZfYr8Zf4kqSKxcZd/i1ppHrSGPhTgSn+i
         JdZg==
X-Forwarded-Encrypted: i=1; AKwUvBw1a3ZU2rZzt1ua3U2QxX4jzCerU4elzqkr8oW5rUtKXDm3PmWIbCjtwLL6XvlzkzmiXl+ma3m9qqt7de+AYw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+lJxdWuBpp5xnkgxalRy3CBBa6nKTY5OncL7/jNilqVJJ/AJH
	fOhBYHgPoL+R59VxL893LbyVjExDtGWEraua/bQwqQM8S8+p0PadPATcYRGAXJ/l6MR6Z8T6ltF
	veEhYfGwJXKbLpQpfB7TbtQf1w4TCYB8=
X-Gm-Gg: AYBFou0ZLjwD+N2KH59347GjS4V4JaojkZFFYD+r6KaNtc60rBjfLf3xwmqS2n9s9VD
	q+qwobGO/bZob/Uf0baHhPf26fv1JvT0bSNWN1GA4MxAyP/eGGpnAlX6lPejyzMPzASubhRCgMk
	sBwTFG8Pmi2up+FBfmQ3guzTelvSWH7AYRA/0c/UNGZZyIUW5omh3VWiLRHmGaooYsmtd2rRou0
	bJNNh+E/UEsVhXz5vAx0xihJrNzRbZg+z663jWJySlboZxjHLDYKIehqySJ2mxxxnXq2lG/pZ7s
	o+zWlT6TmxNbrTUzKeAlu2t1qROwLMrPhNAn5WGi9VfwQtbzwAxm5d/yaUHf9OX3UVhBl1NjDCt
	YuT42JeJWS2odeLyEGApVZ0QjfWYUJ4z3qyzUNXRwtC/goH4ziKUK+vfE1yJIyCE4h52JIFmMXe
	a2Y671zDjDL8uW
X-Received: by 2002:a17:907:3e05:b0:c2d:c739:30e1 with SMTP id
 a640c23a62f3a-c46bde6c920mr273371066b.32.1792862852097; Sat, 24 Oct 2026
 10:27:32 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAMnMt5aD83-6x8oRBo56kEwkrjPibZZ5SNR8MkwU9DSpM8HRqQ@mail.gmail.com>
In-Reply-To: <CAMnMt5aD83-6x8oRBo56kEwkrjPibZZ5SNR8MkwU9DSpM8HRqQ@mail.gmail.com>
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sat, 24 Oct 2026 20:27:41 +0300
X-Gm-Features: AclHuK99TnIuS0fkz2gWqH4dJEt6ZW2u5GPOzHC3qNGDC04AAeGmSky3JNfM_tU
Message-ID: <CAMnMt5YoiP50fE_gLgfYFweuGfDjNZKXZbsE50Fj-bGQQHM5vA@mail.gmail.com>
Subject: [PATCH v2 wireless-next] wifi: mt7601u: add vnd_reset parameter to
 fix probe failure on Tenda U2
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
