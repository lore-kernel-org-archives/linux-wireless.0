Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54811 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbeCUTTo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 15:19:44 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: check for kmalloc allocation failures
Date: Wed, 21 Mar 2018 19:19:41 +0000
Message-Id: <20180321191941.4126-1-colin.king@canonical.com> (sfid-20180321_201957_198343_1D6D9C70)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There are three kmalloc allocations that are not null checked which
potentially could lead to null pointer dereference issues. Fix this
by adding null pointer return checks.

Detected by CoverityScan, CID#1466025-27 ("Dereference null return")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5082ede720f0..9b9b86654958 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -944,6 +944,10 @@ static s32 handle_connect(struct wilc_vif *vif,
 
 	if (conn_attr->bssid) {
 		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
+		if (!hif_drv->usr_conn_req.bssid) {
+			result = -ENOMEM;
+			goto error;
+		}
 		memcpy(hif_drv->usr_conn_req.bssid, conn_attr->bssid, 6);
 	}
 
@@ -951,6 +955,10 @@ static s32 handle_connect(struct wilc_vif *vif,
 	if (conn_attr->ssid) {
 		hif_drv->usr_conn_req.ssid = kmalloc(conn_attr->ssid_len + 1,
 						     GFP_KERNEL);
+		if (!hif_drv->usr_conn_req.ssid) {
+			result = -ENOMEM;
+			goto error;
+		}
 		memcpy(hif_drv->usr_conn_req.ssid,
 		       conn_attr->ssid,
 		       conn_attr->ssid_len);
@@ -961,6 +969,10 @@ static s32 handle_connect(struct wilc_vif *vif,
 	if (conn_attr->ies) {
 		hif_drv->usr_conn_req.ies = kmalloc(conn_attr->ies_len,
 						    GFP_KERNEL);
+		if (!hif_drv->usr_conn_req.ies) {
+			result = -ENOMEM;
+			goto error;
+		}
 		memcpy(hif_drv->usr_conn_req.ies,
 		       conn_attr->ies,
 		       conn_attr->ies_len);
-- 
2.15.1
