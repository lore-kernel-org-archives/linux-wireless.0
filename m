Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3197 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbbJMKyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 34/54] staging: wilc1000: rename pJoinParams of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:59 +0900
Message-ID: <1444733419-17679-34-git-send-email-tony.cho@atmel.com> (sfid-20151013_125423_220953_D7BFA7B9)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pJoinParams of struct connect_attr to params to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fbc48ee..4af2bd1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -118,7 +118,7 @@ struct connect_attr {
 	void *arg;
 	enum AUTHTYPE auth_type;
 	u8 ch;
-	void *pJoinParams;
+	void *params;
 };
 
 struct rcvd_async_info {
@@ -1024,7 +1024,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
-	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->pJoinParams;
+	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->params;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
 		s32Error = -ENOENT;
@@ -3616,7 +3616,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.body.con_info.ch = u8channel;
 	msg.body.con_info.result = pfConnectResult;
 	msg.body.con_info.arg = pvUserArg;
-	msg.body.con_info.pJoinParams = pJoinParams;
+	msg.body.con_info.params = pJoinParams;
 	msg.drv = hif_drv ;
 
 	if (pu8bssid != NULL) {
-- 
1.9.1

