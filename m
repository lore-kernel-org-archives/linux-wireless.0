Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41193 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbYGTNyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:54:15 -0400
Message-ID: <48833ECA.7040402@openwrt.org> (sfid-20080720_155417_487551_664842C0)
Date: Sun, 20 Jul 2008 15:34:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath5k-devel@lists.ath5k.org
Subject: [PATCH 5/5] ath9k: fix DMA descriptor access on big-endian
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the descriptor swap, as the driver already configures the
hardware for descriptor swapping on big endian systems

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -2141,22 +2141,6 @@
  	memzero(dd, sizeof(*dd));
  }

-/*
- *  Endian Swap for transmit descriptor
- *
- * XXX: Move cpu_to_le32() into hw.c and anywhere we set them, then
- * remove this.
-*/
-void ath_desc_swap(struct ath_desc *ds)
-{
-	ds->ds_link = cpu_to_le32(ds->ds_link);
-	ds->ds_data = cpu_to_le32(ds->ds_data);
-	ds->ds_ctl0 = cpu_to_le32(ds->ds_ctl0);
-	ds->ds_ctl1 = cpu_to_le32(ds->ds_ctl1);
-	ds->ds_hw[0] = cpu_to_le32(ds->ds_hw[0]);
-	ds->ds_hw[1] = cpu_to_le32(ds->ds_hw[1]);
-}
-
  /*************/
  /* Utilities */
  /*************/
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -140,11 +140,6 @@
  	series[0].RateFlags = (ctsrate) ? HAL_RATESERIES_RTS_CTS : 0;
  	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0,
  		ctsrate, ctsduration, series, 4, 0);
-
-	/* NB: The desc swap function becomes void,
-	 * if descriptor swapping is not enabled
-	 */
-	ath_desc_swap(ds);
  }

  /* Move everything from the vap's mcast queue to the hardware cab queue.
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -384,7 +384,6 @@
  void ath_descdma_cleanup(struct ath_softc *sc,
  			 struct ath_descdma *dd,
  			 struct list_head *head);
-void ath_desc_swap(struct ath_desc *ds);

  /******/
  /* RX */
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2062,7 +2062,6 @@
  			    AH_TRUE,            /* first segment */
  			    (n_sg == 1) ? AH_TRUE : AH_FALSE, /* last segment */
  			    ds);                /* first descriptor */
-	ath_desc_swap(ds);

  	bf->bf_lastfrm = bf;
  	bf->bf_ht = txctl->ht;
