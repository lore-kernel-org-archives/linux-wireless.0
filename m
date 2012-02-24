Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17666 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2BXGHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 01:07:41 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 2/3] ath9k: make use of list_for_each_entry_safe
Date: Fri, 24 Feb 2012 11:37:20 +0530
Message-ID: <1330063641-4524-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120224_070743_464101_A10582BF)
In-Reply-To: <1330063641-4524-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1330063641-4524-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this does the same thing as the previous code

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7e1a91a..4633f51 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -169,22 +169,17 @@ static void ath_rx_addbuffer_edma(struct ath_softc *sc,
 				  enum ath9k_rx_qtype qtype, int size)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	u32 nbuf = 0;
+	struct ath_buf *bf, *tbf;
 
 	if (list_empty(&sc->rx.rxbuf)) {
 		ath_dbg(common, QUEUE, "No free rx buf available\n");
 		return;
 	}
 
-	while (!list_empty(&sc->rx.rxbuf)) {
-		nbuf++;
-
+	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list)
 		if (!ath_rx_edma_buf_link(sc, qtype))
 			break;
 
-		if (nbuf >= size)
-			break;
-	}
 }
 
 static void ath_rx_remove_buffer(struct ath_softc *sc,
-- 
1.7.0.4

