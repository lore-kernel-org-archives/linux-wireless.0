Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44320 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYGWTdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:33:07 -0400
Date: Wed, 23 Jul 2008 21:32:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andreas Schwab <schwab@suse.de>
Cc: Christoph Hellwig <hch@lst.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: use correct type for test_bit/set_bit
Message-ID: <20080723193240.GA5607@lst.de> (sfid-20080723_213311_841563_07EDBB1B)
References: <20080723165314.GA30144@lst.de> <jeod4oecfe.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <jeod4oecfe.fsf@sykes.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 07:29:57PM +0200, Andreas Schwab wrote:
> > +	DECLARE_BITMAP		(sc_keymap, ATH_KEYBYTES);/* key use bit map */
> 
> DECLARE_BITMAP expects the number of bits, not bytes.

Indeed, updated version below:

Index: linux-2.6/drivers/net/wireless/ath9k/core.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath9k/core.h	2008-07-23 18:36:39.000000000 +0200
+++ linux-2.6/drivers/net/wireless/ath9k/core.h	2008-07-23 21:26:59.000000000 +0200
@@ -888,7 +888,6 @@ void ath_setdefantenna(void *sc, u_int a
  * up to ATH_KEYMAX entries (could dynamically allocate state).
  */
 #define	ATH_KEYMAX	        128        /* max key cache size we handle */
-#define	ATH_KEYBYTES	        (ATH_KEYMAX/NBBY) /* storage space in bytes */
 
 #define RESET_RETRY_TXQ         0x00000001
 #define ATH_IF_ID_ANY   	0xff
@@ -1042,7 +1041,7 @@ struct ath_softc {
 
 	/* Crypto */
 	u_int                   sc_keymax;      /* size of key cache */
-	u_int8_t                sc_keymap[ATH_KEYBYTES];/* key use bit map */
+	DECLARE_BITMAP		(sc_keymap, ATH_KEYMAX);/* key use bit map */
 	u_int8_t		sc_splitmic;	/* split TKIP MIC keys */
 	int                     sc_keytype;     /* type of the key being used */
 
