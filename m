Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1C1LhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:37:09 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2744896wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:37:08 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/13] rt2x00: Fix STBC transmissions to STAs with Rx STBC > 1
Date: Mon, 28 Mar 2011 13:34:15 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281333.05671.IvDoorn@gmail.com> <201103281333.41794.IvDoorn@gmail.com>
In-Reply-To: <201103281333.41794.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281334.16711.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

For STBC transmissions rt2x00 used the number of RxSTBC streams the
destination STA indicates in its HT capabilities as STBC value in
the TXWI.

However, the legacy drivers and our own comment in rt2800.h suggest
that the STBC field in the TXWI only allows a value of 0 or 1.
The values 2 and 3 are reserved (probably for future devices).

And indeed, STBC transmissions to STAs indicating more then 1
RxSTBC stream fail when the STBC field is set to something >1.

Fix this by only setting the STBC field to 1 when STBC should be
used.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index ae1219d..e8c0c3e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -43,8 +43,11 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 
 	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
 
-	txdesc->u.ht.stbc =
-	    (tx_info->flags & IEEE80211_TX_CTL_STBC) >> IEEE80211_TX_CTL_STBC_SHIFT;
+	/*
+	 * Only one STBC stream is supported for now.
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_STBC)
+		txdesc->u.ht.stbc = 1;
 
 	/*
 	 * If IEEE80211_TX_RC_MCS is set txrate->idx just contains the
-- 
1.7.2.3

