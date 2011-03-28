Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1C1LhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:37:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2744896wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:37:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/13] rt2x00: Fix tx aggregation problems with some clients
Date: Mon, 28 Mar 2011 13:35:21 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281334.16711.IvDoorn@gmail.com> <201103281334.52023.IvDoorn@gmail.com>
In-Reply-To: <201103281334.52023.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281335.23166.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Some clients seem to rely upon the reception of BlockAckReqs to flush
their rx reorder buffer. In order to fix aggregation for these clients
rt2x00 should send a BlockAckReq if the transmission of an AMPDU
subframe fails.

Introduce a new flag TXDONE_AMPDU to indicate that this is an AMPDU
subframe and pass IEEE80211_TX_STAT_AMPDU_NO_BACK to mac80211 if an
AMPDU subframe failed during transmission.

This fixes aggregation problems with Intel 5100 Windows STAs (and maybe
others as well).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |    3 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 59302fa..769c05c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -687,6 +687,9 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 		mcs = real_mcs;
 	}
 
+	if (aggr == 1 || ampdu == 1)
+		__set_bit(TXDONE_AMPDU, &txdesc.flags);
+
 	/*
 	 * Ralink has a retry mechanism using a global fallback
 	 * table. We setup this fallback table to try the immediate
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a98c434..83252d94 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -353,10 +353,14 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * which would allow the rc algorithm to better decide on
 	 * which rates are suitable.
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+	if (test_bit(TXDONE_AMPDU, &txdesc->flags) ||
+	    tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
+
+		if (!success)
+			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 0c8b0c6..6ae8200 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -217,6 +217,7 @@ enum txdone_entry_desc_flags {
 	TXDONE_FALLBACK,
 	TXDONE_FAILURE,
 	TXDONE_EXCESSIVE_RETRY,
+	TXDONE_AMPDU,
 };
 
 /**
-- 
1.7.2.3

