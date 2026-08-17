Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E4226D05
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 06:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786948404; cv=none; b=UY0ZlFQqygvegHKCMVBrGl5HQffHOZ1M6FvnfDOJ0/y2RiZuqGVDHl6gZmVWaPP04jAgIFeD6IHmgwkkBFz6FFC4BM7q1L7qz1Bi1geIT+BYRHf2SjPlo4dnlHQzbEzdgAoL3KON1MfHYG/nhrNT99/dWq5v7OXVC2IwefCtF0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786948404; c=relaxed/simple;
	bh=TmpNhiUCxy3N7HKM/ZRnO9yV0Cb1ILfdfWpf7Xv+uEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NOxB5NpADtIpvJEjMtx10wZ99qdN4CgwjSUXWZzWJWt0o4kUE71EVWL3YSxXmN1gXP608KanQ4ws5IGUqL4G5RYf08vb8fglBKccFNIGMk4lnvH1Osj61Sfq+KhvOXCTSFwuLXML9mVvN3fAiGfryKPllXSw+33GZM+ZaeqUWmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yp/PAf99; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yp/PAf99"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so26349775e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 23:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786948401; x=1787553201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rq5oSdvSsNmbcFg7I/GhMGq8aXHgsA6J0tR2XSEZNdA=;
        b=Yp/PAf99KVxwNSRry6luPZ9WAV/6gkN1la6sgpcWMjVlv7IEUoPaWqePPyutq5hxMu
         Oi9Y2cfh8HxaLAKokGLGNST8YbwVN5Z7InAewexXf6FaqYa0kL9k433e7QGCA86y7BQu
         tz/NtA6KVTDTspkPmRTqMV6dHo1XQ/GyyqyKuVt8I5APS73I0iUKD1F3TQT+nBEPLRok
         sbEOAfV+QS1G30k/I+xugPMkaEOvQCb+4iTU/WudzKUcwOXU66ytv4WL5MxePF539ast
         ungKWlT7uit7oeWpXDaBQgo7jxr2fU+W+/zmBj097WQyrdbd86hBtNlaPOD868/zGi4i
         g9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786948401; x=1787553201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rq5oSdvSsNmbcFg7I/GhMGq8aXHgsA6J0tR2XSEZNdA=;
        b=JrkfpGFa0Ap6rmYCdER0036NN7Knwj32KECd53337HiTsBqUgegTclkLr7w5MEvijx
         Gusxk55Q7cQT+JGYBBmpEqBtLIzWIXPG8oI8MBgjLlx/CgIBEiDkK9Wyly35p3ec3ThY
         2toSjKEpxH3UdrwGU5SeXMzaqdI3MYk8wkfS8e8tPKwn2zdS12slVk2RH1P60pETOi7C
         uasAQMV/ryCrzhmbTyzYiqZ55w4SnQ7OifJifD4JjkJNFDNg/O5LxMyClDsk6sp3iBSv
         MhsK4B2ZFCPMkS7OwyDxLfv/7YaNUvcOu350Mla22IRcYLXV+tI9y5uxMmVuIMGAmavc
         ecpw==
X-Forwarded-Encrypted: i=1; AHgh+Rqgn3siuRrLCUmx3bvuhcBc1FeeVgDmSVs5P21JqnIU/gz4+BvdC7Bsqr4MGzYnEchpdB5c1rK7Ho+JRvdxlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGIO0iTuHvLXj1tcLqGZLeIPxocZIRK2XEWHRkwiBgu8GFcwqj
	O8y69HpfHbbHFNIRxcf2SDRVs5xYgLaRpZIHTXihJznew0YVFI4bj64b
X-Gm-Gg: AR+sD11epMYQiJcTGNv0Y0iHoi2wbQ5xG3NB3WZkcZoVTi5vpisBrmqVLfER7bO4xzd
	NR4a7sK8g63E+aNI5UsjErGXvIEJsBLxEFw5nuFzLPQcLBdpXsidu2YaCVtbwq5Ca/1gnOzQNf1
	UanimhjurMhLQMEp/t8V9BnzTwGAfKCKT4WwKnk6c0U+RUqsB4O9DyVA9SZyCVVlC+8iT3HB9XX
	WBtbL8d2btXKl6W3y96G9sXMdGIHUyfcurVJXv5h2vG4srceZxEpp+JntNiVcQIUcqDxcMTmHB/
	QtT2eMRlIRRkX9o/vgw/B7xkcpTTXYQEep8BzCH1n0sXPLbFeiDLAObxPMaoUerkm4o6IBNkIvu
	e4QSXEdauPNsbD74xAtoE7O8idB6Wzhkkcz8KhUvTeGmg0JlTQEWeQvFcXvfgOrWQfYQFviPbsI
	0yxJde1f/GjhKOUWS1uWwJEE4p+cP3GcEHUZQg7dnZSuSAfA4gsi5lZFNdDmdR6tYK+g==
