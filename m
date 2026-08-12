Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692243C054
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537744; cv=none; b=rq6aghlRUCIfxVtjE0fSYbiAoLLV31iDCb65JCtlJi3dZY61jBMQ4xMA762dBXjN3fF12zrSnJubXaUQRSN9WxPizssgOYvGoN+d8bgflwgXOwWRZhczyZ4SHXtNe7N0PXurl7SESpB8l9fcrZTPBZiwUrJCZah5NEUe/vQLnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537744; c=relaxed/simple;
	bh=f1pOTQ2VjuAxnQ9jHMFr0GMzUif++/1BFdvI2UGAn34=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NUFM8EQhv0CzvvA/YHBtgK//bY5dRy1MaUKIujdrBfW+BwfP2jf5qodRNFfx9+2qDpkB+g7Z4kQX/lpty0jvck/WoekSBb/7o0B+aAeEZRNfXP0+6HXQt2FAeMcDAAGH5JdYv7WgmvqOCXgE1oZJqq4vAM9Bp1rSVc6rp4cgHWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jM64Fc88; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jM64Fc88"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso3936675e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786537740; x=1787142540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NVmTqF598AY6DSdqutGI1TCovgwbqSdTjZQhudqgbiw=;
        b=jM64Fc883Wzgy0vLlX0x3A+xT0Yp6xp9Q1yn/h/mZLPWjsE88QdkVV1tG0Yc9DQHlh
         MAURqCDvfn03X2MniIsa3AXGM7cQqFxM2tSlHHedzQ6xOh7WKf3UyVJFtSiWcbA0U9FL
         ING+okbtMk2JzZsO1Tsz3UfzuRaB+zwwGl7+MH8qi9vLUjuFgkvu09J1Rva4ABQo0U1s
         5WStX4hMOHzBK676dppxBcLALpDWnF3s22XF+GnRdNFqimFncrtbtZDdqnL8ZRFO28SK
         VsF6f42ckmMXS6m2J6icnPUGJL6BtZtDf3uMGviWLYvWzxfBh4VyEaeIz+pnvSyZ5Otj
         fBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537740; x=1787142540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NVmTqF598AY6DSdqutGI1TCovgwbqSdTjZQhudqgbiw=;
        b=Yf/Povwi8cIQsCp+Ey3eCdUMqznV8BtpBLHBxZSaClOONQKCpI5ILGgStLkipkPphb
         QpYniPBxb2/rvTIfrDujrIJ/F0va7q+/bHG29sK0G2Iv10ve4t3RhuEF0qB0m4PhI6wn
         d30m157QIxkp0pCbQydFdzysGtHTPPk6arkS6PJzHBOrDEWwgqo537zvC7sdG4mJ+fP/
         HA2Jwzgui/fu4YEOY9QQbuIAwVlNyC+xVRBtrQ/MMVNpRXTmneplPEYfX2zDzcztU077
         HvZiBWc8Ql5gkHu3PFZ1/aPkkJOXLxJhCHBM2rYsPg3uGlRGQjRNCW4MUuOaINPwARxH
         pRsg==
X-Forwarded-Encrypted: i=1; AHgh+Rp48b/ob6TzaNPivkaQ4DDV7wH1StJ92pY1hi01EWP02YBxf6vzM+bua+u9vFqjvt8hBTV/oJ5kWLr+wwxVoA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8LC/DK+fcoBfqNvYiqxeAiOAaUuFNmwOC8AUsXFxT+VqsK8GO
	OTRlHPnkTtONGtyOxNnrZ/VxlZ8NRFJuoInMnwclqWUbKe57CzNzmUCW
