Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:49841 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2B2GiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:38:14 -0500
Date: Wed, 29 Feb 2012 09:37:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 4/4] rndis_wlan: prevent integer overflow in indication()
Message-ID: <20120229063753.GF18031@elgon.mountain> (sfid-20120229_073819_668286_5EC8EF99)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we pick a high value for "offset" then it could lead to an integer
overflow and we would get past the check for:
	if (offset + len > buflen) { ...

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 74e2d1b..dfd76e3 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3043,7 +3043,7 @@ static void rndis_wlan_media_specific_indication(struct usbnet *usbdev,
 			struct rndis_indicate *msg, int buflen)
 {
 	struct ndis_80211_status_indication *indication;
-	int len, offset;
+	unsigned int len, offset;
 
 	offset = offsetof(struct rndis_indicate, status) +
 			le32_to_cpu(msg->offset);
@@ -3055,7 +3055,7 @@ static void rndis_wlan_media_specific_indication(struct usbnet *usbdev,
 		return;
 	}
 
-	if (offset + len > buflen) {
+	if (len > buflen || offset > buflen || offset + len > buflen) {
 		netdev_info(usbdev->net, "media specific indication, too large to fit to buffer (%i > %i)\n",
 			    offset + len, buflen);
 		return;
