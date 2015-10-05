Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8774 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/18] staging: wilc1000: remove typedef from tstrHostIFwpaAttr
Date: Mon, 5 Oct 2015 15:25:43 +0900
Message-ID: <1444026353-29024-8-git-send-email-tony.cho@atmel.com> (sfid-20151005_082657_525745_5C388B39)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHostIFwpaAttr.
And rename it to host_if_wpa_attr.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 87866c4..b5de66a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -76,7 +76,7 @@ struct cfg_param_attr {
 };
 
 /*!
- *  @struct             tstrHostIFwpaAttr
+ *  @struct             host_if_wpa_attr
  *  @brief		Structure to hold Host IF Scan Attributes
  *  @details
  *  @todo
@@ -85,7 +85,7 @@ struct cfg_param_attr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFwpaAttr {
+struct host_if_wpa_attr {
 	u8 *pu8key;
 	const u8 *pu8macaddr;
 	u8 *pu8seq;
@@ -93,7 +93,7 @@ typedef struct _tstrHostIFwpaAttr {
 	u8 u8keyidx;
 	u8 u8Keylen;
 	u8 u8Ciphermode;
-} tstrHostIFwpaAttr;
+};
 
 
 /*!
@@ -126,7 +126,7 @@ struct host_if_wep_attr {
  */
 union host_if_key_attr {
 	struct host_if_wep_attr strHostIFwepAttr;
-	tstrHostIFwpaAttr strHostIFwpaAttr;
+	struct host_if_wpa_attr strHostIFwpaAttr;
 	tstrHostIFpmkidAttr strHostIFpmkidAttr;
 };
 
-- 
1.9.1

