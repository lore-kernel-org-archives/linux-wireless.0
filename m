Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF34D41D215
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 06:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786603260; cv=none; b=ucY0yiQcxRGWGSGoqim9OswxckVLi9L/85OtzI3b6H3K11494NXC3l/3FAaXmaiN+Y5IJ7q7PEjxaFjxBHSnMTFWRKxa1puC58nwsIWn2qzkl1pScohGLB6/mNG4l1HiLR9PG/1QGMPyMz8YN8Z/d1nb8jMBGfjMbcde6DT11zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786603260; c=relaxed/simple;
	bh=I3MnwJKeKecLiZA9lN0unfFy2VZRO/RtM/o/Ua9pfNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey5tsDpQyjv1h579iZAXlK/ZVN1mas10a/d9kKBk66/owtE6XyRCJS3XAi1UAXMzxmnDvDN0odbRnjynmW3xfw1iFAEYIbV1pjf1BQfD/0mlgKjCfpjQZhAcmak83uEyFwTA+0XiWDp0i0JGFA1K6f+If/VvurGA/1uWzz+YDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYMfccPj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYMfccPj"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47de0093c42so1603647f8f.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 23:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786603251; x=1787208051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OjgCOQZV4xvZ6ZlJku/979mNz0W9TKBYYyEUFdVQ7Pc=;
        b=fYMfccPjzLoj2LwtZ5sUcFIdIg8fhM8KqnStldw0og0VwSYzhM62hOyxM0xBPHY8QQ
         X0Vmjpm/ZMsCNJtF13L5Em7CCY/V86DfYHBzkDjT/+GjfXbDjkc9FqzQpXNjVfxhNEat
         COxkaKnuCtWQHp06vMGdHyfE79C2x16eQ1oz63vH5plh7tWImQXlLWz/hWeAtWiQR5Xq
         rPT4L0uN0Ap3Zpsie2vzKlFFmSHWBmXphgzXUtuh2l1leCwPkzyRGCBHr0lx6uwGkx3J
         rlxStTQX/FdDIXR5nLp8bQWocfHuh69fSt41kAhwZT/b5TnYPGXTjg3sjUrifrO8+dhq
         +NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786603251; x=1787208051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OjgCOQZV4xvZ6ZlJku/979mNz0W9TKBYYyEUFdVQ7Pc=;
        b=pncKVyGt/oybdXIHLNFpLcbhmxm2GYXLXsKIlre5vKnhgJO5P2F/RE+nT+pNs5/TNv
         4rT7pEfSu1jgjpU+GkL1DpswSeUE83HSrMZeCC8LLzDWt/cP1Mi23ZGSY/ITVMTnRLfP
         1FkhO+aRIvORbF92F2+1BDwQzyYCjt+p//TqXMw9jKDvn/Eb3Iw5jQ5Sy61ZiyrY1EyT
         LvXCpSjqCWwWBk3DUMqzb+GA/YpElL6PSmw6Bx1YdX2jFRNgaJIzxbl66joJCm5B1tQI
         kGYiCRATZ+UcKdFVPdfV384b4a5DEXDfYP955SNV4Yf8huUXxfrwUOFtASQxOsp3CCv+
         9w6w==
X-Forwarded-Encrypted: i=1; AHgh+RrYLpPblzjfqtR4LRv1uByCbf6OV2BZWYs21P1Gu7/56etBNx5ZNy0+Xg+1z1O/eP5rP8ePM8VrKZ02TDxMfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQro+lEhWKB940g5rXX5/m6ckktE6BnQ43wXpzMB//Bm4il+s1
	8Sl+83YlCkE3hlzBJE598WqzaHwCOojN33LQ9KQNQLJvTgXPOa3wDZg9FUGcVQ==
X-Gm-Gg: AR+sD12fCaoyIdipH363Ps3WhNh20I1EdqfoYQ6bv1vfGhG2q3tDb/W7OmmZj6zSwef
	WVpJn6ug8Wx0Q2DxctNqAgcwbB04m1Tw8kU04vYLFN7p3N7tFILtDfR72Cs0ORznO78C48337x2
	PmyyMNqqyGFcBdngO7lqG676axpJe81YfN7WXwRcS8UAC8E+IhsW61bxaYBQ+aIcOaK86A5QsmC
	aotVJHXMltNvw2x5C1VGsFAd7zoo5oiKrbOyGCuhUAnH7zxfuZ1J+hQdWa25XFalE4Fws6cpGhT
	TEABBrh/t3qleVKlHhLnVVC6uytt1aM0I0dmvwOGunDLozXC4piFjtvTKgcxZwQTnEVGetjn3qG
	/BfayTu+uWC6KWlZVtVeq4T5oJjvGdvR2sPREmLn3KOSyMNAZUrFcdusIZFXeNPPr/WiuAf3SXh
	iRUNgipGLzsUssLlfTrtalMUnIVL1rq0Z7ikAhP2Np6nm7KQYdavZJeUKffovJgPOpkw==
X-Received: by 2002:a05:6000:2c13:b0:47f:9464:86cc with SMTP id ffacd0b85a97d-48159cbd121mr4453345f8f.2.1786603250415;
        Wed, 12 Aug 2026 23:40:50 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5b6e3asm3407586f8f.28.2026.08.12.23.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:40:49 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v3] wifi: rtw88: usb: do not log transfers lost to a mode switch
