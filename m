Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42624 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbJ1HCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:02:35 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 50/80] staging: wilc1000: rename IsHTCapable of struct user_conn_req
Date: Wed, 28 Oct 2015 16:00:10 +0900
Message-ID: <1446015640-29398-50-git-send-email-glen.lee@atmel.com> (sfid-20151028_080238_279644_964C6368)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames IsHTCapable of struct user_conn_req to ht_capable
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0b65504..008d8ba 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1143,7 +1143,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	*(pu8CurrByte++)  = ptstrJoinBssParam->uapsd_cap;
 
 	*(pu8CurrByte++)  = ptstrJoinBssParam->ht_capable;
-	hif_drv->usr_conn_req.IsHTCapable = ptstrJoinBssParam->ht_capable;
+	hif_drv->usr_conn_req.ht_capable = ptstrJoinBssParam->ht_capable;
 
 	*(pu8CurrByte++)  =  ptstrJoinBssParam->rsn_found;
 	PRINT_D(HOSTINF_DBG, "* rsn found %d*\n", *(pu8CurrByte - 1));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e5b0407..79e9e87 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -207,7 +207,7 @@ struct user_conn_req {
 	u8 *ies;
 	size_t ies_len;
 	wilc_connect_result conn_result;
-	bool IsHTCapable;
+	bool ht_capable;
 	void *u32UserConnectPvoid;
 };
 
-- 
1.9.1

