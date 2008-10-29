Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:9053 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYJ2In6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 04:43:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: fix two bad print_ssid conversions
Date: Wed, 29 Oct 2008 09:43:50 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200810290943.50945.hs4233@mail.mn-solutions.de> (sfid-20081029_094402_477169_0B913324)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes two current compilation problems. They showed up
with CONFIG_IEEE80211_DEBUG defined.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/net/ieee80211/ieee80211_rx.c
===================================================================
--- linux-wl.orig/net/ieee80211/ieee80211_rx.c	2008-10-29 08:22:20.000000000 +0100
+++ linux-wl/net/ieee80211/ieee80211_rx.c	2008-10-29 08:34:21.000000000 +0100
@@ -1178,7 +1178,7 @@ static int ieee80211_parse_info_param(st
 
 			IEEE80211_DEBUG_MGMT("MFIE_TYPE_SSID: '%s' len=%d.\n",
 					     print_ssid(ssid, network->ssid,
-							network->ssid_len);
+							network->ssid_len),
 					     network->ssid_len);
 			break;
 
Index: linux-wl/net/ieee80211/ieee80211_wx.c
===================================================================
--- linux-wl.orig/net/ieee80211/ieee80211_wx.c	2008-10-29 08:22:20.000000000 +0100
+++ linux-wl/net/ieee80211/ieee80211_wx.c	2008-10-29 08:36:07.000000000 +0100
@@ -399,6 +399,10 @@ int ieee80211_wx_set_encode(struct ieee8
 
 	/* If a new key was provided, set it up */
 	if (erq->length > 0) {
+#ifdef CONFIG_IEEE80211_DEBUG
+		DECLARE_SSID_BUF(ssid);
+#endif
+
 		len = erq->length <= 5 ? 5 : 13;
 		memcpy(sec.keys[key], keybuf, erq->length);
 		if (len > erq->length)
