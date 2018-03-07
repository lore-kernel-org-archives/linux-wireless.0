Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24922 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934342AbeCHPwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:52:39 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/10] staging: wilc1000: fix line over 80 char issue in handle_scan_done()
Date: Wed, 7 Mar 2018 07:43:59 +0530
Message-ID: <1520388839-7048-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_170349_176834_67AF7EFF)
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script in
handle_scan_done().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d822b15..5082ede 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -886,6 +886,7 @@ static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 	u8 abort_running_scan;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct user_scan_req *scan_req;
 
 	if (evt == SCAN_EVENT_ABORTED) {
 		abort_running_scan = 1;
@@ -908,10 +909,10 @@ static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 		return result;
 	}
 
-	if (hif_drv->usr_scan_req.scan_result) {
-		hif_drv->usr_scan_req.scan_result(evt, NULL,
-						  hif_drv->usr_scan_req.arg, NULL);
-		hif_drv->usr_scan_req.scan_result = NULL;
+	scan_req = &hif_drv->usr_scan_req;
+	if (scan_req->scan_result) {
+		scan_req->scan_result(evt, NULL, scan_req->arg, NULL);
+		scan_req->scan_result = NULL;
 	}
 
 	return result;
-- 
2.7.4
