Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36016 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753907AbdCBQsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 11:48:22 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging:wilc1000:host_interface: Integrated two 'if' statements to a single 'if' statement
Date: Thu,  2 Mar 2017 17:38:05 +0200
Message-Id: <1488469085-9033-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_175525_679901_17AC220A)
In-Reply-To: <1488469029-8918-1-git-send-email-geo.emmnl@gmail.com>
References: <1488469029-8918-1-git-send-email-geo.emmnl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unnecessary 'if' statement and integrated the condition to the
previous 'if' statement.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bbe1a09..4936e80 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1355,13 +1355,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 					} else {
 						strConnectInfo.status = pstrConnectRespInfo->status;

-						if (strConnectInfo.status == SUCCESSFUL_STATUSCODE) {
-							if (pstrConnectRespInfo->ies) {
-								strConnectInfo.resp_ies_len = pstrConnectRespInfo->ies_len;
-								strConnectInfo.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
-								memcpy(strConnectInfo.resp_ies, pstrConnectRespInfo->ies,
-								       pstrConnectRespInfo->ies_len);
-							}
+						if (strConnectInfo.status == SUCCESSFUL_STATUSCODE && pstrConnectRespInfo->ies) {
+							strConnectInfo.resp_ies_len = pstrConnectRespInfo->ies_len;
+							strConnectInfo.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
+							memcpy(strConnectInfo.resp_ies, pstrConnectRespInfo->ies,
+							       pstrConnectRespInfo->ies_len);
 						}

 						if (pstrConnectRespInfo) {
--
2.1.4
