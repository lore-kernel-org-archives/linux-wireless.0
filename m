Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46172 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1JGUjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 16:39:41 -0400
Received: by wyg34 with SMTP id 34so4268001wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 13:39:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.2] b43: trivial: do not report any link quality instead of invalid one
Date: Fri,  7 Oct 2011 22:39:35 +0200
Message-Id: <1318019975-31743-1-git-send-email-zajec5@gmail.com> (sfid-20111007_223946_603654_841DB9FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't want to report random quality info (new PHYs are affected).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/xmit.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b8de62c..5f812d1 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -735,11 +735,13 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	}
 
 	/* Link quality statistics */
-	if ((chanstat & B43_RX_CHAN_PHYTYPE) == B43_PHYTYPE_N) {
-//		s8 rssi = max(rxhdr->power0, rxhdr->power1);
-		//TODO: Find out what the rssi value is (dBm or percentage?)
-		//      and also find out what the maximum possible value is.
-		//      Fill status.ssi and status.signal fields.
+	if ((chanstat & B43_RX_CHAN_PHYTYPE) >= B43_PHYTYPE_N) {
+		/*
+		s8 rssi = max(rxhdr->power0, rxhdr->power1);
+		TODO: Find out what the rssi value is (dBm or percentage?)
+		      and also find out what the maximum possible value is.
+		      Fill status.ssi and status.signal fields.
+		*/
 	} else {
 		status.signal = b43_rssi_postprocess(dev, rxhdr->jssi,
 						  (phystat0 & B43_RX_PHYST0_OFDM),
-- 
1.7.3.4

