Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.24]:19863 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752653AbeGDVFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 17:05:55 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 2A3E1659B
        for <linux-wireless@vger.kernel.org>; Wed,  4 Jul 2018 16:05:55 -0500 (CDT)
Date: Wed, 4 Jul 2018 16:05:53 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wireless: mark expected switch fall-throughs
Message-ID: <20180704210553.GA7869@embeddedor.com> (sfid-20180704_230610_929488_E181C288)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Warning level 2 was used: -Wimplicit-fallthrough=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/wireless/chan.c        | 2 ++
 net/wireless/nl80211.c     | 9 +++++++++
 net/wireless/wext-compat.c | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2db713d..145cb51 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -747,6 +747,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
+		/* else: fall through */
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
@@ -769,6 +770,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
+		/* else: fall through */
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
 			return false;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4e5f02..59b0ac5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1676,6 +1676,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
 			    sizeof(u32) * rdev->wiphy.n_cipher_suites,
@@ -1722,6 +1723,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					rdev->wiphy.interface_modes))
@@ -1729,6 +1731,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 3:
 		nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 		if (!nl_bands)
@@ -1754,6 +1757,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				state->chan_start++;
 				if (state->split)
 					break;
+				/* else: fall through */
 			default:
 				/* add frequencies */
 				nl_freqs = nla_nest_start(
@@ -1807,6 +1811,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 4:
 		nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
 		if (!nl_cmds)
@@ -1833,6 +1838,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 5:
 		if (rdev->ops->remain_on_channel &&
 		    (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL) &&
@@ -1850,6 +1856,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 6:
 #ifdef CONFIG_PM
 		if (nl80211_send_wowlan(msg, rdev, state->split))
@@ -1872,6 +1879,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start++;
 		if (state->split)
 			break;
+		/* else: fall through */
 	case 8:
 		if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
 		    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
@@ -4466,6 +4474,7 @@ static int parse_station_flags(struct genl_info *info,
 		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHENTICATED) |
 					 BIT(NL80211_STA_FLAG_MFP) |
 					 BIT(NL80211_STA_FLAG_AUTHORIZED);
+		/* fall through */
 	default:
 		return -EINVAL;
 	}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 167f702..9db3920 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1333,6 +1333,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sig + 110;
 			break;
 		}
+		/* else: fall through */
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
 		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
@@ -1341,6 +1342,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sinfo.signal;
 			break;
 		}
+		/* else: fall through */
 	default:
 		wstats.qual.updated |= IW_QUAL_LEVEL_INVALID;
 		wstats.qual.updated |= IW_QUAL_QUAL_INVALID;
-- 
2.7.4
