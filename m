Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48611 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab3FGRFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 13:05:51 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 3/5] mac80211: add functions to duplicate a cfg80211_beacon
Date: Fri,  7 Jun 2013 19:05:43 +0200
Message-Id: <1370624745-2267-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130607_190558_154349_9C007D77)
In-Reply-To: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the channel switch announcement, it is required to set a new beacon
after the driver arrived on the new channel. The new beacon will be set
by nl80211, but is required to duplicate the beacon as the original
memory within the netlink message will be gone. Add functions to
duplicate and free these cfg80211 beacons.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/cfg.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3062210..1f8e5cf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2775,6 +2775,82 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	return 0;
 }
 
+static void cfg80211_beacon_free(struct cfg80211_beacon_data *beacon)
+{
+	kfree(beacon->head);
+	kfree(beacon->tail);
+	kfree(beacon->beacon_ies);
+	kfree(beacon->proberesp_ies);
+	kfree(beacon->assocresp_ies);
+	kfree(beacon->probe_resp);
+	kfree(beacon);
+}
+
+static struct cfg80211_beacon_data *
+cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
+{
+	struct cfg80211_beacon_data *new_beacon;
+	new_beacon = kzalloc(sizeof(*new_beacon), GFP_KERNEL);
+	if (!beacon)
+		return NULL;
+
+	if (beacon->head_len) {
+		new_beacon->head = kmalloc(beacon->head_len, GFP_KERNEL);
+		new_beacon->head_len = beacon->head_len;
+		if (!new_beacon->head)
+			goto error;
+		memcpy((u8 *)new_beacon->head, beacon->head, beacon->head_len);
+	}
+	if (beacon->tail_len) {
+		new_beacon->tail = kmalloc(beacon->tail_len, GFP_KERNEL);
+		new_beacon->tail_len = beacon->tail_len;
+		if (!new_beacon->tail)
+			goto error;
+		memcpy((u8 *)new_beacon->tail, beacon->tail, beacon->tail_len);
+	}
+	if (beacon->beacon_ies_len) {
+		new_beacon->beacon_ies = kmalloc(beacon->beacon_ies_len,
+						 GFP_KERNEL);
+		new_beacon->beacon_ies_len = beacon->beacon_ies_len;
+		if (!new_beacon->beacon_ies)
+			goto error;
+		memcpy((u8 *)new_beacon->beacon_ies, beacon->beacon_ies,
+		       beacon->beacon_ies_len);
+	}
+	if (beacon->proberesp_ies_len) {
+		new_beacon->proberesp_ies = kmalloc(beacon->proberesp_ies_len,
+						    GFP_KERNEL);
+		new_beacon->proberesp_ies_len = beacon->proberesp_ies_len;
+		if (!new_beacon->proberesp_ies)
+			goto error;
+		memcpy((u8 *)new_beacon->proberesp_ies, beacon->proberesp_ies,
+		       beacon->proberesp_ies_len);
+	}
+	if (beacon->assocresp_ies_len) {
+		new_beacon->assocresp_ies = kmalloc(beacon->assocresp_ies_len,
+						    GFP_KERNEL);
+		new_beacon->assocresp_ies_len = beacon->assocresp_ies_len;
+		if (!new_beacon->assocresp_ies)
+			goto error;
+		memcpy((u8 *)new_beacon->assocresp_ies, beacon->assocresp_ies,
+		       beacon->assocresp_ies_len);
+	}
+	if (beacon->probe_resp_len) {
+		new_beacon->probe_resp = kmalloc(beacon->probe_resp_len,
+						 GFP_KERNEL);
+		new_beacon->probe_resp_len = beacon->probe_resp_len;
+		if (!new_beacon->probe_resp)
+			goto error;
+		memcpy((u8 *)new_beacon->probe_resp, beacon->probe_resp,
+		       beacon->probe_resp_len);
+	}
+
+	return new_beacon;
+error:
+	cfg80211_beacon_free(new_beacon);
+	return NULL;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     unsigned int wait, const u8 *buf, size_t len,
-- 
1.7.10.4

