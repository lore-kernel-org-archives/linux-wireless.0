Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34150 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbIUHrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:47:46 -0400
Received: by lahg1 with SMTP id g1so62922167lah.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:47:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] ssb: drop declaration of non existing ssb_sdio_hardware_setup
Date: Mon, 21 Sep 2015 09:47:20 +0200
Message-Id: <1442821640-14582-3-git-send-email-zajec5@gmail.com> (sfid-20150921_094749_323331_95F157BE)
In-Reply-To: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/ssb_private.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 1d2256e..426c805 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -133,7 +133,6 @@ extern int ssb_sdio_get_invariants(struct ssb_bus *bus,
 
 extern u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset);
 extern int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx);
-extern int ssb_sdio_hardware_setup(struct ssb_bus *bus);
 extern void ssb_sdio_exit(struct ssb_bus *bus);
 extern int ssb_sdio_init(struct ssb_bus *bus);
 
@@ -147,10 +146,6 @@ static inline int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
 {
 	return 0;
 }
-static inline int ssb_sdio_hardware_setup(struct ssb_bus *bus)
-{
-	return 0;
-}
 static inline void ssb_sdio_exit(struct ssb_bus *bus)
 {
 }
-- 
1.8.4.5