Date: Thu, 13 Aug 2026 08:40:48 +0200
Message-ID: <20260813064048.198903-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <72ff0d793d61415eb9fd1c513abdcc5a@realtek.com>
References: <72ff0d793d61415eb9fd1c513abdcc5a@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
rtw_usb_switch_mode_new(). The chip powers off its MAC and leaves the bus
while the last control transfers of that sequence are still in flight, so
they complete with -EPROTO and the driver reports them as errors:

  rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
  rtw_8822bu 1-1:1.0: write register 0xc4 failed with -71
  usb 1-1: USB disconnect, device number 2
  usbcore: registered new interface driver rtw_8822bu
  rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13

Register 0xc4 is REG_PAD_CTRL2 and the access losing the race is the
rtw_write32_set() that ends the switch sequence, a few milliseconds before
the disconnect. Which transfer gets caught varies from boot to boot: 0xc4
is in the "always on" section, so every write to it is followed by a second
one from rtw_usb_reg_sec(), and sometimes that is the one that fails:

  rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail, status: -71

Nothing is wrong here. The device re-enumerates, probes again and registers
normally, which is why rtw_usb_probe() already treats a non-zero return
from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
switch can never succeed, so the message returns on every boot and
everyone using such a port has to work out that it is harmless.

Mark the window in which the chip is expected to leave the bus and skip the
error reports for transfers that fall into it. The mark is set in
rtw_usb_switch_mode(), so it covers both the new and the old switch
sequence, and it is dropped again unless a switch was really started. It is
never cleared after that because the switch always ends in a re-probe with
a fresh struct rtw_usb.

Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
where the message appears exactly once per boot. With the patch both lines
are gone while the disconnect, the re-enumeration and the second firmware
load are unchanged.

Signed-off-by: Mehmet Fide <mehmet.fide@gmail.com>
---
v3:
 - set the mark in rtw_usb_switch_mode() instead of in the two switch
   helpers, and keep it only when the return value is 1 (Ping-Ke Shih)

I did not go for WARN_ONCE(): it would still fire once on every boot, which
is exactly the message this patch is about, and it would add a backtrace to
something the driver causes on purpose and already treats as "Not a fail".

One note on where the mark is set. The transfers that lose the race are the
last ones inside the switch helper, before it returns, so setting the mark
only after the call would come too late. Setting it in the caller before the
call and dropping it again unless the helper returns 1 keeps it in one place
and still covers the window. The small cost is that the couple of register
reads at the start of the helper are covered too.

v2:
 - regenerated with git format-patch on top of rtw-next, as asked
 - also cover the old switch sequence, used by RTL8812AU and RTL8814AU

 drivers/net/wireless/realtek/rtw88/usb.c | 23 ++++++++++++++++++-----
 drivers/net/wireless/realtek/rtw88/usb.h |  3 +++
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..7a4de4995 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -64,7 +64,7 @@ static void rtw_usb_reg_sec(struct rtw_dev *rtwdev, u32 addr, __le32 *data)
 				 RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 				 t_reg, 0, data, t_len, 500);
 
-	if (status != t_len && status != -ENODEV)
+	if (status != t_len && status != -ENODEV && !rtwusb->switching_mode)
 		rtw_err(rtwdev, "%s: reg 0x%x, usb write %u fail, status: %d\n",
 			__func__, t_reg, t_len, status);
 }
@@ -90,7 +90,7 @@ static u32 rtw_usb_read(struct rtw_dev *rtwdev, u32 addr, u16 len)
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
 			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
 		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -140,7 +140,7 @@ static void rtw_usb_write(struct rtw_dev *rtwdev, u32 addr, u32 val, int len)
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 			      addr, 0, data, len, 500);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
 		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -1172,7 +1172,9 @@ static bool rtw_usb3_chip_new(u8 chip_id)
 
 static int rtw_usb_switch_mode(struct rtw_dev *rtwdev)
 {
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	u8 id = rtwdev->chip->id;
+	int ret;
 
 	if (!rtw_usb3_chip_new(id) && !rtw_usb3_chip_old(id))
 		return 0;
@@ -1189,10 +1191,21 @@ static int rtw_usb_switch_mode(struct rtw_dev *rtwdev)
 		return 0;
 	}
 
+	/* From here the chip may power off its MAC and re-enumerate, so it can
+	 * leave the bus while a control transfer is still in flight. Keep the
+	 * mark only if a switch was really started.
+	 */
+	rtwusb->switching_mode = true;
+
 	if (rtw_usb3_chip_old(id))
-		return rtw_usb_switch_mode_old(rtwdev);
+		ret = rtw_usb_switch_mode_old(rtwdev);
 	else
-		return rtw_usb_switch_mode_new(rtwdev);
+		ret = rtw_usb_switch_mode_new(rtwdev);
+
+	if (ret != 1)
+		rtwusb->switching_mode = false;
+
+	return ret;
 }
 
 #define USB_REG_PAGE	0xf4
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 9b695b688..9d2825368 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -85,6 +85,9 @@ struct rtw_usb {
 	struct sk_buff_head rx_free_queue;
 	struct work_struct rx_work;
 	struct work_struct rx_urb_work;
+
+	/* the chip is re-enumerating, control transfers are expected to fail */
+	bool switching_mode;
 };
 
 static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff *skb)
-- 
2.54.0

