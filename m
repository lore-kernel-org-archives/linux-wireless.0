Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751470AbdHEIph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tova Mussai <tova.mussai@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:38 +0300
Message-Id: <20170805084438.12550-11-luca@coelho.fi> (sfid-20170805_104541_260351_B74BE5C8)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 10/10] nl80211: return error for invalid center_freq in 40 MHz
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tova Mussai <tova.mussai@intel.com>

When NL80211_ATTR_WIPHY_CHANNEL_TYPE is given, nl80211 would parse the
channel definition the old way, discarding NL80211_ATTR_CENTER_FREQ1,
NL80211_ATTR_CENTER_FREQ2 etc. However, it is possible that user space
added both NL80211_ATTR_WIPHY_CHANNEL_TYPE and NL80211_ATTR_CENTER_FREQ1
or NL80211_ATTR_CENTER_FREQ2 assuming that all settings would be honored.

In such a case, validate that NL80211_ATTR_CENTER_FREQ1 and
NL80211_ATTR_CENTER_FREQ2 values match the channel configuration,
as otherwise user space would assume that the desired configuration was
applied.

For example, when trying to start ap with
NL80211_ATTR_WIPHY_CHANNEL_TYPE = NL80211_CHAN_HT40MINUS,
NL80211_ATTR_WIPHY_FREQ = 5180 and NL80211_ATTR_CENTER_FREQ1 = 5250
without this fix, the ap will start on channel 36 (center_freq1 will be
corrected to 5180).  With this fix, we will throw an error instead.

Signed-off-by: Tova Mussai <tova.mussai@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 45ba3d0872cc..edf484fe1f80 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2122,6 +2122,15 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 		case NL80211_CHAN_HT40MINUS:
 			cfg80211_chandef_create(chandef, chandef->chan,
 						chantype);
+			/* user input for center_freq is incorrect */
+			if (info->attrs[NL80211_ATTR_CENTER_FREQ1] &&
+			    chandef->center_freq1 != nla_get_u32(
+					info->attrs[NL80211_ATTR_CENTER_FREQ1]))
+				return -EINVAL;
+			/* center_freq2 must be zero */
+			if (info->attrs[NL80211_ATTR_CENTER_FREQ2] &&
+			    nla_get_u32(info->attrs[NL80211_ATTR_CENTER_FREQ2]))
+				return -EINVAL;
 			break;
 		default:
 			return -EINVAL;
-- 
2.13.2
