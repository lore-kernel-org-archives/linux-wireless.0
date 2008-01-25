Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20526 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYAYNO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 08:14:59 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix memory alignment problems on the blackfin
Date: Fri, 25 Jan 2008 14:15:00 +0100
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251415.00942.hs4233@mail.mn-solutions.de> (sfid-20080125_131509_287156_F3A20381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>

Fixing unaligned memory access on the blackfin architecture (maybe on the 
ARM also).

Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2008-01-25 10:03:29.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2008-01-25 14:03:00.000000000 +0100
@@ -349,7 +349,7 @@ struct assoc_request {
 	u8 channel;
 	u8 band;
 	u8 mode;
-	u8 bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
 
 	/** WEP keys */
 	struct enc_key wep_keys[4];
Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2008-01-25 14:03:14.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2008-01-25 14:03:33.000000000 +0100
@@ -12,8 +12,10 @@
 #include "cmd.h"
 
 
-static const u8 bssid_any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
-static const u8 bssid_off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
+	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
+	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
 
 static int assoc_helper_essid(struct lbs_private *priv,
