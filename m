Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1132 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYA1Q0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:26:50 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: make lbs_unset_basic_rate_flags() static
Date: Mon, 28 Jan 2008 17:27:03 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801281727.03358.hs4233@mail.mn-solutions.de> (sfid-20080128_162653_220280_2613A38E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... by moving it into the file where it's sole user resides

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/join.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/join.c	2008-01-17 10:31:26.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/join.c	2008-01-17 10:32:01.000000000 +0100
@@ -99,23 +99,6 @@ static void lbs_set_basic_rate_flags(u8 
 }
 
 /**
- *  @brief Unsets the MSB on basic rates
- *
- * Scan through an array and unset the MSB for basic data rates.
- *
- *  @param rates     buffer of data rates
- *  @param len       size of buffer
- */
-void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		rates[i] &= 0x7f;
-}
-
-
-/**
  *  @brief Associate to a specific BSS discovered in a scan
  *
  *  @param priv      A pointer to struct lbs_private structure
Index: wireless-2.6/drivers/net/wireless/libertas/join.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/join.h	2008-01-17 10:32:17.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/join.h	2008-01-17 10:32:21.000000000 +0100
@@ -48,6 +48,4 @@ int lbs_send_deauthentication(struct lbs
 
 int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req);
 
-void lbs_unset_basic_rate_flags(u8 *rates, size_t len);
-
 #endif
Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2008-01-17 10:31:26.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2008-01-17 10:31:53.000000000 +0100
@@ -73,6 +73,23 @@ static const u8 bcastmac[ETH_ALEN] = { 0
 /*                                                                   */
 /*********************************************************************/
 
+/**
+ *  @brief Unsets the MSB on basic rates
+ *
+ * Scan through an array and unset the MSB for basic data rates.
+ *
+ *  @param rates     buffer of data rates
+ *  @param len       size of buffer
+ */
+static void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		rates[i] &= 0x7f;
+}
+
+
 static inline void clear_bss_descriptor (struct bss_descriptor * bss)
 {
 	/* Don't blow away ->list, just BSS data */
