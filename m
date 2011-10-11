Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48358 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1JKQJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 12:09:30 -0400
Received: by ywb5 with SMTP id 5so6722382ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 09:09:29 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Populate radiotap header with MCS info for TX frames
Date: Tue, 11 Oct 2011 18:08:55 +0200
Message-Id: <1318349335-22514-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_180934_334229_7E1AA6EA)
In-Reply-To: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com>
References: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already filled in the MCS rate info for rx'ed frames but tx'ed
frames that are sent to a monitor interface during the status callback
lack this information.

Add the radiotap fields for MCS info to ieee80211_tx_status_rtap_hdr
and populate them when sending tx'ed frames to the monitors.

The needed headroom is only extended by one byte since we don't include
legacy rate information in the rtap header for HT frames.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/status.c  |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cd108df..b50fc1c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2520,7 +2520,7 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define IEEE80211_TX_STATUS_HEADROOM	14
 
 /**
  * ieee80211_sta_set_buffered - inform mac80211 about driver-buffered frames
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index a9dc7b7..4b49ca7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -242,6 +242,11 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 
 	/* IEEE80211_RADIOTAP_DATA_RETRIES */
 	len += 1;
+
+	/* IEEE80211_TX_RC_MCS */
+	if (info->status.rates[0].idx >= 0 &&
+	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS)
+		len += 3;
 	
 	return len;
 }
@@ -299,6 +304,24 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* for now report the total retry_count */
 	*pos = retry_count;
 	pos++;
+
+	/* IEEE80211_TX_RC_MCS */
+	if (info->status.rates[0].idx >= 0 &&
+	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
+			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+			pos[1] |= IEEE80211_RADIOTAP_MCS_SGI;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			pos[1] |= IEEE80211_RADIOTAP_MCS_BW_40;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_GREEN_FIELD)
+			pos[1] |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+		pos[2] = info->status.rates[0].idx;
+		pos += 3;
+	}
+
 }
 
 /*
-- 
1.7.3.4

