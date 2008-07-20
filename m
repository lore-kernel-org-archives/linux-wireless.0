Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34002 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbYGTSmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 14:42:35 -0400
Message-ID: <48838707.5050309@openwrt.org> (sfid-20080720_204253_098638_460734EF)
Date: Sun, 20 Jul 2008 20:42:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH v2] ath9k: fix another endianness issue
References: <48836863.7090008@openwrt.org>
In-Reply-To: <48836863.7090008@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DMA descriptors must always be accessed in native endianness.
With this patch and my previous series, Atheros AR9160 now
works for me in STA mode (tested on an IXP4xx board, big-endian)

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
updated version, found some more instances of the same thing

--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -121,7 +121,7 @@
  	DPRINTF(sc, ATH_DEBUG_TX_PROC,
  		"%s: txq depth = %d\n", __func__, txq->axq_depth);
  	if (txq->axq_link != NULL) {
-		*txq->axq_link = cpu_to_le32(bf->bf_daddr);
+		*txq->axq_link = bf->bf_daddr;
  		DPRINTF(sc, ATH_DEBUG_XMIT,
  			"%s: link[%u](%p)=%llx (%p)\n",
  			__func__,
@@ -168,7 +168,7 @@
  			__func__, txq->axq_qnum,
  			ito64(bf->bf_daddr), bf->bf_desc);
  	} else {
-		*txq->axq_link = cpu_to_le32(bf->bf_daddr);
+		*txq->axq_link = bf->bf_daddr;
  		DPRINTF(sc, ATH_DEBUG_XMIT, "%s: link[%u] (%p)=%llx (%p)\n",
  			__func__,
  			txq->axq_qnum, txq->axq_link,
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -159,7 +159,7 @@
  	if (!cabq->axq_link)
  		ath9k_hw_puttxbuf(ah, cabq->axq_qnum, bfmcast->bf_daddr);
  	else
-		*cabq->axq_link = cpu_to_le32(bfmcast->bf_daddr);
+		*cabq->axq_link = bfmcast->bf_daddr;

  	/* append the private vap mcast list to  the cabq */

@@ -688,11 +688,7 @@
  			if (if_id != ATH_IF_ID_ANY) {
  				bf = ath_beacon_generate(sc, if_id);
  				if (bf != NULL) {
-					if (bflink != &bfaddr)
-						*bflink = cpu_to_le32(
-							bf->bf_daddr);
-					else
-						*bflink = bf->bf_daddr;
+					*bflink = bf->bf_daddr;
  					bflink = &bf->bf_desc->ds_link;
  					bc++;
  				}
