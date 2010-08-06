Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59602 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761805Ab0HFStx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:53 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so2918051ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:49:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Set MIMO PS flag in tx descriptor for STAs in dynamic SMPS mode
Date: Fri, 6 Aug 2010 20:46:19 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062045.39547.IvDoorn@gmail.com>
In-Reply-To: <201008062045.39547.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062046.19946.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00ht.c    |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b66e0fd..833b157 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -437,7 +437,8 @@ void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
 	rt2x00_desc_read(txwi, 0, &word);
 	rt2x00_set_field32(&word, TXWI_W0_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
-	rt2x00_set_field32(&word, TXWI_W0_MIMO_PS, 0);
+	rt2x00_set_field32(&word, TXWI_W0_MIMO_PS,
+			   test_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W0_CF_ACK, 0);
 	rt2x00_set_field32(&word, TXWI_W0_TS,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index c004cd3..ad3c7ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -54,6 +54,16 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 	 */
 	if (txrate->flags & IEEE80211_TX_RC_MCS) {
 		txdesc->mcs = txrate->idx;
+
+		/*
+		 * MIMO PS should be set to 1 for STA's using dynamic SM PS
+		 * when using more then one tx stream (>MCS7).
+		 */
+		if (tx_info->control.sta && txdesc->mcs > 7 &&
+		    (tx_info->control.sta->ht_cap.cap &
+		     (WLAN_HT_CAP_SM_PS_DYNAMIC <<
+		      IEEE80211_HT_CAP_SM_PS_SHIFT)))
+			__set_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags);
 	} else {
 		txdesc->mcs = rt2x00_get_rate_mcs(hwrate->mcs);
 		if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 38b47919..2d3bf84 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -268,6 +268,7 @@ struct txdone_entry_desc {
  * @ENTRY_TXD_HT_AMPDU: This frame is part of an AMPDU.
  * @ENTRY_TXD_HT_BW_40: Use 40MHz Bandwidth.
  * @ENTRY_TXD_HT_SHORT_GI: Use short GI.
+ * @ENTRY_TXD_HT_MIMO_PS: The receiving STA is in dynamic SM PS mode.
  */
 enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
@@ -286,6 +287,7 @@ enum txentry_desc_flags {
 	ENTRY_TXD_HT_AMPDU,
 	ENTRY_TXD_HT_BW_40,
 	ENTRY_TXD_HT_SHORT_GI,
+	ENTRY_TXD_HT_MIMO_PS,
 };
 
 /**
-- 
1.7.2

