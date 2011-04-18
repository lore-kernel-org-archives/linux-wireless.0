Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1DRNfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:52 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:52 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/23] rt2x00: Use TXOP_HTTXOP for beacons
Date: Mon, 18 Apr 2011 15:28:50 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181528.05047.IvDoorn@gmail.com> <201104181528.28208.IvDoorn@gmail.com>
In-Reply-To: <201104181528.28208.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181528.51457.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Use TXOP_HTTXOP for beacons to stay in sync with the legacy drivers.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index e8c0c3e..a30f68c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -92,14 +92,15 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 
 	/*
 	 * Determine IFS values
-	 * - Use TXOP_BACKOFF for management frames
+	 * - Use TXOP_BACKOFF for management frames except beacons
 	 * - Use TXOP_SIFS for fragment bursts
 	 * - Use TXOP_HTTXOP for everything else
 	 *
 	 * Note: rt2800 devices won't use CTS protection (if used)
 	 * for frames not transmitted with TXOP_HTTXOP
 	 */
-	if (ieee80211_is_mgmt(hdr->frame_control))
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_beacon(hdr->frame_control))
 		txdesc->u.ht.txop = TXOP_BACKOFF;
 	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
 		txdesc->u.ht.txop = TXOP_SIFS;
-- 
1.7.2.3

