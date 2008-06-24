Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32491 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbYFXMug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 08:50:36 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/4 V2] mac80211: add phy information to giwname
Date: Tue, 24 Jun 2008 15:50:17 +0300
Message-Id: <1214311817-952-1-git-send-email-tomas.winkler@intel.com> (sfid-20080624_145112_551320_B29A93D9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add phy information to giwname.

Quoting:
It's not useless, it's supposed to tell you about the protocol
capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"

Jean

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wext.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 308b953..a44f479 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -135,7 +135,39 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
 				   struct iw_request_info *info,
 				   char *name, char *extra)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_supported_band *sband;
+	u8 is_ht = 0, is_a = 0, is_b = 0, is_g = 0;
+
+
+	sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
+	if (sband) {
+		is_a = 1;
+		is_ht |= sband->ht_info.ht_supported;
+	}
+
+	sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (sband) {
+		int i;
+		/* Check for mandatory rates */
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == 10)
+				is_b = 1;
+			if (sband->bitrates[i].bitrate == 60)
+				is_g = 1;
+		}
+		is_ht |= sband->ht_info.ht_supported;
+	}
+
 	strcpy(name, "IEEE 802.11");
+	if (is_a)
+		strcat(name, "a");
+	if (is_b)
+		strcat(name, "b");
+	if (is_g)
+		strcat(name, "g");
+	if (is_ht)
+		strcat(name, "n");
 
 	return 0;
 }
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

