Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F732AE7A
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786942952; cv=none; b=Q3qCjCwNKW0QlZoNVba8mlorRPg2QTQ9SrLPZK63KyDeLG6kUMDodAf2dX0O4WtHHjfaAcK5EBM6XWtv/aPvw1+NRm6m57GKCFhL6ixd2a+zJNg/q4zClWLAx1xZT7P8KJkD4csEspjnHBRZhJ+hriS4LQlt+p3WktsURCVrpIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786942952; c=relaxed/simple;
	bh=SspijwVzDBsBd/VcAy28jU4tojv0cvmZ3B2PY7Gw1Y0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EDZpSR+s2Z3FGGQ68AGHUvquHBkFWNOOJP6rB8CfL9od9UEzzl90RT5oqlSCD9k77pe6Px1HmA9YdprISyvTbWe7+5r2LBsOs1DDlTIHWPL2kebxuP+ON//KEVA8kKVzZx4OOlXuBj3/2xSAewzjqDjnCiHFioqOZQbj/zoXq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeRbfUZd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeRbfUZd"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so3103482f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 22:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786942948; x=1787547748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bM6zJvIkLc4mi35Ff0I0FYIQvD9I7bAsj0tf9mPJSUc=;
        b=LeRbfUZdy3+wkT90r6zgwUMSeHOI9Gsv4yqky87pjhtEOYZf8rQ2aHQVG2flZu99T7
         16LYI+dRDvFfl4r3nP8XErLeQx7H1iVhGJ0QnIvwtw2AdWyWYMmEYY9lhloRsDE0rqj5
         j49zfEexHo2DthVkA2cKAH2d0QYNX8Yke//Tlpw2tYRwHNbz0FvRw8qdY3pR4vn4H82g
         6A4VL6oRcXk5N4ci9iVQqOzYJvddBU2mbvt0e2wCB9VnO98ycxZ0ND23mGZfWCLp820N
         g4fm6nCZUF8AIjQz6gRHfkEn5lnliUJi+fwlLu0FuVtmXOf5+O1sWDp6xLdnCWM/v8PQ
         Ii7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786942948; x=1787547748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bM6zJvIkLc4mi35Ff0I0FYIQvD9I7bAsj0tf9mPJSUc=;
        b=K1Yyv83PCQ+wl+Txlt9LUY7GGZCZx0Em/DkKpmowGYpsKaMCVqja8T0+uEYh3hymzs
         ij5qxCy8N/cHKxKKYMCPkvMO9/vK/rN4GStUSay5EylcEu84UI0KrieSosb1bJtPbbO8
         z1VsnK9kBjdVNre4AwFmg7bbBmDH7O5MTGYN9Q/jAs7CSGAMlH5T6avzFHULbKhLbLlH
         MEEllLEXmf0GF62z4OPSEhujvDrFwV36ZItecri95SD8udipfCHX8fjRPGCWHH+RSr0M
         MdZt+k0W0pdZsNXX0FC0Kk4tXutLR2AXKrMHceJ2j36seyLvaTmGyL1OOpaR+lbEuyF9
         OjHA==
X-Gm-Message-State: AOJu0Yz/sIrnmBwst5kblTRx9SAjbQkLywUqG0Dn59oLOhOhgtInopxe
	sdIRAnnChJqdSMOQx/wjCiKbedTKK/9D+x1CZYST0Cub6UXdrRMiUxpRBZnrOQ==
X-Gm-Gg: AR+sD12zADPbe5gheLH258+kQ9neSqqqVV7Qk5Q/D/pUQpO2soL+mIrSqnaqd5Iln8B
	qjeoR5afgc/z4kvc0n+2dLF+Z5CqMuebwYqYZWZnfCAVdK4C2antIOo/tM+Wf8w24iKifkGj1Bn
	HwQYFxj1jlTuAohcblRWPWsN1GlC4nLjwbJjnmKvziR0a39XVryd1Q1JqGYup8rSojImWO5kToO
	xRNUOSrlifBOb7qe1VIkni31Rtei/tzhetiaeMds6Nd10XjK/IUfmf43UhhZkKEfEZPFXssVKeW
	F8q2WZSPxZFv4khn6Zs7OtHf4YoPe2w044htaWU2hM7qv9Kp7BfSZWoIMId+TW+Auoh2jooy0uf
	GxEj2yPe04dk38SgDECq/7doEXrNfEj/NxqTHBTRPvHV2ch7MutNJMqJ9xwDir41wxGUTdwLJli
	dRWb1toDMCvVgEc7Frceir+bDjDe3SwDHWPX65/3yY30MPdPUBBLa7fDeyq2lcBdsCgWk=
X-Received: by 2002:a05:6000:2409:b0:47f:71a6:970e with SMTP id ffacd0b85a97d-481606f495dmr33419869f8f.2.1786942948402;
        Sun, 16 Aug 2026 22:02:28 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a7bc6esm989920f8f.19.2026.08.16.22.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 22:02:27 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: linux-wireless@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH rtw-next v4] wifi: rtw88: usb: do not log transfers lost to a mode switch
Date: Mon, 17 Aug 2026 07:02:27 +0200
Message-ID: <20260817050227.363362-1-mehmet.fide@gmail.com>
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
v4:
 - track the window with a RTW_FLAG_SWITCHING_USB_MODE bit in rtw_flags
   instead of a bool in struct rtw_usb, clear it unconditionally right
   after the switch sequences so later failures are reported again, and
   drop the comment block in usb.c (Ping-Ke Shih)
 - Signed-off-by switched to my work address to match my other patches
v3:
 - set the mark in rtw_usb_switch_mode() instead of in the two switch
   helpers (Ping-Ke Shih)

 drivers/net/wireless/realtek/rtw88/main.h |  2 ++
 drivers/net/wireless/realtek/rtw88/usb.c  | 22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c6e981ba7..fc3fb617c 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -377,6 +377,8 @@ enum rtw_flags {
 	RTW_FLAG_RESTARTING,
 	RTW_FLAG_RESTART_TRIGGERING,
 	RTW_FLAG_FORCE_LOWEST_RATE,
+	/* USB mode switch: the chip re-enumerates, transfers may be cut off */
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

