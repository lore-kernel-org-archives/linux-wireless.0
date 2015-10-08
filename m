Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:32621 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbbJHBuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 21:50:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/14] staging: wilc1000: remove typedef from tstrHiddenNetworkInfo
Date: Thu, 8 Oct 2015 10:49:12 +0900
Message-ID: <1444268961-7551-5-git-send-email-tony.cho@atmel.com> (sfid-20151008_035010_766794_51A230FC)
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHiddenNetworkInfo with
related comments and renames it to hidden_net_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 408bd48..401a7f6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -212,15 +212,13 @@ struct rcvd_net_info {
 	u32 u32Length;
 };
 
-typedef struct _tstrHiddenNetworkInfo {
+struct hidden_net_info {
 	u8  *pu8ssid;
 	u8 u8ssidlen;
-
-} tstrHiddenNetworkInfo;
+};
 
 struct hidden_network {
-	/* MAX_SSID_LEN */
-	tstrHiddenNetworkInfo *pstrHiddenNetworkInfo;
+	struct hidden_net_info *pstrHiddenNetworkInfo;
 	u8 u8ssidnum;
 };
 
-- 
1.9.1

