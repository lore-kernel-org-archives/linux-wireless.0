Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59732 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752910AbeBSMs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:48:59 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Mon, 19 Feb 2018 14:48:39 +0200
Message-Id: <20180219124847.27169-6-luca@coelho.fi> (sfid-20180219_134915_924495_926F8A8D)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 05/13] mac80211: support reporting A-MPDU EOF bit value/known
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support getting the EOF bit value reported from hardware
and writing it out to radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h | 2 ++
 include/net/mac80211.h           | 5 +++++
 net/mac80211/rx.c                | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index d91f9e7f4d71..960236fb1681 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -149,6 +149,8 @@ enum ieee80211_radiotap_ampdu_flags {
 	IEEE80211_RADIOTAP_AMPDU_IS_LAST = 0x0008,
 	IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_ERR = 0x0010,
 	IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_KNOWN = 0x0020,
+	IEEE80211_RADIOTAP_AMPDU_EOF = 0x0040,
+	IEEE80211_RADIOTAP_AMPDU_EOF_KNOWN = 0x0080,
 };
 
 /* for IEEE80211_RADIOTAP_VHT */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 906e90223066..7efac7f98e45 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1098,6 +1098,9 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	the first subframe.
  * @RX_FLAG_ICV_STRIPPED: The ICV is stripped from this frame. CRC checking must
  *	be done in the hardware.
+ * @RX_FLAG_AMPDU_EOF_BIT: Value of the EOF bit in the A-MPDU delimiter for this
+ *	frame
+ * @RX_FLAG_AMPDU_EOF_BIT_KNOWN: The EOF value is known
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -1124,6 +1127,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_MIC_STRIPPED		= BIT(21),
 	RX_FLAG_ALLOW_SAME_PN		= BIT(22),
 	RX_FLAG_ICV_STRIPPED		= BIT(23),
+	RX_FLAG_AMPDU_EOF_BIT		= BIT(24),
+	RX_FLAG_AMPDU_EOF_BIT_KNOWN	= BIT(25),
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e755f93ad735..478a9c735edb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -439,6 +439,10 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			flags |= IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_ERR;
 		if (status->flag & RX_FLAG_AMPDU_DELIM_CRC_KNOWN)
 			flags |= IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_KNOWN;
+		if (status->flag & RX_FLAG_AMPDU_EOF_BIT_KNOWN)
+			flags |= IEEE80211_RADIOTAP_AMPDU_EOF_KNOWN;
+		if (status->flag & RX_FLAG_AMPDU_EOF_BIT)
+			flags |= IEEE80211_RADIOTAP_AMPDU_EOF;
 		put_unaligned_le16(flags, pos);
 		pos += 2;
 		if (status->flag & RX_FLAG_AMPDU_DELIM_CRC_KNOWN)
-- 
2.15.1
