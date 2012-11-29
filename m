Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:42518
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2K2IlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 03:41:13 -0500
Message-ID: <50B71FA3.7050304@posedge.com> (sfid-20121129_094116_195532_2694BE6B)
Date: Thu, 29 Nov 2012 14:11:07 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Remove unused VHT chan code
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

Cleanup of unused VHT channel config related code.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
  net/wireless/nl80211.c |   28 +---------------------------
  1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7cce43b..0e7e8d5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1371,9 +1371,7 @@ static int nl80211_parse_chandef(struct 
cfg80211_registered_device *rdev,
  				 struct genl_info *info,
  				 struct cfg80211_chan_def *chandef)
  {
-	struct ieee80211_sta_ht_cap *ht_cap;
-	struct ieee80211_sta_vht_cap *vht_cap;
-	u32 control_freq, width;
+	u32 control_freq;

  	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
  		return -EINVAL;
@@ -1419,33 +1417,9 @@ static int nl80211_parse_chandef(struct 
cfg80211_registered_device *rdev,
  					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
  	}

-	ht_cap = &rdev->wiphy.bands[chandef->chan->band]->ht_cap;
-	vht_cap = &rdev->wiphy.bands[chandef->chan->band]->vht_cap;
-
  	if (!cfg80211_chandef_valid(chandef))
  		return -EINVAL;

-	switch (chandef->width) {
-	case NL80211_CHAN_WIDTH_20:
-	case NL80211_CHAN_WIDTH_20_NOHT:
-		width = 20;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		width = 40;
-		break;
-	case NL80211_CHAN_WIDTH_80:
-		width = 80;
-		break;
-	case NL80211_CHAN_WIDTH_80P80:
-		width = 80;
-		break;
-	case NL80211_CHAN_WIDTH_160:
-		width = 160;
-		break;
-	default:
-		return -EINVAL;
-	}
-
  	if (!cfg80211_chandef_usable(&rdev->wiphy, chandef,
  				     IEEE80211_CHAN_DISABLED))
  		return -EINVAL;
-- 
Thanks,
Mahesh
