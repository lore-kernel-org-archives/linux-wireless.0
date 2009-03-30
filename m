Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25181 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbZC3KCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38864.93613.536410@gargle.gargle.HOWL> (sfid-20090330_120254_138707_44EE19B0)
Date: Mon, 30 Mar 2009 15:28:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 08/17] ath9k: Remove a couple of unused variables in descriptor handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath9k/main.c  |    3 +--
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index b3ed89a..dae0f95 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -149,12 +149,10 @@ struct ath_buf {
 };
 
 struct ath_descdma {
-	const char *dd_name;
 	struct ath_desc *dd_desc;
 	dma_addr_t dd_desc_paddr;
 	u32 dd_desc_len;
 	struct ath_buf *dd_bufptr;
-	dma_addr_t dd_dmacontext;
 };
 
 int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index cc62520..b252a1f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1790,7 +1790,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		goto fail;
 	}
 
-	dd->dd_name = name;
 	dd->dd_desc_len = sizeof(struct ath_desc) * nbuf * ndesc;
 
 	/*
@@ -1820,7 +1819,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	ds = dd->dd_desc;
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
-		dd->dd_name, ds, (u32) dd->dd_desc_len,
+		name, ds, (u32) dd->dd_desc_len,
 		ito64(dd->dd_desc_paddr), /*XXX*/(u32) dd->dd_desc_len);
 
 	/* allocate buffers */
-- 
1.6.2.1

