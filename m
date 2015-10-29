Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28223 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbbJ2DQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:16:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 07/12] staging: wilc1000: wilc_wlan_init: add argument struct net_device
Date: Thu, 29 Oct 2015 12:18:47 +0900
Message-ID: <1446088732-12301-7-git-send-email-glen.lee@atmel.com> (sfid-20151029_041631_834475_1BC6B321)
In-Reply-To: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an argument dev and pass dev to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6b5f1c5..895eb60 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1096,7 +1096,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		linux_to_wlan(&nwi, wl);
 
-		ret = wilc_wlan_init(&nwi);
+		ret = wilc_wlan_init(dev, &nwi);
 		if (ret < 0) {
 			PRINT_ER("Initializing WILC_Wlan FAILED\n");
 			ret = -EIO;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 03593b7..5a480a1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1951,7 +1951,7 @@ _fail_:
 	return chipid;
 }
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp)
+int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 {
 
 	int ret = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index be972af..139cc6d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -937,7 +937,7 @@ typedef enum {
 	WID_MAX				= 0xFFFF
 } WID_T;
 
-int wilc_wlan_init(wilc_wlan_inp_t *inp);
+int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp);
 
 void wilc_bus_set_max_speed(void);
 void wilc_bus_set_default_speed(void);
-- 
1.9.1

