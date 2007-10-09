Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27304 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbXJINEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 09:04:05 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: let get nick return what set nick has set
Date: Tue, 9 Oct 2007 15:04:14 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710091504.14903.hs4233@mail.mn-solutions.de> (sfid-20071009_140420_276007_5D975D3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the get-nickname wireless extension actually work. Before
this patch, I could do "iwconfig eth1 nick BLAH" but "iwconfig
eth1" would have still showed "MRVL-USB8388" to me. Hey, and that
was wrong anyway, I'm on a CF card, not on USB :-)

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: libertas-2.6/drivers/net/wireless/libertas/wext.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/wext.c	2007-10-09 15:50:49.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/wext.c	2007-10-09 16:04:26.000000000 +0200
@@ -251,37 +251,16 @@ static int wlan_set_nick(struct net_devi
 static int wlan_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
-	const char *cp;
-	char comm[6] = { "COMM-" };
-	char mrvl[6] = { "MRVL-" };
-	int cnt;
+	wlan_private *priv = dev->priv;
+	wlan_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
-	/*
-	 * Nick Name is not used internally in this mode,
-	 * therefore return something useful instead. Jean II
-	 */
-
-	strcpy(extra, mrvl);
-
-	cp = strstr(libertas_driver_version, comm);
-	if (cp == libertas_driver_version)	//skip leading "COMM-"
-		cp = libertas_driver_version + strlen(comm);
-	else
-		cp = libertas_driver_version;
-
-	cnt = strlen(mrvl);
-	extra += cnt;
-	while (cnt < 16 && (*cp != '-')) {
-		*extra++ = toupper(*cp++);
-		cnt++;
-	}
+	dwrq->length = strlen(adapter->nodename);
+	memcpy(extra, adapter->nodename, dwrq->length);
+	extra[dwrq->length] = '\0';
 
-	/*
-	 * Push it out !
-	 */
-	dwrq->length = cnt;
+	dwrq->flags = 1;	/* active */
 
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
@@ -311,6 +290,7 @@ static int mesh_get_nick(struct net_devi
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
+
 static int wlan_set_rts(struct net_device *dev, struct iw_request_info *info,
 			struct iw_param *vwrq, char *extra)
 {
