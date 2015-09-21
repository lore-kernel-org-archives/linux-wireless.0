Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36634 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbIUHrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:47:43 -0400
Received: by lbcao8 with SMTP id ao8so46646306lbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:47:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] ssb: make ssb_sdio_switch_core static
Date: Mon, 21 Sep 2015 09:47:19 +0200
Message-Id: <1442821640-14582-2-git-send-email-zajec5@gmail.com> (sfid-20150921_094747_480765_1604CE88)
In-Reply-To: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's used locally only.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/sdio.c        | 2 +-
 drivers/ssb/ssb_private.h | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
index b2d36f7..2278e43 100644
--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -200,7 +200,7 @@ out:
 }
 
 /* host must be already claimed */
-int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev)
+static int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev)
 {
 	u8 coreidx = dev->core_index;
 	u32 sbaddr;
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index eb507a5..1d2256e 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -132,7 +132,6 @@ extern int ssb_sdio_get_invariants(struct ssb_bus *bus,
 				     struct ssb_init_invariants *iv);
 
 extern u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset);
-extern int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev);
 extern int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx);
 extern int ssb_sdio_hardware_setup(struct ssb_bus *bus);
 extern void ssb_sdio_exit(struct ssb_bus *bus);
@@ -144,11 +143,6 @@ static inline u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset)
 {
 	return 0;
 }
-static inline int ssb_sdio_switch_core(struct ssb_bus *bus,
-					 struct ssb_device *dev)
-{
-	return 0;
-}
 static inline int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
 {
 	return 0;
-- 
1.8.4.5

