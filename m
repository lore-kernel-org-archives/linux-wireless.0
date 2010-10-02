Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0JBJfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:46 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/20] rt2x00: Work around hw aggregation oddity in rt2800
Date: Sat, 2 Oct 2010 11:34:56 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021134.06174.IvDoorn@gmail.com> <201010021134.27424.IvDoorn@gmail.com>
In-Reply-To: <201010021134.27424.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021134.56984.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

If a frame is not meant to be sent as AMPDU or part of it the hw might
still decide to aggregate this frame if a previous frame started an
AMPDU. However, this will limit the usefulness of the reported tx rate
since the reported rate will be the one specified in the TXWI of the
first frame and thus it is not possible to reliably caculate the
number of retrys by substracting the reported tx rate from the tx rate
in the TXWI.

To fix this issue, only report the successful rate for frames that were
not meant to be aggregated but ended up in an aggregate.

Example:
Frame A (MCS7, AMPDU=1) B (MCS7, AMPDU=1) C (MCS12, AMDPU=0, PROBE_RATE)

Although frame C shoudn't be aggregated the hw might sill put it
into an AMPDU together with A and B. If the transmission succeeds the tx
status will contain MCS7 for all three frames. In that case we should
only report MCS7 as success rate and avoid reporting MCS12-MCS8 as
failed tx attempts as this will affect the future rate control
decisions.

This oddity might strike us in other scenarious as well but the most
common "wrong" report happened for frames used to probe a different tx
rate.

This improves the rate control decisions notable.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0287157..7f040b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -634,9 +634,11 @@ static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u16 mcs, real_mcs;
+	int aggr, ampdu;
 	__le32 *txwi;
 
 	/*
@@ -645,8 +647,33 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 	txdesc.flags = 0;
 	txwi = rt2800_drv_get_txwi(entry);
 	rt2x00_desc_read(txwi, 0, &word);
+
 	mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
+	ampdu = rt2x00_get_field32(word, TXWI_W0_AMPDU);
+
 	real_mcs = rt2x00_get_field32(status, TX_STA_FIFO_MCS);
+	aggr = rt2x00_get_field32(status, TX_STA_FIFO_TX_AGGRE);
+
+	/*
+	 * If a frame was meant to be sent as a single non-aggregated MPDU
+	 * but ended up in an aggregate the used tx rate doesn't correlate
+	 * with the one specified in the TXWI as the whole aggregate is sent
+	 * with the same rate.
+	 *
+	 * For example: two frames are sent to rt2x00, the first one sets
+	 * AMPDU=1 and requests MCS7 whereas the second frame sets AMDPU=0
+	 * and requests MCS15. If the hw aggregates both frames into one
+	 * AMDPU the tx status for both frames will contain MCS7 although
+	 * the frame was sent successfully.
+	 *
+	 * Hence, replace the requested rate with the real tx rate to not
+	 * confuse the rate control algortihm by providing clearly wrong
+	 * data.
+	 */
+	if (aggr == 1 && ampdu == 0 && real_mcs != mcs) {
+		skbdesc->tx_rate_idx = real_mcs;
+		mcs = real_mcs;
+	}
 
 	/*
 	 * Ralink has a retry mechanism using a global fallback
-- 
1.7.2.3

