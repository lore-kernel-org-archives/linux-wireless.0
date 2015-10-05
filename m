Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8728 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbJEG0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/18] staging: wilc1000: remove typedef from tstrHostIFwepAttr
Date: Mon, 5 Oct 2015 15:25:42 +0900
Message-ID: <1444026353-29024-7-git-send-email-tony.cho@atmel.com> (sfid-20151005_082650_480682_E89A24C2)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHostIFwepAttr.
And rename it to host_if_wep_attr.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f4c5ec3..87866c4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -97,7 +97,7 @@ typedef struct _tstrHostIFwpaAttr {
 
 
 /*!
- *  @struct             tstrHostIFwepAttr
+ *  @struct             host_if_wep_attr
  *  @brief		Structure to hold Host IF Scan Attributes
  *  @details
  *  @todo
@@ -106,14 +106,13 @@ typedef struct _tstrHostIFwpaAttr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFwepAttr {
+struct host_if_wep_attr {
 	u8 *pu8WepKey;
 	u8 u8WepKeylen;
 	u8 u8Wepidx;
 	u8 u8mode;
 	enum AUTHTYPE tenuAuth_type;
-
-} tstrHostIFwepAttr;
+};
 
 /*!
  *  @struct             host_if_key_attr
@@ -126,7 +125,7 @@ typedef struct _tstrHostIFwepAttr {
  *  @version		1.0
  */
 union host_if_key_attr {
-	tstrHostIFwepAttr strHostIFwepAttr;
+	struct host_if_wep_attr strHostIFwepAttr;
 	tstrHostIFwpaAttr strHostIFwpaAttr;
 	tstrHostIFpmkidAttr strHostIFpmkidAttr;
 };
-- 
1.9.1

