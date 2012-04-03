Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:26933 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001Ab2DCQB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:01:59 -0400
From: Daniel Drake <dsd@laptop.org>
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [RFC 2/4] libertas: harden-up exit paths
Message-Id: <20120403160154.401D39D401E@zog.reactivated.net> (sfid-20120403_180202_254867_36E4BFB9)
Date: Tue,  3 Apr 2012 17:01:52 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These simple sanity check avoids extra complexity in error paths when
moving to asynchronous firmware loading (which means the device may fail to
init some time after its creation).

Signed-off-by: Daniel Drake <dsd@laptop.org>
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

