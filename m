Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758923AbXEKDGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:06:05 -0400
Subject: [PATCH 18/19] libertas: sparse fixes
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:09:33 -0400
Message-Id: <1178852973.8607.52.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix various issues reported by sparse.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/ioctl.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index 42dfd45..a8f76c3 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -680,6 +680,7 @@ static int wlan_fwt_list_neighbor_ioctl(wlan_private * priv, struct ifreq *req)
  */
 static int wlan_fwt_cleanup_ioctl(wlan_private * priv, struct ifreq *req)
 {
+	struct iwreq *wrq = (struct iwreq *)req;
 	static struct cmd_ds_fwt_access fwt_access;
 	int ret;
 
@@ -695,7 +696,7 @@ static int wlan_fwt_cleanup_ioctl(wlan_private * priv, struct ifreq *req)
 				    (void *)&fwt_access);
 
 	if (ret == 0)
-		req->ifr_data = (char *)(le32_to_cpu(fwt_access.references));
+		wrq->u.param.value = le32_to_cpu(fwt_access.references);
 	else
 		return -EFAULT;
 
@@ -711,6 +712,7 @@ static int wlan_fwt_cleanup_ioctl(wlan_private * priv, struct ifreq *req)
  */
 static int wlan_fwt_time_ioctl(wlan_private * priv, struct ifreq *req)
 {
+	struct iwreq *wrq = (struct iwreq *)req;
 	static struct cmd_ds_fwt_access fwt_access;
 	int ret;
 
@@ -726,7 +728,7 @@ static int wlan_fwt_time_ioctl(wlan_private * priv, struct ifreq *req)
 				    (void *)&fwt_access);
 
 	if (ret == 0)
-		req->ifr_data = (char *)(le32_to_cpu(fwt_access.references));
+		wrq->u.param.value = le32_to_cpu(fwt_access.references);
 	else
 		return -EFAULT;
 
@@ -742,6 +744,7 @@ static int wlan_fwt_time_ioctl(wlan_private * priv, struct ifreq *req)
  */
 static int wlan_mesh_get_ttl_ioctl(wlan_private * priv, struct ifreq *req)
 {
+	struct iwreq *wrq = (struct iwreq *)req;
 	struct cmd_ds_mesh_access mesh_access;
 	int ret;
 
@@ -754,9 +757,8 @@ static int wlan_mesh_get_ttl_ioctl(wlan_private * priv, struct ifreq *req)
 				    cmd_option_waitforrsp, 0,
 				    (void *)&mesh_access);
 
-	if (ret == 0) {
-		req->ifr_data = (char *)(le32_to_cpu(mesh_access.data[0]));
-	}
+	if (ret == 0)
+		wrq->u.param.value = le32_to_cpu(mesh_access.data[0]);
 	else
 		return -EFAULT;
 
@@ -832,10 +834,9 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 		/* The first 4 bytes of req->ifr_data is sub-ioctl number
 		 * after 4 bytes sits the payload.
 		 */
-		subcmd = wrq->u.data.flags;	//from wpa_supplicant subcmd
-
+		subcmd = wrq->u.data.flags;
 		if (!subcmd)
-			subcmd = (int)req->ifr_data;	//from iwpriv subcmd
+			subcmd = (int)wrq->u.param.value;
 
 		switch (subcmd) {
 		case WLANSETREGION:
@@ -887,7 +888,7 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 		break;
 
 	case WLAN_SETNONE_GETONEINT:
-		switch ((int)req->ifr_data) {
+		switch (wrq->u.param.value) {
 		case WLANGETREGION:
 			pdata = (int *)wrq->u.name;
 			*pdata = (int)adapter->regioncode;
-- 
1.5.0.6



