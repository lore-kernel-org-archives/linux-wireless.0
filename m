Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYFXKiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:38:09 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/4] mac80211: add phy information to giwname
Date: Tue, 24 Jun 2008 13:38:01 +0300
Message-Id: <1214303881-31525-5-git-send-email-tomas.winkler@intel.com> (sfid-20080624_123816_338396_3888ADF1)
In-Reply-To: <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add phy information to giwname. Currently
802.11b is not treated.

Quoting:
It's not useless, it's supposed to tell you about the protocol
capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"

Jean

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wext.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 308b953..8778c7d 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -135,7 +135,24 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
 				   struct iw_request_info *info,
 				   char *name, char *extra)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_supported_band *sband;
+	u8 is_ht = 0;
+
 	strcpy(name, "IEEE 802.11");
+	sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	if (sband) {
+		strcat(name, "a");
+		is_ht |= sband->ht_info.ht_supported;
+	}
+	sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (sband) {
+		strcat(name, "g");
+		is_ht |= sband->ht_info.ht_supported;
+	}
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

