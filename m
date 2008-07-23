Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41198 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYGWQxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:53:34 -0400
Date: Wed, 23 Jul 2008 18:53:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k: use correct type for test_bit/set_bit
Message-ID: <20080723165314.GA30144@lst.de> (sfid-20080723_185336_960906_A6A98767)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The test_bit/set_bit/etc family of routines operates on arrays of
unsigned long, so declare sc_keymap as such using the DECLARE_BITMAP
helper.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/net/wireless/ath9k/core.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath9k/core.h	2008-07-23 18:36:39.000000000 +0200
+++ linux-2.6/drivers/net/wireless/ath9k/core.h	2008-07-23 18:37:28.000000000 +0200
@@ -1042,7 +1042,7 @@ struct ath_softc {
 
 	/* Crypto */
 	u_int                   sc_keymax;      /* size of key cache */
-	u_int8_t                sc_keymap[ATH_KEYBYTES];/* key use bit map */
+	DECLARE_BITMAP		(sc_keymap, ATH_KEYBYTES);/* key use bit map */
 	u_int8_t		sc_splitmic;	/* split TKIP MIC keys */
 	int                     sc_keytype;     /* type of the key being used */
 
