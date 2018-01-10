Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:13616 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964979AbeAJLN5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 06:13:57 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 1/9] staging: wilc1000: removed typedef from enum BSSTYPE_T
Date: Wed, 10 Jan 2018 16:42:43 +0530
Message-ID: <1515582771-28408-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180110_121400_818671_0E183FC0)
In-Reply-To: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
References: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from enum BSSTYPE_T and
rename it to bss_types.

It fixes "WARNING: do not add new typdefs" warning
reported by checkpatch.pl.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
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
