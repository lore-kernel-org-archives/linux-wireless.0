Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36809 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:35 -0400
Received: by mail-pa0-f67.google.com with SMTP id fg1so9133268pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:34 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/6] staging: wilc1000: remove unused struct set_mac_addr
Date: Mon, 13 Jun 2016 08:28:13 +0900
Message-Id: <20160612232815.12112-4-chaehyun.lim@gmail.com> (sfid-20160613_012838_743611_B5A50260)
In-Reply-To: <20160612232815.12112-1-chaehyun.lim@gmail.com>
References: <20160612232815.12112-1-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct set_mac_addr is not used anymore, so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 drivers/staging/wilc1000/host_interface.h | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ea5cb2d..96821f6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -181,7 +181,6 @@ union message_body {
 	struct drv_handler drv;
 	struct set_multicast multicast_info;
 	struct op_mode mode;
-	struct set_mac_addr set_mac_info;
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8d2dd0d..ddfea29 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -224,10 +224,6 @@ struct op_mode {
 	u32 mode;
 };
 
-struct set_mac_addr {
-	u8 mac_addr[ETH_ALEN];
-};
-
 struct get_mac_addr {
 	u8 *mac_addr;
 };
-- 
2.8.4

