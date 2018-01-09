Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:58073 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbeAIJKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 04:10:19 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: removed typedef from enum BSSTYPE_T
Date: Tue, 9 Jan 2018 14:37:42 +0530
Message-ID: <1515488862-8201-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180109_101027_229265_9286901D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from enum BSSTYPE_T and
rename it to bss_types.

It fixes "WARNING: do not add new typdefs" warning
reported by checkpatch.pl.

Signed-off-by: ajaysk <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d69248a..4ff1a59 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -202,7 +202,7 @@ struct host_if_msg {
 };
 
 struct join_bss_param {
-	BSSTYPE_T bss_type;
+	enum bss_types bss_type;
 	u8 dtim_period;
 	u16 beacon_period;
 	u16 cap_info;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index c1693cf..2baf6c4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -85,11 +85,11 @@ typedef enum {
 	P2P_IE			= 221,
 } BEACON_IE;
 
-typedef enum {
+enum bss_types {
 	INFRASTRUCTURE		= 0,
 	INDEPENDENT,
 	AP,
-} BSSTYPE_T;
+};
 
 typedef enum {
 	RATE_AUTO		= 0,
-- 
2.7.4
