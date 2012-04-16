Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:29477 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab2DPWxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:53:07 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	dcbw@redhat.com
Subject: [PATCH 2/5] libertas: harden-up exit paths
Message-Id: <20120416225302.E2D479D401E@zog.reactivated.net> (sfid-20120417_005311_443403_2472808C)
Date: Mon, 16 Apr 2012 23:53:02 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These simple sanity check avoids extra complexity in error paths when
moving to asynchronous firmware loading (which means the device may fail to
init some time after its creation).

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index fa09585..7eaf992 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1033,7 +1033,9 @@ void lbs_remove_card(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	lbs_remove_mesh(priv);
-	lbs_scan_deinit(priv);
+
+	if (priv->wiphy_registered)
+		lbs_scan_deinit(priv);
 
 	/* worker thread destruction blocks on the in-flight command which
 	 * should have been cleared already in lbs_stop_card().
@@ -1128,6 +1130,11 @@ void lbs_stop_card(struct lbs_private *priv)
 		goto out;
 	dev = priv->dev;
 
+	/* If the netdev isn't registered, it means that lbs_start_card() was
+	 * never called so we have nothing to do here. */
+	if (dev->reg_state != NETREG_REGISTERED)
+		goto out;
+
 	netif_stop_queue(dev);
 	netif_carrier_off(dev);
 
-- 
1.7.7.6

