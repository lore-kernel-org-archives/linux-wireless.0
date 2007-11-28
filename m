Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29175 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbXK1NHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:07:21 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: tweak tx path debugging
Date: Wed, 28 Nov 2007 14:08:12 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711281408.13037.hs4233@mail.mn-solutions.de> (sfid-20071128_130731_768183_EC618D15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make two functions in the TX packet path emit
their debug messages with LBS_DEB_TX, not LBS_DEB_MAIN.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
Before this, any TXed packed did emit some messages with
"lbsdebug +enter +main", which was a bit annoying.

Index: wireless-2.6/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2007-11-28 14:35:45.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/main.c	2007-11-28 14:37:13.000000000 +0100
@@ -514,7 +514,7 @@ static int lbs_hard_start_xmit(struct sk
 	int ret = 0;
 	struct lbs_private *priv = dev->priv;
 
-	lbs_deb_enter(LBS_DEB_NET);
+	lbs_deb_enter(LBS_DEB_TX);
 
 	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
 		priv->stats.tx_dropped++;
@@ -528,7 +528,7 @@ static int lbs_hard_start_xmit(struct sk
 	if (lbs_process_tx(priv, skb) == 0)
 		dev->trans_start = jiffies;
 done:
-	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
 	return ret;
 }
 
@@ -564,7 +564,7 @@ static int lbs_pre_start_xmit(struct sk_
 	struct lbs_private *priv = dev->priv;
 	int ret;
 
-	lbs_deb_enter(LBS_DEB_NET);
+	lbs_deb_enter(LBS_DEB_TX);
 
 	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
 		netif_stop_queue(dev);
@@ -574,7 +574,7 @@ static int lbs_pre_start_xmit(struct sk_
 	UNSET_MESH_FRAME(skb);
 
 	ret = lbs_hard_start_xmit(skb, dev);
-	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
 	return ret;
 }
 
