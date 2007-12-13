Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762799AbXLMG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:42 -0500
Subject: [PATCH 79/48] libertas: allow get/set SSID on mshX device
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i32-0005tN-5I@shinybook.infradead.org> (sfid-20071213_070000_441008_F397C3F5)
Date: Thu, 13 Dec 2007 01:59:56 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 19:30:57 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/wext.c |   52 ++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index e44c0ce..0a06072 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1917,6 +1917,54 @@ out:
 	return ret;
 }
 
+static int lbs_mesh_get_essid(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct lbs_private *priv = dev->priv;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	memcpy(extra, priv->mesh_ssid, priv->mesh_ssid_len);
+
+	dwrq->length = priv->mesh_ssid_len;
+
+	dwrq->flags = 1;	/* active */
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+	return 0;
+}
+
+static int lbs_mesh_set_essid(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct lbs_private *priv = dev->priv;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	/* Check the size of the string */
+	if (dwrq->length > IW_ESSID_MAX_SIZE) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	if (!dwrq->flags || !dwrq->length) {
+		ret = -EINVAL;
+		goto out;
+	} else {
+		/* Specific SSID requested */
+		memcpy(priv->mesh_ssid, extra, dwrq->length);
+		priv->mesh_ssid_len = dwrq->length;
+	}
+
+	lbs_mesh_config(priv, 1);
+ out:
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+	return ret;
+}
+
 /**
  *  @brief Connect to the AP or Ad-hoc Network with specific bssid
  *
@@ -2071,8 +2119,8 @@ static const iw_handler mesh_wlan_handler[] = {
 	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
 	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
 	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
-	(iw_handler) NULL,		/* SIOCSIWESSID */
-	(iw_handler) NULL,		/* SIOCGIWESSID */
+	(iw_handler) lbs_mesh_set_essid,/* SIOCSIWESSID */
+	(iw_handler) lbs_mesh_get_essid,/* SIOCGIWESSID */
 	(iw_handler) NULL,		/* SIOCSIWNICKN */
 	(iw_handler) mesh_get_nick,	/* SIOCGIWNICKN */
 	(iw_handler) NULL,	/* -- hole -- */
-- 
1.5.3.4

