Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8680 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/18] staging: wilc1000: remove typedef from tenuKeyType
Date: Mon, 5 Oct 2015 15:25:40 +0900
Message-ID: <1444026353-29024-5-git-send-email-tony.cho@atmel.com> (sfid-20151005_082638_162357_64DE1E94)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef from the enum tenuKeyType.
And rename it to KEY_TYPE.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bcfbb91..2e71505 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -142,7 +142,7 @@ typedef union _tuniHostIFkeyAttr {
  *  @version		1.0
  */
 struct key_attr {
-	tenuKeyType enuKeyType;
+	enum KEY_TYPE enuKeyType;
 	u8 u8KeyAction;
 	tuniHostIFkeyAttr uniHostIFkeyAttr;
 };
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 779ff99..856cab0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -172,12 +172,12 @@ typedef enum {
 	CONN_DISCONN_EVENT_FORCE_32BIT		= 0xFFFFFFFF
 } tenuConnDisconnEvent;
 
-typedef enum {
+enum KEY_TYPE {
 	WEP,
 	WPARxGtk,
 	WPAPtk,
 	PMKSA,
-} tenuKeyType;
+};
 
 
 /*Scan callBack function definition*/
-- 
1.9.1

