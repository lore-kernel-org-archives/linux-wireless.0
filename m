Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1586 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYDBOzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 10:55:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: move lbs_update_channel out of assoc.c
Date: Wed, 2 Apr 2008 16:52:19 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804021652.19572.hs4233@mail.mn-solutions.de> (sfid-20080402_155524_388112_DAD80972)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... as it has nothing to do with pure association

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:49:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:50:25.000000000 +0200
@@ -583,23 +583,6 @@ done:
 	return ret;
 }
 
-
-int lbs_update_channel(struct lbs_private *priv)
-{
-	int ret;
-
-	/* the channel in f/w could be out of sync; get the current channel */
-	lbs_deb_enter(LBS_DEB_ASSOC);
-
-	ret = lbs_get_channel(priv);
-	if (ret > 0) {
-		priv->curbssparams.channel = ret;
-		ret = 0;
-	}
-	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
-	return ret;
-}
-
 static int assoc_helper_channel(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-04-02 14:50:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-04-02 14:50:22.000000000 +0200
@@ -826,6 +826,22 @@ out:
 	return ret;
 }
 
+int lbs_update_channel(struct lbs_private *priv)
+{
+	int ret;
+
+	/* the channel in f/w could be out of sync; get the current channel */
+	lbs_deb_enter(LBS_DEB_ASSOC);
+
+	ret = lbs_get_channel(priv);
+	if (ret > 0) {
+		priv->curbssparams.channel = ret;
+		ret = 0;
+	}
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
+	return ret;
+}
+
 /**
  *  @brief Set the radio channel
  *
