Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202AbXHNLvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:51:08 -0400
Message-Id: <20070814093409.132987000@sipsolutions.net>
References: <20070814093254.021041000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:32:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] hostapd: use SIOCSIWGENIE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use SIOCSIWGENIE instead of PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-14 11:32:34.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-14 11:32:35.000000000 +0200
@@ -694,28 +694,20 @@ static int i802_set_generic_elem(const c
 				 const u8 *elem, size_t elem_len)
 {
 	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param *param;
-	u8 *buf;
-	size_t blen;
-	int ret = 0;
+	struct iwreq iwr;
 
-	blen = sizeof(*param) + elem_len;
-	buf = os_zalloc(blen);
-	if (buf == NULL)
-		return -1;
+	memset(&iwr, 0, sizeof(iwr));
 
-	param = (struct prism2_hostapd_param *) buf;
-	param->cmd = PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM;
-	param->u.set_generic_info_elem.len = elem_len;
-	memcpy(param->u.set_generic_info_elem.data, elem, elem_len);
+	os_strlcpy(iwr.ifr_name, drv->hapd->conf->iface, IFNAMSIZ);
+	iwr.u.data.length = elem_len;
+	iwr.u.data.pointer = (void*)elem;
 
-	if (hostapd_ioctl_iface(ifname, drv, param, blen)) {
-		printf("%s: Failed to set generic info element\n", drv->iface);
-		ret = -1;
+	if (ioctl(drv->ioctl_sock, SIOCSIWGENIE, &iwr) < 0) {
+		perror("Failed to set generic info element");
+		return -1;
 	}
-	free(buf);
 
-	return ret;
+	return 0;
 }
 
 

-- 

