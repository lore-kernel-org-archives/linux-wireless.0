Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33553 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbIIFQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 01:16:54 -0400
Received: by lbcjc2 with SMTP id jc2so64706116lbc.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 22:16:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: probe bcma core (device) rev 0x15
Date: Wed,  9 Sep 2015 07:16:42 +0200
Message-Id: <1441775802-1230-1-git-send-email-zajec5@gmail.com> (sfid-20150909_071703_499096_D1EEF246)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OpenWrt user reported b43 doesn't probe wireless core on SoC BCM5356A1:
[    0.000000] bcma: bus0: Found chip with id 0x5356, rev 0x01 and package 0x04
it is because this chip uses different 802.11 core revison than others:
[    0.000000] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x15, class 0x0)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2849070..71d3e9a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -120,6 +120,7 @@ MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if over
 #ifdef CONFIG_B43_BCMA
 static const struct bcma_device_id b43_bcma_tbl[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x11, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x15, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1C, BCMA_ANY_CLASS),
-- 
1.8.4.5

