Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:24578 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYIQBTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 21:19:46 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2789714wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 18:19:46 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, dcbw@redhat.com
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 16 Sep 2008 18:08:39 -0700
Subject: [PATCH v2] libertas: Reduce the WPA key installation time.
Message-ID: <48d05b30.09038e0a.6b12.ffffb982@mx.google.com> (sfid-20080917_031950_822985_528F32A6)
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

This patch resolves OLPC ticket 7825 (http://dev.laptop.org/ticket/7825)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/dev.h  |    1 +
 drivers/net/wireless/libertas/wext.c |   36 +++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index acb889e..f6f3753 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -58,6 +58,7 @@ struct lbs_802_11_security {
 	u8 WPA2enabled;
 	u8 wep_enabled;
 	u8 auth_mode;
+	u32 key_mgmt;
 };
 
 /** Current Basic Service Set State Structure */
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index d86fcf0..5436b34 100644
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
@@ -1585,12 +1593,26 @@ static int lbs_set_encodeext(struct net_device *dev,
 			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
 		}
 
-		disable_wep (assoc_req);
+		/* Only disable wep if necessary: can't waste time here. */
+		if (priv->mac_control & CMD_ACT_MAC_WEP_ENABLE)
+			disable_wep(assoc_req);
 	}
 
 out:
 	if (ret == 0) {
-		lbs_postpone_association_work(priv);
+		/* 802.1x and WPA rekeying must happen as quickly as possible,
+		 * especially during the 4-way handshake; thus if in
+		 * infrastructure mode, and either (a) 802.1x is enabled or
+		 * (b) WPA is being used, set the key right away.
+		 */
+		if (assoc_req->mode == IW_MODE_INFRA &&
+		    ((assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_802_1X) ||
+		     (assoc_req->secinfo.key_mgmt & IW_AUTH_KEY_MGMT_PSK) ||
+		      assoc_req->secinfo.WPAenabled ||
+		      assoc_req->secinfo.WPA2enabled)) {
+			lbs_do_association_work(priv);
+		} else
+			lbs_postpone_association_work(priv);
 	} else {
 		lbs_cancel_association_work(priv);
 	}
@@ -1698,13 +1720,17 @@ static int lbs_set_auth(struct net_device *dev,
 	case IW_AUTH_TKIP_COUNTERMEASURES:
 	case IW_AUTH_CIPHER_PAIRWISE:
 	case IW_AUTH_CIPHER_GROUP:
-	case IW_AUTH_KEY_MGMT:
 	case IW_AUTH_DROP_UNENCRYPTED:
 		/*
 		 * libertas does not use these parameters
 		 */
 		break;
 
+	case IW_AUTH_KEY_MGMT:
+		assoc_req->secinfo.key_mgmt = dwrq->value;
+		updated = 1;
+		break;
+
 	case IW_AUTH_WPA_VERSION:
 		if (dwrq->value & IW_AUTH_WPA_VERSION_DISABLED) {
 			assoc_req->secinfo.WPAenabled = 0;
@@ -1784,6 +1810,10 @@ static int lbs_get_auth(struct net_device *dev,
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	switch (dwrq->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_KEY_MGMT:
+		dwrq->value = priv->secinfo.key_mgmt;
+		break;
+
 	case IW_AUTH_WPA_VERSION:
 		dwrq->value = 0;
 		if (priv->secinfo.WPAenabled)
-- 
1.5.2.4



