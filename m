Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45263 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0LMLkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:39 -0500
Received: by mail-ey0-f171.google.com with SMTP id 5so4064715eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:38 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/17] rt2x00: Fix firmware loading regression on x86_64.
Date: Mon, 13 Dec 2010 12:39:39 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131238.50510.IvDoorn@gmail.com> <201012131239.13818.IvDoorn@gmail.com>
In-Reply-To: <201012131239.13818.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131239.40933.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wolfgang Kufner <wolfgang.kufner@gmail.com>

Commit 6175ddf06b6172046a329e3abfd9c901a43efd2e changes the way
memcpy_toio() works for x86_64, causing firmware loading to fail for
some Ralink WLAN devices with the rt2800pci driver since linux 2.6.34.
This causes the log message: "phy0 -> rt2800pci_load_firmware: Error -
PBF system register not ready.".

Fix this by using __iowrite32_copy instead of memcpy_toio().

Signed-off-by: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index b854d62..746ce8f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -64,7 +64,7 @@ static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 						 const void *value,
 						 const u32 length)
 {
-	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
+	__iowrite32_copy(rt2x00dev->csr.base + offset, value, length >> 2);
 }
 
 /**
-- 
1.7.2.3

