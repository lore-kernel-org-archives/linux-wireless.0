Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0JBJf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:27 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/20] rt2x00: Allow tx duplication for legacy rates in HT40 mode
Date: Sat, 2 Oct 2010 11:29:59 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021129.09422.IvDoorn@gmail.com> <201010021129.31357.IvDoorn@gmail.com>
In-Reply-To: <201010021129.31357.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021130.00255.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Make use of the IEEE80211_TX_RC_DUP_DATA flag to duplicate a
transmission with legacy rates to both 20Mhz channels if set.
Also update the related comment in rt2800.h to describe the
behavior of the BW_40 flag for legacy rates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00ht.c |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e1583cf..9bf50a1 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1982,7 +1982,8 @@ struct mac_iveiv_entry {
  * FRAG: 1 To inform TKIP engine this is a fragment.
  * MIMO_PS: The remote peer is in dynamic MIMO-PS mode
  * TX_OP: 0:HT TXOP rule , 1:PIFS TX ,2:Backoff, 3:sifs
- * BW: Channel bandwidth 20MHz or 40 MHz
+ * BW: Channel bandwidth 0:20MHz, 1:40 MHz (for legacy rates this will
+ *     duplicate the frame to both channels).
  * STBC: 1: STBC support MCS =0-7, 2,3 : RESERVED
  * AMPDU: 1: this frame is eligible for AMPDU aggregation, the hw will
  *        aggregate consecutive frames with the same RA and QoS TID.
diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index 48b6ed4..2023419 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -85,7 +85,13 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 		txdesc->rate_mode = RATE_MODE_HT_MIX;
 	if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
 		txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
-	if (txrate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+
+	/*
+	 * Set 40Mhz mode if necessary (for legacy rates this will
+	 * duplicate the frame to both channels).
+	 */
+	if (txrate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH ||
+	    txrate->flags & IEEE80211_TX_RC_DUP_DATA)
 		__set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
 	if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
 		__set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
-- 
1.7.2.3