X-Gm-Gg: AR+sD10U5+RDdZta1bA14910TxTrxBaVSUuBjqiwI7/0WC/QAeu5KkUYdsKp8/CW5xA
	dfbSQ5SKdBQRiA6bynOdhz6GQ9s2m2wgWjOUNmffPSt0VUvsMAGanivinW/klbhvY7X7o10m3Vq
	WCwnMYIJ5cqsYf9r8XwEsbSFF3CgnV6MYs7aLiPtun5BLl/Ko/ff8EhauXgobttQnGyex18XeTU
	wMahXujQoxTajQZzNO/yDMKp2aQyG5+gTCBzMgvJDlObQO9zNN70+RCzZS2UW1g38BQ4GWJc8AB
	6bISYe9lshVS7SyvMFvZgGfrUTSU7y7hi3wab/9W1/KNFNxUoGSJduyculxzwCsU6YYq6ZMiJkR
	pfnnqrEXb1+Bwo0xrl11MXo25dW0lfc1UyAngcON5Lid09hkLM81Z20hY9O7PYCckOV0dvXDs4g
	nc1dFh6pHENnNZui6QLFnibAK21fstJUAgPqSpUdATdpUx2dUPagknrzqbzS6tqPdSBP8kTiVC1
	P3A
X-Received: by 2002:a05:600c:8214:b0:495:63e4:7f78 with SMTP id 5b1f17b1804b1-4997c0fe741mr70766445e9.10.1786537740313;
        Wed, 12 Aug 2026 05:29:00 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997ad2d03fsm39471045e9.2.2026.08.12.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:28:59 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next] wifi: rtw88: usb: do not log transfers lost to a mode switch
Date: Wed, 12 Aug 2026 14:28:58 +0200
Message-ID: <20260812122858.3317577-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
rtw_usb_switch_mode_new(), added in commit 315c23a64e99 ("wifi: rtw88:
usb: Support USB 3 with RTL8822CU/RTL8822BU"). The chip powers off its
MAC and leaves the bus while the last control transfers of that sequence
are still in flight, so they complete with -EPROTO and the driver reports
them as errors:

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
error reports for transfers that fall into it. The flag is never cleared
because the switch always ends in a re-probe with a fresh struct rtw_usb.

Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
where the message appears exactly once per boot. With the patch both lines
are gone while the disconnect, the re-enumeration and the second firmware
load are unchanged. The tested build was 6.12.103 carrying the same change;
the hunks differ only in context.

Signed-off-by: Mehmet Fide <mehmet.fide@gmail.com>
---
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -64,7 +64,7 @@
 				 RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 				 t_reg, 0, data, t_len, 500);
 
-	if (status != t_len && status != -ENODEV)
+	if (status != t_len && status != -ENODEV && !rtwusb->switching_mode)
 		rtw_err(rtwdev, "%s: reg 0x%x, usb write %u fail, status: %d\n",
 			__func__, t_reg, t_len, status);
 }
@@ -90,7 +90,7 @@
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
 			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
 		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -140,7 +140,7 @@
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
 			      addr, 0, data, len, 500);
-	if (ret < 0 && ret != -ENODEV && count++ < 4)
+	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
 		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
 			addr, ret);
 
@@ -1111,6 +1111,7 @@
 
 static int rtw_usb_switch_mode_new(struct rtw_dev *rtwdev)
 {
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	enum usb_device_speed cur_speed;
 	u8 id = rtwdev->chip->id;
 	bool can_switch;
@@ -1151,6 +1152,11 @@
 	rtw_write32(rtwdev, REG_PAD_CTRL2, pad_ctrl2);
 	rtw_write8(rtwdev, REG_PAD_CTRL2 + 1, 4);
 
+	/* From here the chip powers off its MAC and re-enumerates, so it can
+	 * leave the bus while a control transfer is still in flight.
+	 */
+	rtwusb->switching_mode = true;
+
 	rtw_write16_set(rtwdev, REG_SYS_PW_CTRL, BIT_APFM_OFFMAC);
 	usleep_range(1000, 1001);
 	rtw_write32_set(rtwdev, REG_PAD_CTRL2, BIT_NO_PDN_CHIPOFF_V1);
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -85,6 +85,9 @@
 	struct sk_buff_head rx_free_queue;
 	struct work_struct rx_work;
 	struct work_struct rx_urb_work;
+
+	/* the chip is re-enumerating, control transfers are expected to fail */
+	bool switching_mode;
 };
 
 static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff *skb)
