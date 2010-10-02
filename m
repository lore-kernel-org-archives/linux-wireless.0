Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0JBJfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:24 -0400
Received: by wyb28 with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/20] rt2x00: Fix SM PS check
Date: Sat, 2 Oct 2010 11:28:02 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021127.04544.IvDoorn@gmail.com> <201010021127.36277.IvDoorn@gmail.com>
In-Reply-To: <201010021127.36277.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021128.03722.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix a check for dynamic SM PS mode in the STAs HT caps. Since a
value of 3 means "SM PS disabled" the previous check assumed in
that case that "dynamic SM PS" was enabled and as such prefixed
every MCS>7 frame with a unnecessary RTS/CTS exchange. Also,
the bit shift was done in the wrong direction.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index ad3c7ff..48b6ed4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -60,9 +60,10 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 		 * when using more then one tx stream (>MCS7).
 		 */
 		if (tx_info->control.sta && txdesc->mcs > 7 &&
-		    (tx_info->control.sta->ht_cap.cap &
-		     (WLAN_HT_CAP_SM_PS_DYNAMIC <<
-		      IEEE80211_HT_CAP_SM_PS_SHIFT)))
+		    ((tx_info->control.sta->ht_cap.cap &
+		      IEEE80211_HT_CAP_SM_PS) >>
+		     IEEE80211_HT_CAP_SM_PS_SHIFT) ==
+		    WLAN_HT_CAP_SM_PS_DYNAMIC)
 			__set_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags);
 	} else {
 		txdesc->mcs = rt2x00_get_rate_mcs(hwrate->mcs);
-- 
1.7.2.3

