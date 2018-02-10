Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36710 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbeBJMUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 07:20:38 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: round IEEE80211_TX_STATUS_HEADROOM up to multiple of 4
Date: Sat, 10 Feb 2018 13:20:34 +0100
Message-Id: <20180210122034.88455-1-nbd@nbd.name> (sfid-20180210_132044_717459_8454BC33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that mac80211 allocated management frames are properly
aligned, which makes copying them more efficient.
For instance, mt76 uses iowrite32_copy to copy beacon frames to beacon
template memory on the chip.
Misaligned 32-bit accesses cause CPU exceptions on MIPS and should be
avoided.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 906e90223066..c96511fa9198 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4149,7 +4149,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *sta, u8 tid);
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	14
+#define IEEE80211_TX_STATUS_HEADROOM	ALIGN(14, 4)
 
 /**
  * ieee80211_sta_set_buffered - inform mac80211 about driver-buffered frames
-- 
2.14.2
