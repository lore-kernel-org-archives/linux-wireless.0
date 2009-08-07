Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:38228 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZHGRiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 13:38:51 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] p54: Write outside array bounds
Date: Fri, 7 Aug 2009 19:38:51 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <error27@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908071938.51404.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a coding error which allowed the to upper-layer to
corrupt limited portions of the phy data.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Note:

mac80211 guarantees that params is a valid pointer, so
the _other_ check is no longer needed.
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index a0d0e72..bcab4c6 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -317,7 +317,7 @@ static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
 	int ret;
 
 	mutex_lock(&priv->conf_mutex);
-	if ((params) && !(queue > 4)) {
+	if (queue < dev->queues) {
 		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 		ret = p54_set_edcf(priv);
