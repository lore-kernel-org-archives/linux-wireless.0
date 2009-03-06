Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37042 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZCFFyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:54:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:54:45 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/4] ath9k: RX buffers may be accessed/freed even before initialized/alloced.
Date: Fri, 6 Mar 2009 11:24:09 +0530
Message-ID: <1236318851-7500-3-git-send-email-senthilkumar@atheros.com> (sfid-20090306_065447_972027_FF3134D3)
In-Reply-To: <1236318851-7500-2-git-send-email-senthilkumar@atheros.com>
References: <1236318851-7500-1-git-send-email-senthilkumar@atheros.com>
 <1236318851-7500-2-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

accessing RXBUF list in ath_rx_cleanup may cause panic if
ath_descdma_setup fails even before RXBUF list is initialized.

Signee-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 4bc43db..7d9c060 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1773,6 +1773,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s DMA: %u buffers %u desc/buf\n",
 		name, nbuf, ndesc);
 
+	INIT_LIST_HEAD(head);
 	/* ath_desc must be a multiple of DWORDs */
 	if ((sizeof(struct ath_desc) % 4) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL, "ath_desc not DWORD aligned\n");
@@ -1823,7 +1824,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	dd->dd_bufptr = bf;
 
-	INIT_LIST_HEAD(head);
 	for (i = 0; i < nbuf; i++, bf++, ds += ndesc) {
 		bf->bf_desc = ds;
 		bf->bf_daddr = DS2PHYS(dd, ds);
-- 
1.6.0.4

