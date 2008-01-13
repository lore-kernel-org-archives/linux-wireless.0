Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43591 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751222AbYAMOQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 09:16:52 -0500
From: Helge Deller <deller@gmx.de>
To: Jean Tourrilhes <jt@hpl.hp.com>, linux-wireless@vger.kernel.org
Subject: [PATCH] WAVELAN - compile-time check for struct sizes
Date: Sun, 13 Jan 2008 15:16:34 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801131516.34567.deller@gmx.de> (sfid-20080113_141659_884438_D9D48735)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert optional struct size checks to non-optional compile-time checks.
Furthermore BUILD_BUG_ON() which will be optimized away by the compiler.

Signed-off-by: Helge Deller <deller@gmx.de>

 wavelan.c      |   34 +++++-----------------------------
 wavelan.p.h    |    1 -
 wavelan_cs.c   |   33 ++++-----------------------------
 wavelan_cs.p.h |    1 -
 4 files changed, 9 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index a1f8a16..ffe50e2 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -49,27 +49,6 @@ static int __init wv_psa_to_irq(u8 irqval)
 	return -1;
 }
 
-#ifdef STRUCT_CHECK
-/*------------------------------------------------------------------*/
-/*
- * Sanity routine to verify the sizes of the various WaveLAN interface
- * structures.
- */
-static char *wv_struct_check(void)
-{
-#define	SC(t,s,n)	if (sizeof(t) != s) return(n);
-
-	SC(psa_t, PSA_SIZE, "psa_t");
-	SC(mmw_t, MMW_SIZE, "mmw_t");
-	SC(mmr_t, MMR_SIZE, "mmr_t");
-	SC(ha_t, HA_SIZE, "ha_t");
-
-#undef	SC
-
-	return ((char *) NULL);
-}				/* wv_struct_check */
-#endif				/* STRUCT_CHECK */
-
 /********************* HOST ADAPTER SUBROUTINES *********************/
 /*
  * Useful subroutines to manage the WaveLAN ISA interface
@@ -4215,14 +4194,11 @@ struct net_device * __init wavelan_probe(int unit)
 	int i;
 	int r = 0;
 
-#ifdef	STRUCT_CHECK
-	if (wv_struct_check() != (char *) NULL) {
-		printk(KERN_WARNING
-		       "%s: wavelan_probe(): structure/compiler botch: \"%s\"\n",
-		       dev->name, wv_struct_check());
-		return -ENODEV;
-	}
-#endif				/* STRUCT_CHECK */
+	/* compile-time check the sizes of structures */
+	BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
+	BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
+	BUILD_BUG_ON(sizeof(mmr_t) != MMR_SIZE);
+	BUILD_BUG_ON(sizeof(ha_t) != HA_SIZE);
 
 	dev = alloc_etherdev(sizeof(net_local));
 	if (!dev)
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index fe24281..b33ac47 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -400,7 +400,6 @@
  */
 #undef SET_PSA_CRC		/* Calculate and set the CRC on PSA (slower) */
 #define USE_PSA_CONFIG		/* Use info from the PSA. */
-#undef STRUCT_CHECK		/* Verify padding of structures. */
 #undef EEPROM_IS_PROTECTED	/* doesn't seem to be necessary */
 #define MULTICAST_AVOID		/* Avoid extra multicast (I'm sceptical). */
 #undef SET_MAC_ADDRESS		/* Experimental */
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 577c647..f510eee 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -71,27 +71,6 @@ static void wv_nwid_filter(unsigned char mode, net_local *lp);
  * (wavelan modem or i82593)
  */
 
-#ifdef STRUCT_CHECK
-/*------------------------------------------------------------------*/
-/*
- * Sanity routine to verify the sizes of the various WaveLAN interface
- * structures.
- */
-static char *
-wv_structuct_check(void)
-{
-#define	SC(t,s,n)	if (sizeof(t) != s) return(n);
-
-  SC(psa_t, PSA_SIZE, "psa_t");
-  SC(mmw_t, MMW_SIZE, "mmw_t");
-  SC(mmr_t, MMR_SIZE, "mmr_t");
-
-#undef	SC
-
-  return((char *) NULL);
-} /* wv_structuct_check */
-#endif	/* STRUCT_CHECK */
-
 /******************* MODEM MANAGEMENT SUBROUTINES *******************/
 /*
  * Useful subroutines to manage the modem of the wavelan
@@ -3794,14 +3773,10 @@ wv_hw_config(struct net_device *	dev)
   printk(KERN_DEBUG "%s: ->wv_hw_config()\n", dev->name);
 #endif
 
-#ifdef STRUCT_CHECK
-  if(wv_structuct_check() != (char *) NULL)
-    {
-      printk(KERN_WARNING "%s: wv_hw_config: structure/compiler botch: \"%s\"\n",
-	     dev->name, wv_structuct_check());
-      return FALSE;
-    }
-#endif	/* STRUCT_CHECK == 1 */
+  /* compile-time check the sizes of structures */
+  BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
+  BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
+  BUILD_BUG_ON(sizeof(mmr_t) != MMR_SIZE);
 
   /* Reset the pcmcia interface */
   if(wv_pcmcia_reset(dev) == FALSE)
diff --git a/drivers/net/wireless/wavelan_cs.p.h b/drivers/net/wireless/wavelan_cs.p.h
index 4b9de00..3627401 100644
--- a/drivers/net/wireless/wavelan_cs.p.h
+++ b/drivers/net/wireless/wavelan_cs.p.h
@@ -459,7 +459,6 @@
 #undef WAVELAN_ROAMING_EXT	/* Enable roaming wireless extensions */
 #undef SET_PSA_CRC		/* Set the CRC in PSA (slower) */
 #define USE_PSA_CONFIG		/* Use info from the PSA */
-#undef STRUCT_CHECK		/* Verify padding of structures */
 #undef EEPROM_IS_PROTECTED	/* Doesn't seem to be necessary */
 #define MULTICAST_AVOID		/* Avoid extra multicast (I'm sceptical) */
 #undef SET_MAC_ADDRESS		/* Experimental */
