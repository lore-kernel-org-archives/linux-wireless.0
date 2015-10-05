Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8696 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/18] staging: wilc1000: remove typedef from tuniHostIFkeyAttr
Date: Mon, 5 Oct 2015 15:25:41 +0900
Message-ID: <1444026353-29024-6-git-send-email-tony.cho@atmel.com> (sfid-20151005_082644_230534_3F1DEE51)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef from the union tuniHostIFkeyAttr.
And rename it to host_if_key_attr.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2e71505..f4c5ec3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -116,7 +116,7 @@ typedef struct _tstrHostIFwepAttr {
 } tstrHostIFwepAttr;
 
 /*!
- *  @struct             tuniHostIFkeyAttr
+ *  @struct             host_if_key_attr
  *  @brief		Structure to hold Host IF Scan Attributes
  *  @details
  *  @todo
@@ -125,11 +125,11 @@ typedef struct _tstrHostIFwepAttr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef union _tuniHostIFkeyAttr {
+union host_if_key_attr {
 	tstrHostIFwepAttr strHostIFwepAttr;
 	tstrHostIFwpaAttr strHostIFwpaAttr;
 	tstrHostIFpmkidAttr strHostIFpmkidAttr;
-} tuniHostIFkeyAttr;
+};
 
 /*!
  *  @struct             key_attr
@@ -144,7 +144,7 @@ typedef union _tuniHostIFkeyAttr {
 struct key_attr {
 	enum KEY_TYPE enuKeyType;
 	u8 u8KeyAction;
-	tuniHostIFkeyAttr uniHostIFkeyAttr;
+	union host_if_key_attr uniHostIFkeyAttr;
 };
 
 
-- 
1.9.1

