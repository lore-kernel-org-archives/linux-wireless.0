Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbaCDIhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 03:37:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: set beamforming bit in radiotap
Date: Tue,  4 Mar 2014 10:35:25 +0200
Message-Id: <1393922125-17383-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140304_093742_443825_233309A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a bit in rx_status.vht_flags to let the low level driver
notify mac80211 about a beamformed packet. Propagate this
to the radiotap header.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/rx.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 241e049..2890188 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -877,11 +877,13 @@ enum mac80211_rx_flags {
  * @RX_VHT_FLAG_80MHZ: 80 MHz was used
  * @RX_VHT_FLAG_80P80MHZ: 80+80 MHz was used
  * @RX_VHT_FLAG_160MHZ: 160 MHz was used
+ * @RX_VHT_FLAG_BF: packet was beamformed
  */
 enum mac80211_rx_vht_flags {
 	RX_VHT_FLAG_80MHZ		= BIT(0),
 	RX_VHT_FLAG_80P80MHZ		= BIT(1),
 	RX_VHT_FLAG_160MHZ		= BIT(2),
+	RX_VHT_FLAG_BF			= BIT(3),
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6d66140..dc1cfa8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -333,6 +333,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* in VHT, STBC is binary */
 		if (status->flag & RX_FLAG_STBC_MASK)
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_STBC;
+		if (status->vht_flag & RX_VHT_FLAG_BF)
+			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_BEAMFORMED;
 		pos++;
 		/* bandwidth */
 		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
-- 
1.8.3.2

