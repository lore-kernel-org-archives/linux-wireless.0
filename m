Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50507 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2DQRrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 13:47:24 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/6] wireless: Add util method to get channel index from frequency.
Date: Tue, 17 Apr 2012 10:46:45 -0700
Message-Id: <1334684807-14026-5-git-send-email-greearb@candelatech.com> (sfid-20120417_194726_924640_2523B282)
In-Reply-To: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 27f9561... be6fb62... M	include/net/cfg80211.h
:100644 100644 6cba001... 2fd0e97... M	net/wireless/util.c
 include/net/cfg80211.h |    7 +++++++
 net/wireless/util.c    |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 27f9561..be6fb62 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2388,6 +2388,13 @@ ieee80211_get_channel(struct wiphy *wiphy, int freq)
 }
 
 /**
+ * ieee80211_get_channel_idx - get channel index from wiphy for specified freq
+ * @wiphy: the struct wiphy to get the channel for
+ * @freq: the center frequency of the channel
+ */
+extern int ieee80211_get_channel_idx(struct wiphy *wiphy, int freq);
+
+/**
  * ieee80211_get_response_rate - get basic rate for a given rate
  *
  * @sband: the band to look for rates in
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6cba001..2fd0e97 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -88,6 +88,30 @@ struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(__ieee80211_get_channel);
 
+int ieee80211_get_channel_idx(struct wiphy *wiphy, int freq)
+{
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	int i;
+	int rv = 0;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			if (sband->channels[i].center_freq == freq)
+				return rv;
+			rv++;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(ieee80211_get_channel_idx);
+
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				     enum ieee80211_band band)
 {
-- 
1.7.3.4

