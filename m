Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12219 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbJLH5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:57:23 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 08/41] staging: wilc1000: remove typedef from tenuWIDtype
Date: Mon, 12 Oct 2015 16:55:42 +0900
Message-ID: <1444636575-2486-8-git-send-email-tony.cho@atmel.com> (sfid-20151012_095733_728172_A93CC7A5)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef from the enum tenuWIDtype
and rename it to WID_TYPE.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 drivers/staging/wilc1000/host_interface.h   | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 306efc9..02faf58 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -72,7 +72,7 @@ typedef enum {
 
 struct wid {
 	u16 u16WIDid;
-	tenuWIDtype enuWIDtype;
+	enum WID_TYPE enuWIDtype;
 	s32 s32ValueSize;
 	s8      *ps8WidVal;
 };
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6f6362e..3ab9220 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -59,7 +59,7 @@
 
 typedef struct {
 	u16 cfg_wid;
-	WID_TYPE_T cfg_type;
+	enum WID_TYPE cfg_type;
 	s8     *pu8Para;
 } cfg_param_t;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8fec64d..be972af 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -315,7 +315,7 @@ typedef enum {
 	SW_TRIGGER_ABORT,
 } TX_ABORT_OPTION_T;
 
-typedef enum {
+enum WID_TYPE {
 	WID_CHAR		= 0,
 	WID_SHORT		= 1,
 	WID_INT			= 2,
@@ -326,8 +326,7 @@ typedef enum {
 	WID_ADR			= 7,
 	WID_UNDEF		= 8,
 	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
-
-} WID_TYPE_T, tenuWIDtype;
+};
 
 typedef enum {
 	WID_NIL				= 0xffff,
-- 
1.9.1

