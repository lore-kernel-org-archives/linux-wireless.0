Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36114 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1JKL31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:29:27 -0400
Received: by mail-gy0-f174.google.com with SMTP id 10so6378641gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 04:29:26 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Populate radiotap header with MCS info for tx'ed frames
Date: Tue, 11 Oct 2011 13:28:55 +0200
Message-Id: <1318332535-8815-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_132930_496668_3A61A6F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already filled in the MCS rate info for rx'ed frames but tx'ed
frames that are sent to a monitor interface during the status callback
lack this information.

Add the radiotap fields for MCS info to ieee80211_tx_status_rtap_hdr
and populate them when sending tx'ed frames to the monitors.

One minor flaw is that the radiotap header now includes both, the rate
field and the mcs field. For HT frames the rate field will be zero and
for legacy frames the mcs fields will be zero but still this could
be improved.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Wireshark will display the MCS rate correctly but will show the zero'd rate
field as well with 0Mbps. For legacy frames the MCS field won't be shown
since IEEE80211_RADIOTAP_MCS_HAVE_MCS isn't set. Only the MCS flags will be
shown (all zero of course).

I still think it is justified to use it like this as otherwise we would have
to build the radiotap header in a more generic fashion and we won't be able to
easily catch build bugs like

        BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
                        sizeof(struct ieee80211_tx_status_rtap_hdr));

 include/net/mac80211.h     |    2 +-
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/status.c      |   26 +++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cd108df..a500c7b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2520,7 +2520,7 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define IEEE80211_TX_STATUS_HEADROOM	16
 
 /**
  * ieee80211_sta_set_buffered - inform mac80211 about driver-buffered frames
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9fa5f8a..41dc565 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1187,6 +1187,9 @@ struct ieee80211_tx_status_rtap_hdr {
 	u8 padding_for_rate;
 	__le16 tx_flags;
 	u8 data_retries;
+	u8 mcs_known;
+	u8 mcs_flags;
+	u8 mcs;
 } __packed;
 
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 864a9c3..34319fe 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -475,7 +475,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	rthdr->hdr.it_present =
 		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
 			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES) |
-			    (1 << IEEE80211_RADIOTAP_RATE));
+			    (1 << IEEE80211_RADIOTAP_RATE) |
+			    (1 << IEEE80211_RADIOTAP_MCS));
 
 	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
 	    !is_multicast_ether_addr(hdr->addr1))
@@ -491,10 +492,25 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_CTS);
 	else if (info->status.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
 		rthdr->tx_flags |= cpu_to_le16(IEEE80211_RADIOTAP_F_TX_RTS);
-	if (info->status.rates[0].idx >= 0 &&
-	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
-		rthdr->rate = sband->bitrates[
-				info->status.rates[0].idx].bitrate / 5;
+	if (info->status.rates[0].idx >= 0) {
+    		if (!(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+			/* legacy rate */
+			rthdr->rate = sband->bitrates[
+					info->status.rates[0].idx].bitrate / 5;
+		} else {
+			/* HT rate */
+			rthdr->mcs_known = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+					   IEEE80211_RADIOTAP_MCS_HAVE_GI |
+			   		   IEEE80211_RADIOTAP_MCS_HAVE_BW;
+			if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+				rthdr->mcs_flags |= IEEE80211_RADIOTAP_MCS_SGI;
+			if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+				rthdr->mcs_flags |= IEEE80211_RADIOTAP_MCS_BW_40;
+			if (info->status.rates[0].flags & IEEE80211_TX_RC_GREEN_FIELD)
+				rthdr->mcs_flags |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+			rthdr->mcs = info->status.rates[0].idx;
+		}
+	}
 
 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
-- 
1.7.3.4

