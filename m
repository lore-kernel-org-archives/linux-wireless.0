Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:49847 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GIS1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 14:27:14 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv4 2/5] mac80211: add functions to duplicate a cfg80211_beacon
Date: Tue,  9 Jul 2013 20:27:01 +0200
Message-Id: <1373394424-23298-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130709_202718_619700_2A6C4F6F)
In-Reply-To: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the channel switch announcement, it is required to set a new beacon
after the driver arrived on the new channel. The new beacon will be set
by nl80211, but is required to duplicate the beacon as the original
memory within the netlink message will be gone.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv2:
 * allocate only one memory chunk
---
 net/mac80211/cfg.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b82fff6..8e6c935 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2775,6 +2775,62 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return 0;
 }
 
+static struct cfg80211_beacon_data *
+cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
+{
+	struct cfg80211_beacon_data *new_beacon;
+	u8 *pos;
+	int len;
+
+	len = beacon->head_len + beacon->tail_len + beacon->beacon_ies_len +
+	      beacon->proberesp_ies_len + beacon->assocresp_ies_len +
+	      beacon->probe_resp_len;
+
+	new_beacon = kzalloc(sizeof(*new_beacon) + len, GFP_KERNEL);
+	if (!new_beacon)
+		return NULL;
+
+	pos = (u8 *)(new_beacon + 1);
+	if (beacon->head_len) {
+		new_beacon->head_len = beacon->head_len;
+		new_beacon->head = pos;
+		memcpy(pos, beacon->head, beacon->head_len);
+		pos += beacon->head_len;
+	}
+	if (beacon->tail_len) {
+		new_beacon->tail_len = beacon->tail_len;
+		new_beacon->tail = pos;
+		memcpy(pos, beacon->tail, beacon->tail_len);
+		pos += beacon->tail_len;
+	}
+	if (beacon->beacon_ies_len) {
+		new_beacon->beacon_ies_len = beacon->beacon_ies_len;
+		new_beacon->beacon_ies = pos;
+		memcpy(pos, beacon->beacon_ies, beacon->beacon_ies_len);
+		pos += beacon->beacon_ies_len;
+	}
+	if (beacon->proberesp_ies_len) {
+		new_beacon->proberesp_ies_len = beacon->proberesp_ies_len;
+		new_beacon->proberesp_ies = pos;
+		memcpy(pos, beacon->proberesp_ies, beacon->proberesp_ies_len);
+		pos += beacon->proberesp_ies_len;
+	}
+	if (beacon->assocresp_ies_len) {
+		new_beacon->assocresp_ies_len = beacon->assocresp_ies_len;
+		new_beacon->assocresp_ies = pos;
+		memcpy(pos, beacon->assocresp_ies, beacon->assocresp_ies_len);
+		pos += beacon->assocresp_ies_len;
+	}
+	if (beacon->probe_resp_len) {
+		new_beacon->probe_resp_len = beacon->probe_resp_len;
+		beacon->probe_resp = pos;
+		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
+		pos += beacon->probe_resp_len;
+	}
+
+	return new_beacon;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
-- 
1.7.10.4

