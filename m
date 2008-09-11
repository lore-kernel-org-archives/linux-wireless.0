Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:32205 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYILAJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 20:09:49 -0400
Received: by wa-out-1112.google.com with SMTP id j37so357464waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 17:09:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 11 Sep 2008 15:32:50 -0700
Subject: [PATCH] libertas: Reduce the WPA key installation time.
Message-ID: <48c9b342.081b600a.61cf.fffffdb5@mx.google.com> (sfid-20080912_020953_453328_C2F94BA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WPA requires that the PTK is installed immediately after the 4-way handshake
in order to properly decrypt the subsequent incoming EAPOL-GTK frame.  If the
PTK is not enabled by the time the EAPOL-GTK frame arrives, the frame is
dropped and the supplicant does not receive the group key.

This will happen with fast Access Points that send the EAPOL-GTK frame before
the suplicant has successfully installed and enabled the PTK.  To mitigate
this situation, this patch simplifies and accelerates the SIOCSIWENCODEEXT
execution.

This patch resolves OLPC ticket 7690 (http://dev.laptop.org/ticket/7690)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/wext.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index d86fcf0..1156be5 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -30,6 +30,14 @@ static inline void lbs_postpone_association_work(struct lbs_private *priv)
 	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
 }
 
+static inline void lbs_do_association_work(struct lbs_private *priv)
+{
+	if (priv->surpriseremoved)
+		return;
+	cancel_delayed_work(&priv->assoc_work);
+	queue_delayed_work(priv->work_thread, &priv->assoc_work, 0);
+}
+
 static inline void lbs_cancel_association_work(struct lbs_private *priv)
 {
 	cancel_delayed_work(&priv->assoc_work);
@@ -1585,12 +1593,14 @@ static int lbs_set_encodeext(struct net_device *dev,
 			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
 		}
 
-		disable_wep (assoc_req);
+		/* Only disable wep if necessary: can't waste time here. */
+		if (priv->mac_control & CMD_ACT_MAC_WEP_ENABLE)
+			disable_wep(assoc_req);
 	}
 
 out:
-	if (ret == 0) {
-		lbs_postpone_association_work(priv);
+	if (ret == 0) {  /* key installation is time critical: postpone not! */
+		lbs_do_association_work(priv);
 	} else {
 		lbs_cancel_association_work(priv);
 	}
-- 
1.5.2.4



