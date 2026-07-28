Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC05281369
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785203748; cv=none; b=gFgsxRZYdcvSxo3QL5I+OTYeU7kMFkYk1jGk/jVGW5xMdRC0uOSnyX9EGNU0Tb17AWORdYx1t1c/ZuVjcW00NnI94FOzWifRy0LXoHw8Jybv/3ZG03HgBxLxG2Hm8mE1PJ62Z5WP3aYnLLCSKOtVldbTdBXps4ttoJoByfY3qLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785203748; c=relaxed/simple;
	bh=h2q12AUp9O/kTBbsKAFQ2FqqupG7nckpin9iw1wX3a0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VvGhbN8wKIy7q3PXF2rkSirJHQSUGQvG7W95sLdBhSn8rkEguUQw0KHwZ94wtuTXmQNSfSngtwgb035WGAJ9Vfriwem73+MaSiNkhyvQIwye8/5QO3x0LfVTVHFPYtHRzZiCn1rB7u38CQCkeCI8dOdNmsS4/g3jgjJ3esNyjks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qxzbf/Uj; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qxzbf/Uj"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-381216921aaso3252028a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 18:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785203745; x=1785808545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f0SM9LlpHTwCaw/SjDIWrZU/9QgTvcwL2gvLlLgdQ7g=;
        b=Qxzbf/UjLLbd4zZR+1Ri4Padmej4bP0GJYTHFNJ/FHwmOBNrB81o8IeL6JlWqUJNG8
         CtL2wI3yTe/b+a/kP/iYL4qitwNhWqv+/G4lAOOIwusg0dFAMhUWkRZjlOQbvoo/mNKN
         A9o20Y5+yEQEObhRYzUmnJnk8aDemmqs1/4fZzyoEeWN8dHpDYHBBp0NSrFiPJG/XhYT
         Yka1QbQGfpqS9oxWkWemmBOw413sqv791v2lFchvhwcUp9WdLG4TERN5o6Q3nybuTZpN
         FD3h8NupruxYoaroY346Yit7m726ZjWGks0tl+akZJ7D3kU+11dlUHnD9XtF2mnpXZTa
         xSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785203745; x=1785808545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0SM9LlpHTwCaw/SjDIWrZU/9QgTvcwL2gvLlLgdQ7g=;
        b=jQ9w4nrGzO7CeyG6WhxQdtpk2kg/GJk2jn67dE415vH2O9IOP+rkJXl8hJyxmjWkfp
         UXXfJm/N7/dPtbcXpLdg+k5UCSthuwhvZiTau/s+1oep+M8JY9x6k3C4VPCuU6xODrQT
         /ov36OpfzGDwdVQwSN65aMbzWoLEk4B9mBZ5VU6QcogZAuJILMimumJSWMszZFu+na6P
         7mX78eHhJlDoZgeqqyCMZoYNFS7eUjROhYF4uALUzUELpHrqhpFHYZUCXnt1g2gfTFdU
         1SODGImCil7VXMVwYPCjocQOybD9UZ9rOWIgwNzcRcCR0O57Bjs/ONOST9U6ITLztG2h
         83lw==
X-Forwarded-Encrypted: i=1; AHgh+RrDWceveiiITa/wBVp/UQ7Mo53JHygO7+3UdpX9CRXb7a22U4I5ol2V09CZEjGUptKpKlRiVDB8dDZV6QXDsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJTZZy6OL47kiymkkF2H4py4owDTSNnvTn2y+77WhqyxVAsjza
	61WGUoLEKDPhQroHfHJMwaPT+UGxehHwK5PqsMehuYDeu+0xk26PmwDW
