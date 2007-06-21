Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58918 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbXFUCKJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 22:10:09 -0400
Subject: [PATCH]mac80211: add support for iwlist channel (3rd try)
From: Hong Liu <hong.liu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 21 Jun 2007 10:07:08 +0800
Message-Id: <1182391628.27548.8.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add supported channels info in SIOCGIWRANGE implementation.

Signed-off-by: Hong Liu <hong.liu@intel.com>
---
 net/mac80211/ieee80211_ioctl.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index fcea8b2..9b5122a 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1500,6 +1500,8 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_range *range = (struct iw_range *) extra;
+	struct ieee80211_hw_mode *mode = NULL;
+	int c = 0;
 
 	data->length = sizeof(struct iw_range);
 	memset(range, 0, sizeof(struct iw_range));
@@ -1533,6 +1535,29 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	list_for_each_entry(mode, &local->modes_list, list) {
+		int i = 0;
+
+		if (!(local->enabled_modes & (1 << mode->mode)) ||
+		    (local->hw_modes & local->enabled_modes &
+		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+			continue;
+
+		while (i < mode->num_channels && c < IW_MAX_FREQUENCIES) {
+			struct ieee80211_channel *chan = &mode->channels[i];
+
+			if (chan->flag & IEEE80211_CHAN_W_SCAN) {
+				range->freq[c].i = chan->chan;
+				range->freq[c].m = chan->freq * 100000;
+				range->freq[c].e = 1;
+				c++;
+			}
+			i++;
+		}
+	}
+	range->num_channels = c;
+	range->num_frequency = c;
+
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
-- 
1.5.0.5

