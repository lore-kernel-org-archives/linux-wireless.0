Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99212219E8
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786555941; cv=none; b=q1bIzYUUoi8OOId4ezSCJ89jnxpF7RTLvPBRcvoQnzE4LkWGcfIhd7621BuCuxTA/zH6lCpmmbpnFQEAaTubdmFtJDPUUdrptoXtOoukJeecTrePdjrODrTkTF6Z91HFnhbvszFyj/mBMKpI7rdT61Ca36t/s+cxaaOnH4iwmas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786555941; c=relaxed/simple;
	bh=zpw41a2GOMiTzlSJKGC60Wo41zaNwRJ8ScSgYZ3v+OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMQgn/iOiagY70kR1Zjm2Btr85GpCn6juJ0B+iouhAdFpMNZ5wrLgs0g6IpeWeGK0DyEUVqNfKZ3APaHUb1M+zlzyxb6frZstI8K8e/54JYVu6NdYGZJDa4hbH+Akuvlkp3DJ1B1Eg2sBUwtn1cwaU7GB9CvCh6JE3n3hTT8m/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5hTKJ2A; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5hTKJ2A"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49978908b35so9328225e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 10:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786555938; x=1787160738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhjYsHUqvyr8BxlLuLAP+QOYlpeqyHn1XI3lWI8kO8w=;
        b=H5hTKJ2A5yHUJmDgwE0+bSg/xlpb++uEWs35AHGTeKQkaA+xX8JOPjufAzqCCXCdoY
         5iyEoR9idImNDiO6fqF8aIP+HXNs9oSe0BiEmTcwBPt2lt1sUHZ3ZFZ9yKu/LT9YD//Q
         D1Kqnvy+SlpBzJFXqIGhDzAHmHvXZX373f/8jdPrVjrvSVKqS4GVF9sfL1mC2KVkZ6ou
         E8t2EWhWfbTdxfx/X55AVjO2jSfzmu0dieCM04MpHIZCyMT/VlunGgnytev4uUcX6+NR
         PCp1fGxbtKhTEQ42vN1qBJOc33D/xptPsFpogYFqDlkJRBD/PHonX6V9HAP55vFQABHY
         q0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786555938; x=1787160738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhjYsHUqvyr8BxlLuLAP+QOYlpeqyHn1XI3lWI8kO8w=;
        b=I4QxzkxodvCqVV9Us0KlF3rdqBwdu+PEcaVrU8Pv8qlEAzAkPGxuj4NVi+x04anyZe
         GbCBGLSpGwBysg8ePEiGegpLCkfm3NEyrFdlUodshVpi8BhU/k/LM/vEMala+5NaTfvP
         0E9GNetAtRKdEkd7avHV24EafOJjlt93Q2ChmduM875r5xjj5JnKC+t6TMPpcltIAZrk
         zNsOW90S26g2zwY6FRGYBUPR17AjLkm+jatoo3tUzT6/IM6bHzvJHRxT2+TVPpcIPVVa
         xJCaO19sY+zlTGDfw7SK5ifPN05W7roJkmxxuOBSqqX307QFWE0I8zeifSw89nZm0OiI
         B2wg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8Jb0XQ/+1qK2BdUIR/yh5jL8DIypBUChyyPX/bbV4uGWjzo7xtpLy/iJGmN8NZkMr1P+Tk4XZ2Wrsz70TDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YznFYKuNVtFOzjT+VyM4oHtGqtvLxkbqyjtEgU++95WVpg7VRQA
	UeYdJMuuQOqwcAOvQ0W/VOpn/zSCMYoFfVCbZ58Lgs6U8OLArs7FfTxThzBqZw==
X-Gm-Gg: AR+sD12zn3XXp8U5EC6qll44JflOHZJsYZTB4AAURGT03gYAuSiWU4EHrTi6cw7FzkU
	MDMDJbPbQJqrssyg6znizORnhUeGkkcV4U1Xd6hRgssZrGNJi+hAu64ioWDW8qa+KjyYeNt7JZy
	se2S8VphTOeokawdel5MmJiuk9M54Kg4oV/jbfo96oKK3UoHzvGDQ/NiE9X9DOxs6nQXZ0tWpk4
	oDFhUlzmKq51ULyh8v+o2ZFRzC+P58wlFoAxhcs6sKb35oYq571oN/anfPgvccT381OdS1UQADI
	ls/JLgm2KnxKmaNoiblR6AuPaL6lX7M+DSEYt4juWnoBr4OpfrBJ7Jk69YHOb2nOEHRNGdpiZgI
	FdUc2bUhiUImXE9X5LorELbPzHeDKBMH7PBNdbwLGhaVxtlMIypirbcxQy3Bv1VhPz1ZBL5Vtda
	YpI5T6CgZyGWhbsRQ6q2ZOpDuipxlVtVYiQKTL6lgfNzpXxgYR5KX+tJl25iaiUT/u9A==
X-Received: by 2002:a05:600c:470d:b0:499:4d4d:822a with SMTP id 5b1f17b1804b1-4997c16007cmr79194375e9.17.1786555937641;
        Wed, 12 Aug 2026 10:32:17 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b62437sm3574405e9.12.2026.08.12.10.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 10:32:16 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2] wifi: rtw88: usb: do not log transfers lost to a mode switch
Date: Wed, 12 Aug 2026 19:32:15 +0200
Message-ID: <20260812173215.4090278-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260812122858.3317577-1-mehmet.fide@gmail.com>
References: <20260812122858.3317577-1-mehmet.fide@gmail.com>
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
error reports for transfers that fall into it. rtw_usb_switch_mode_old()
disconnects the same way for RTL8812AU and RTL8814AU, so mark it there too.
The flag is never cleared because the switch always ends in a re-probe with
a fresh struct rtw_usb.

Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
where the message appears exactly once per boot. With the patch both lines
are gone while the disconnect, the re-enumeration and the second firmware
load are unchanged.

Signed-off-by: Mehmet Fide <mehmet.fide@gmail.com>
---
v2:
 - regenerated with git format-patch on top of rtw-next, as asked
 - also mark the window in rtw_usb_switch_mode_old(), which disconnects
   the same way for RTL8812AU and RTL8814AU

 drivers/net/wireless/realtek/rtw88/usb.c | 13 ++++++++++---
 drivers/net/wireless/realtek/rtw88/usb.h |  3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 64e1c3420..b60e58b35 100644
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
 
@@ -1098,6 +1098,7 @@ static int rtw_usb_switch_mode_old(struct rtw_dev *rtwdev)
 			rtw_write8(rtwdev, REG_ACLK_MON, 0x1);
 			rtw_write8(rtwdev, 0x3d, 0x3);
 			/* usb disconnect */
+			rtwusb->switching_mode = true;
 			rtw_write8(rtwdev, REG_SYS_PW_CTRL + 1, 0x80);
 			return 1;
 		}
@@ -1111,6 +1112,7 @@ static int rtw_usb_switch_mode_old(struct rtw_dev *rtwdev)
 
 static int rtw_usb_switch_mode_new(struct rtw_dev *rtwdev)
 {
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	enum usb_device_speed cur_speed;
 	u8 id = rtwdev->chip->id;
 	bool can_switch;
@@ -1151,6 +1153,11 @@ static int rtw_usb_switch_mode_new(struct rtw_dev *rtwdev)
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