X-Gm-Gg: AR+sD100SIh86So9bYrLV6tA/NM3zWi1tHF7bBnutl29BpDSXB3icsgQ8WV4YhN9CwE
	7ekxxjxWs/t9wfA3nIxelRoYWEvN6ecUk7GM+/82OyGF9onN4SboHToKtGriukNACByrWqlgfho
	GY0gm3YlZJZQKJsEK05iTZfvfadro0Yb1dBTV8gZuAe6SsjyeCxifNcMDS9YWuF/E8O0GEYU9e0
	9ssbbjKAWlSl3X0ebp3KW+v6n9bFN9d3ZBwUbGC0fq6jndFCNfiNqJKhh9Ca4/3ZcPaYmaJ1mSJ
	5hI8b4NzM5nSPubyspyR5SNTzj2ZzknH4DNb+9O4upK72qLXjP7YoPOwQA34sNpVi41WblGS8Gv
	7oGkEd9bf80RccvcHpN1h1dciMncxXKprSwQ+3VoEGD1IyzdCenUNsxhKJ4WMarAj4iK5/f4B5y
	MQHb2Xfjvld017FJJS2ZFR
X-Received: by 2002:a17:90b:4cc2:b0:38f:474f:e77 with SMTP id 98e67ed59e1d1-38f6a45e1cemr358573a91.37.1785203744656;
        Mon, 27 Jul 2026 18:55:44 -0700 (PDT)
Received: from cyh-System-Product-Name.. ([129.227.183.200])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f64150874sm529230a91.16.2026.07.27.18.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 18:55:44 -0700 (PDT)
From: yhchen312@gmail.com
To: pkshih@realtek.com
Cc: damon.chen@realtek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Yuhang.chen" <yhchen312@gmail.com>
Subject: [PATCH] wifi: rtw89: 8852be: add .shutdown callback to quiesce device on reboot
Date: Tue, 28 Jul 2026 09:54:35 +0800
Message-Id: <20260728015435.1585953-1-yhchen312@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Yuhang.chen" <yhchen312@gmail.com>

Since hardware rfkill polling was introduced, warm reboot on arm64
platforms can panic with an asynchronous SError when the rfkill poll
workqueue reads a register while the PCIe link is being torn down:

  SError Interrupt on CPU8, code 0x00000000be000011 -- SError
  Workqueue: events_power_efficient rfkill_poll [rfkill]
  Call trace:
    rtw89_pci_ops_read8+0x94/0x160 [rtw89_pci]
    rtw89_core_rfkill_poll+0x50/0x1e0 [rtw89_core]
    rtw89_ops_rfkill_poll+0x40/0x68 [rtw89_core]
    ieee80211_rfkill_poll+0x3c/0x70 [mac80211]
    cfg80211_rfkill_poll+0x40/0x2a0 [cfg80211]
    rfkill_poll+0x30/0x88 [rfkill]
  Kernel panic - not syncing: Asynchronous SError Interrupt

During device_shutdown() the 8852BE PCI driver has no .shutdown
callback, so the device is never quiesced and the rfkill polling keeps
running.  Once the platform brings the PCIe link down, the next MMIO
read targets a non-responding device and is reported as an asynchronous
SError, which is fatal on arm64.

Add a .shutdown callback that runs the existing remove path to stop the
rfkill polling, free interrupts and power down the chip before the link
goes away.  A NULL drvdata check guards the case where probe did not
fully complete.

Fixes: 0b38e6277aed ("wifi: rtw89: add support for hardware rfkill")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhang.chen <yhchen312@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852be.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852be.c b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
index 5bc0a6a99d1d..9aebecbac067 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -92,11 +92,20 @@ static const struct pci_device_id rtw89_8852be_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, rtw89_8852be_id_table);
 
+static void rtw89_8852be_shutdown(struct pci_dev *pdev)
+{
+	if (!pci_get_drvdata(pdev))
+		return;
+
+	rtw89_pci_remove(pdev);
+}
+
 static struct pci_driver rtw89_8852be_driver = {
 	.name		= "rtw89_8852be",
 	.id_table	= rtw89_8852be_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown       = rtw89_8852be_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
-- 
2.34.1