X-Received: by 2002:a05:600c:4186:b0:499:757f:a9ba with SMTP id 5b1f17b1804b1-4998795f133mr223834405e9.9.1786948400815;
        Sun, 16 Aug 2026 23:33:20 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a3b660sm1300833f8f.15.2026.08.16.23.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 23:33:20 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Mehmet Fide <mehmet.fide@screeningeagle.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH rtw-next v5] wifi: rtw88: usb: do not log transfers lost to a mode switch
Date: Mon, 17 Aug 2026 08:33:19 +0200
Message-ID: <20260817063319.389188-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

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

  rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail,
  status: -71

Nothing is wrong here. The device re-enumerates, probes again and registers
normally, which is why rtw_usb_probe() already treats a non-zero return
from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
switch can never succeed, so the message returns on every boot and
everyone using such a port has to work out that it is harmless.

Mark the window in which the chip is expected to leave the bus and skip the
error reports for transfers that fall into it. The mark is a rtw_flags bit
set in rtw_usb_switch_mode(), so it covers both the new and the old switch
sequence, and it is cleared again right after them: the transfers that lose
the race are issued from inside the sequences, and anything that fails
later must be reported again.

Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
where the message appears exactly once per boot. With the patch both lines
are gone while the disconnect, the re-enumeration and the second firmware
load are unchanged.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
v5:
 - drop the comment on the new rtw_flags enumerator (Ping-Ke Shih)
v4:
 - track the window with a RTW_FLAG_SWITCHING_USB_MODE bit in rtw_flags
   instead of a bool in struct rtw_usb, clear it unconditionally right
   after the switch sequences so later failures are reported again, and
   drop the comment block in usb.c (Ping-Ke Shih)
 - Signed-off-by switched to my work address to match my other patches
v3:
 - set the mark in rtw_usb_switch_mode() instead of in the two switch
   helpers (Ping-Ke Shih)

 drivers/net/wireless/realtek/rtw88/main.h |  1 +
 drivers/net/wireless/realtek/rtw88/usb.c  | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c6e981ba7..6883fbd9f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -377,6 +377,7 @@ enum rtw_flags {
 	RTW_FLAG_RESTARTING,
 	RTW_FLAG_RESTART_TRIGGERING,
 	RTW_FLAG_FORCE_LOWEST_RATE,
+	RTW_FLAG_SWITCHING_USB_MODE,
 
 	NUM_OF_RTW_FLAGS,
 };
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..e13faecfb 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -64,7 +64,8 @@ static void rtw_usb_reg_sec(struct rtw_dev *rtwdev, u32 addr, __le32 *data)
 				 RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 				 t_reg, 0, data, t_len, 500);
 
-	if (status != t_len && status != -ENODEV)
+	if (status != t_len && status != -ENODEV &&
+	    !test_bit(RTW_FLAG_SWITCHING_USB_MODE, rtwdev->flags))
 		rtw_err(rtwdev, "%s: reg 0x%x, usb write %u fail, status: %d\n",
 			__func__, t_reg, t_len, status);
 }
@@ -90,7 +91,9 @@ static u32 rtw_usb_read(struct rtw_dev *rtwdev, u32 addr, u16 len)
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
 			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV &&
+	    !test_bit(RTW_FLAG_SWITCHING_USB_MODE, rtwdev->flags) &&
+	    count++ < 4)
 		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -140,7 +143,9 @@ static void rtw_usb_write(struct rtw_dev *rtwdev, u32 addr, u32 val, int len)
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 			      addr, 0, data, len, 500);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV &&
+	    !test_bit(RTW_FLAG_SWITCHING_USB_MODE, rtwdev->flags) &&
+	    count++ < 4)
 		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -1173,6 +1178,7 @@ static bool rtw_usb3_chip_new(u8 chip_id)
 static int rtw_usb_switch_mode(struct rtw_dev *rtwdev)
 {
 	u8 id = rtwdev->chip->id;
+	int ret;
 
 	if (!rtw_usb3_chip_new(id) && !rtw_usb3_chip_old(id))
 		return 0;
@@ -1189,10 +1195,16 @@ static int rtw_usb_switch_mode(struct rtw_dev *rtwdev)
 		return 0;
 	}
 
+	set_bit(RTW_FLAG_SWITCHING_USB_MODE, rtwdev->flags);
+
 	if (rtw_usb3_chip_old(id))
-		return rtw_usb_switch_mode_old(rtwdev);
+		ret = rtw_usb_switch_mode_old(rtwdev);
 	else
-		return rtw_usb_switch_mode_new(rtwdev);
+		ret = rtw_usb_switch_mode_new(rtwdev);
+
+	clear_bit(RTW_FLAG_SWITCHING_USB_MODE, rtwdev->flags);
+
+	return ret;
 }
 
 #define USB_REG_PAGE	0xf4
-- 
2.54.0

