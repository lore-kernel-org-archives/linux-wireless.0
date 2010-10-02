Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab0JBJfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:45 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:44 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/20] rt2x00: Improve cooperation between rt2800pci and minstrel
Date: Sat, 2 Oct 2010 11:34:26 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021133.43033.IvDoorn@gmail.com> <201010021134.06174.IvDoorn@gmail.com>
In-Reply-To: <201010021134.06174.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021134.27424.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

In order to lower the impact of probe rates don't send a frame as AMPDU
if the rate control algorithm sets IEEE80211_TX_CTL_RATE_CTRL_PROBE.
Otherwise a whole aggregate would be send with a probe rate which might
lead to numerous retries.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index 2023419..c637bca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -73,9 +73,11 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 
 
 	/*
-	 * Convert flags
+	 * This frame is eligible for an AMPDU, however, don't aggregate
+	 * frames that are intended to probe a specific tx rate.
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU &&
+	    !(tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
 		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
 
 	/*
-- 
1.7.2.3

