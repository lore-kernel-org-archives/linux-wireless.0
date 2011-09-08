Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38572 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:31 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so268175ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Add WCID to HT TX descriptor
Date: Thu, 8 Sep 2011 14:37:19 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com> <201109081436.05113.IvDoorn@gmail.com> <201109081436.46401.IvDoorn@gmail.com>
In-Reply-To: <201109081436.46401.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081437.20667.IvDoorn@gmail.com> (sfid-20110908_143936_908758_86D04C74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When sending an unencrypted frame to a STA the driver might want to pass
a suitable WCID since we don't have a key index to allow tx status
reports to get properly assigned to the correct STA.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c44adb1..ba0d7e6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -288,11 +288,16 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct rt2x00_sta *sta_priv = NULL;
 
-	if (tx_info->control.sta)
+	if (tx_info->control.sta) {
 		txdesc->u.ht.mpdu_density =
 		    tx_info->control.sta->ht_cap.ampdu_density;
 
+		sta_priv = sta_to_rt2x00_sta(tx_info->control.sta);
+		txdesc->u.ht.wcid = sta_priv->wcid;
+	}
+
 	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index f22aa86..349008d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -321,6 +321,7 @@ struct txentry_desc {
 			u8 ba_size;
 			u8 mpdu_density;
 			enum txop txop;
+			int wcid;
 		} ht;
 	} u;
 
-- 
1.7.3.4
