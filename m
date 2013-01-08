Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44611 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3AHNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 2/6] cfg80211: check radar interface combinations
Date: Tue,  8 Jan 2013 14:04:07 +0100
Message-Id: <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140504_468558_CE80F607)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To ease further DFS development regarding interface combinations, use
the interface combinations structure to test for radar capabilities.
Drivers can specify which channel widths they support, and in which
modes. Drivers should first allow AP mode only, but can later allow
MultiSSID APs, AP+Ad-Hoc, etc.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    3 +++
 net/wireless/core.c          |   11 +++++++++--
 net/wireless/core.h          |    7 ++++---
 net/wireless/nl80211.c       |    3 +++
 net/wireless/util.c          |   32 +++++++++++++++++++++++++++++---
 6 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5f085c..8671feb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2092,6 +2092,7 @@ struct ieee80211_iface_limit {
  * @beacon_int_infra_match: In this combination, the beacon intervals
  *	between infrastructure and AP types must match. This is required
  *	only in special cases.
+ * @radar_detect_widths: bitmap of channel widths supported for radar detection
  *
  * These examples can be expressed as follows:
  *
@@ -2144,6 +2145,7 @@ struct ieee80211_iface_combination {
 	u16 max_interfaces;
 	u8 n_limits;
 	bool beacon_int_infra_match;
+	u8 radar_detect_widths;
 };
 
 struct mac_address {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5470171..c8730d2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2937,6 +2937,8 @@ enum nl80211_iface_limit_attrs {
  *	the infrastructure network's beacon interval.
  * @NL80211_IFACE_COMB_NUM_CHANNELS: u32 attribute specifying how many
  *	different channels may be used within this group.
+ * @NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS: u32 attribute containing the bitmap
+ *	of supported channel widths for radar detection.
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -2969,6 +2971,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_MAXNUM,
 	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
 	NL80211_IFACE_COMB_NUM_CHANNELS,
+	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 747dd93..7978d0e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -382,8 +382,10 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 
 		c = &wiphy->iface_combinations[i];
 
-		/* Combinations with just one interface aren't real */
-		if (WARN_ON(c->max_interfaces < 2))
+		/* Combinations with just one interface aren't real,
+		 * however we make an exception for DFS.
+		 */
+		if (WARN_ON((c->max_interfaces < 2) && !c->radar_detect_widths))
 			return -EINVAL;
 
 		/* Need at least one channel */
@@ -398,6 +400,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				CFG80211_MAX_NUM_DIFFERENT_CHANNELS))
 			return -EINVAL;
 
+		/* DFS only works on one channel. */
+		if (WARN_ON(c->radar_detect_widths &&
+			    (c->num_different_channels > 1)))
+			return -EINVAL;
+
 		if (WARN_ON(!c->n_limits))
 			return -EINVAL;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f342267..8396f76 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -425,7 +425,8 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 enum nl80211_iftype iftype,
 				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode);
+				 enum cfg80211_chan_mode chanmode,
+				 u8 radar_detect);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
@@ -433,7 +434,7 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      enum nl80211_iftype iftype)
 {
 	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
-					    CHAN_MODE_UNDEFINED);
+					    CHAN_MODE_UNDEFINED, 0);
 }
 
 static inline int
@@ -450,7 +451,7 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 		      enum cfg80211_chan_mode chanmode)
 {
 	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					    chan, chanmode);
+					    chan, chanmode, 0);
 }
 
 void
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 62e98f5..ea7d492 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -856,6 +856,9 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		    nla_put_u32(msg, NL80211_IFACE_COMB_MAXNUM,
 				c->max_interfaces))
 			goto nla_put_failure;
+		if (nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
+				c->radar_detect_widths))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 16d76a8..72476e8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1184,7 +1184,8 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 enum nl80211_iftype iftype,
 				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode)
+				 enum cfg80211_chan_mode chanmode,
+				 u8 radar_detect)
 {
 	struct wireless_dev *wdev_iter;
 	u32 used_iftypes = BIT(iftype);
@@ -1195,14 +1196,36 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
 	int total = 1;
+	bool radar_required;
 	int i, j;
 
 	ASSERT_RTNL();
 	lockdep_assert_held(&rdev->devlist_mtx);
 
+	if (WARN_ON(hweight32(radar_detect) > 1))
+		return -EINVAL;
+
+	switch (iftype) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_P2P_GO:
+		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
+		break;
+	default:
+		radar_required = false;
+	}
+
+	if (radar_required && !radar_detect)
+		return -EINVAL;
+
 	/* Always allow software iftypes */
-	if (rdev->wiphy.software_iftypes & BIT(iftype))
+	if (rdev->wiphy.software_iftypes & BIT(iftype)) {
+		if (radar_detect)
+			return -EINVAL;
 		return 0;
+	}
 
 	memset(num, 0, sizeof(num));
 	memset(used_channels, 0, sizeof(used_channels));
@@ -1275,7 +1298,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 
-	if (total == 1)
+	if (total == 1 && !radar_detect)
 		return 0;
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
@@ -1308,6 +1331,9 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 			}
 		}
 
+		if (radar_detect && !(c->radar_detect_widths & radar_detect))
+			goto cont;
+
 		/*
 		 * Finally check that all iftypes that we're currently
 		 * using are actually part of this combination. If they
-- 
1.7.10.4

