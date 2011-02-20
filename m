Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1BTM6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:12 -0500
Received: by eye27 with SMTP id 27so2477439eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:07 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/8] Revert "rt2x00 : avoid timestamp for monitor injected frame."
Date: Sun, 20 Feb 2011 13:56:07 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201355.26260.IvDoorn@gmail.com> <201102201355.47592.IvDoorn@gmail.com>
In-Reply-To: <201102201355.47592.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201356.08735.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This reverts commit e81e0aef32bfa7f593b14479b9c7eaa7196798ac "rt2x00 : avoid
timestamp for monitor injected frame." as it breaks proper timestamp insertion
into probe responses injected by hostapd for example.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: Alban Browaeys <prahal@yahoo.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index fa17c83..bf9bba3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -365,13 +365,10 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 
 	/*
 	 * Beacons and probe responses require the tsf timestamp
-	 * to be inserted into the frame, except for a frame that has been injected
-	 * through a monitor interface. This latter is needed for testing a
-	 * monitor interface.
+	 * to be inserted into the frame.
 	 */
-	if ((ieee80211_is_beacon(hdr->frame_control) ||
-	    ieee80211_is_probe_resp(hdr->frame_control)) &&
-	    (!(tx_info->flags & IEEE80211_TX_CTL_INJECTED)))
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags);
 
 	/*
-- 
1.7.2.3

