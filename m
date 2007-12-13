Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762810AbXLMG7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:48 -0500
Subject: [PATCH 82/48] libertas: disable mesh temporarily while setting eth channel/assoc
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i35-0005tc-Cc@shinybook.infradead.org> (sfid-20071213_070015_891216_A9873554)
Date: Thu, 13 Dec 2007 01:59:59 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 20:03:01 -0500

Otherwise the device won't let us change channels.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index a4b9756..7b672fe 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -204,6 +204,12 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	if (assoc_req->channel == priv->curbssparams.channel)
 		goto done;
 
+	if (priv->mesh_dev) {
+		/* Disconnect mesh while associating -- otherwise it
+		   won't let us change channels */
+		lbs_mesh_config(priv, 0);
+	}
+
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
 	       priv->curbssparams.channel, assoc_req->channel);
 
@@ -221,7 +227,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	if (assoc_req->channel != priv->curbssparams.channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
 		              assoc_req->channel);
-		goto done;
+		goto restore_mesh;
 	}
 
 	if (   assoc_req->secinfo.wep_enabled
@@ -236,7 +242,11 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	/* Must restart/rejoin adhoc networks after channel change */
 	set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
 
-done:
+ restore_mesh:
+	if (priv->mesh_dev)
+		lbs_mesh_config(priv, 1);
+
+ done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
-- 
1.5.3.4

