Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:48273 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1EQHMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:12:52 -0400
Received: by pxi16 with SMTP id 16so161947pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:12:52 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8088.821033.503922@gargle.gargle.HOWL> (sfid-20110517_091255_842472_10733E33)
Date: Tue, 17 May 2011 12:41:20 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/8] ath9k_htc: Fix mode selection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Remove all the unsupported modes like FH, TURBO etc.
Since this requires a FW update, increase the fw version to 1.3

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.h      |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h          |   11 ++---------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 +++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 2bdcdbc..0d6ff79 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -18,7 +18,7 @@
 #define HTC_USB_H
 
 #define MAJOR_VERSION_REQ 1
-#define MINOR_VERSION_REQ 2
+#define MINOR_VERSION_REQ 3
 
 #define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index dfc7a98..5ec214c 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -46,15 +46,8 @@ extern struct ieee80211_ops ath9k_htc_ops;
 extern int htc_modparam_nohwcrypt;
 
 enum htc_phymode {
-	HTC_MODE_AUTO		= 0,
-	HTC_MODE_11A		= 1,
-	HTC_MODE_11B		= 2,
-	HTC_MODE_11G		= 3,
-	HTC_MODE_FH		= 4,
-	HTC_MODE_TURBO_A	= 5,
-	HTC_MODE_TURBO_G	= 6,
-	HTC_MODE_11NA		= 7,
-	HTC_MODE_11NG		= 8
+	HTC_MODE_11NA		= 0,
+	HTC_MODE_11NG		= 1
 };
 
 enum htc_opmode {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5aa104f..6065c2f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -26,7 +26,7 @@ static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 {
 	enum htc_phymode mode;
 
-	mode = HTC_MODE_AUTO;
+	mode = -EINVAL;
 
 	switch (ichan->chanmode) {
 	case CHANNEL_G:
@@ -45,6 +45,8 @@ static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 		break;
 	}
 
+	WARN_ON(mode < 0);
+
 	return mode;
 }
 
-- 
1.7.5.1

