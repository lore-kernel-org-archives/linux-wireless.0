Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbXFRItu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 04:49:50 -0400
Subject: [patch]mac80211: add support for iwlist channel
From: Hong Liu <hong.liu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 18 Jun 2007 16:47:05 +0800
Message-Id: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add supported channels info in SIOCGIWRANGE implementation.

Signed-off-by: Hong Liu <hong.liu@intel.com>

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index fcea8b2..3ea3ad8 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1493,6 +1493,40 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
 	return 0;
 }
 
+static int is_duplicate_channel(struct ieee80211_channel *chan,
+				struct iw_freq *freq, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++, freq++)
+		if (chan->chan == freq->i)
+			return 1;
+
+	return 0;
+}
+
+static void ieee80211_get_supp_channels(struct ieee80211_local *local,
+				struct iw_range *range)
+{
+	struct ieee80211_hw_mode *mode = NULL;
+	int c = 0, j;
+
+	list_for_each_entry(mode, &local->modes_list, list) {
+		for (j = 0;
+		     j < mode->num_channels && c < IW_MAX_FREQUENCIES; j++) {
+			struct ieee80211_channel *chan = &mode->channels[j];
+
+			if (is_duplicate_channel(chan, range->freq, c))
+				continue;
+			range->freq[c].i = chan->chan;
+			range->freq[c].m = chan->freq * 100000;
+			range->freq[c].e = 1;
+			c++;
+		}
+	}
+	range->num_channels = c;
+	range->num_frequency = c;
+}
 
 static int ieee80211_ioctl_giwrange(struct net_device *dev,
 				 struct iw_request_info *info,
@@ -1533,6 +1567,8 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	ieee80211_get_supp_channels(local, range);
+
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
