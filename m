Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37088 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0F2TvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:18 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so553wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:18 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/21] rt2x00: Fix IEEE80211_HT_CAP_RX_STBC assignment
Date: Tue, 29 Jun 2010 21:48:37 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292147.38367.IvDoorn@gmail.com> <201006292148.07594.IvDoorn@gmail.com>
In-Reply-To: <201006292148.07594.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292148.38803.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

IEEE80211_HT_CAP_RX_STBC is a 2 bit flag, and should thus
never be set as normal flag. Instead we must read the number
of RX paths from the EEPROM and set the IEEE80211_HT_CAP_RX_STBC
with the correct value (using the same logic as the number of TX
streams).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5125315..2d0a216 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2572,12 +2572,15 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 	    IEEE80211_HT_CAP_GRN_FLD |
 	    IEEE80211_HT_CAP_SGI_20 |
-	    IEEE80211_HT_CAP_SGI_40 |
-	    IEEE80211_HT_CAP_RX_STBC;
+	    IEEE80211_HT_CAP_SGI_40;
 
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) >= 2)
 		spec->ht.cap |= IEEE80211_HT_CAP_TX_STBC;
 
+	spec->ht.cap |=
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) <<
+		IEEE80211_HT_CAP_RX_STBC_SHIFT;
+
 	spec->ht.ampdu_factor = 3;
 	spec->ht.ampdu_density = 4;
 	spec->ht.mcs.tx_params =
-- 
1.6.6.1

