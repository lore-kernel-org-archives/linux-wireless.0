Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:62743 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYAJVkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 16:40:21 -0500
Received: by fk-out-0910.google.com with SMTP id z23so647096fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 13:40:19 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: Fix queue_idx initialization
Date: Thu, 10 Jan 2008 22:40:13 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801102240.13425.IvDoorn@gmail.com> (sfid-20080110_214024_556845_71221CE2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For TX rings the queue_idx should start at
IEEE80211_TX_QUEUE_DATA0 and for each followup
ring this index needs to be increased.

For the RX ring the queue_idx should be set
to 0. We don't need to initialize the tx_params.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this too is a followup on rt2x00 2.0.14.
This fixes rt61pci, after this patch it can associate and
succesfully transfer data again. :)

 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fe98776..f09ad32 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1282,11 +1282,16 @@ static int rt2x00lib_alloc_rings(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Initialize ring parameters.
-	 * cw_min: 2^5 = 32.
-	 * cw_max: 2^10 = 1024.
+	 * RX: queue_idx = 0
+	 * TX: queue_idx = IEEE80211_TX_QUEUE_DATA0 + index
+	 * TX: cw_min: 2^5 = 32.
+	 * TX: cw_max: 2^10 = 1024.
 	 */
-	index = 0;
-	ring_for_each(rt2x00dev, ring) {
+	rt2x00dev->rx->rt2x00dev = rt2x00dev;
+	rt2x00dev->rx->queue_idx = 0;
+
+	index = IEEE80211_TX_QUEUE_DATA0;
+	txring_for_each(rt2x00dev, ring) {
 		ring->rt2x00dev = rt2x00dev;
 		ring->queue_idx = index++;
 		ring->tx_params.aifs = 2;
-- 
1.5.3.7

