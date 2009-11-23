Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58559 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757272AbZKWVpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:16 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 7/8] mac80211: Add define for TX headroom reserved by mac80211 itself.
Date: Mon, 23 Nov 2009 22:44:53 +0100
Message-Id: <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a definition of the amount of TX headroom reserved by mac80211 itself
for its own purposes. Also add BUILD_BUG_ON to validate the value.
This define can then be used by drivers to request additional TX headroom
in the most efficient manner.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    6 ++++++
 net/mac80211/main.c    |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3754ea4..a113458 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1727,6 +1727,12 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
 	local_bh_enable();
 }
 
+/*
+ * The TX headroom reserved by mac80211 for its own tx_status functions.
+ * This is enough for the radiotap header.
+ */
+#define IEEE80211_TX_STATUS_HEADROOM	13
+
 /**
  * ieee80211_tx_status - transmit status callback
  *
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dd8ec8d..f35d4aa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -515,6 +515,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	 * and we need some headroom for passing the frame to monitor
 	 * interfaces, but never both at the same time.
 	 */
+	BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
+			sizeof(struct ieee80211_tx_status_rtap_hdr));
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
 				   sizeof(struct ieee80211_tx_status_rtap_hdr));
 
-- 
1.6.5.3

