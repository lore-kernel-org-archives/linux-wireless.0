Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33460 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937331AbdAKPhw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 10:37:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>
Subject: [PATCH 1/3] cfg80211: consider VHT opmode on station update
Date: Wed, 11 Jan 2017 16:37:46 +0100
Message-Id: <20170111153748.797-1-johannes@sipsolutions.net> (sfid-20170111_163802_456597_258D962F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Currently, this attribute is only fetched on station addition, but
not on station change. Since this info is only present in the assoc
request, with full station state support in the driver it cannot be
present when the station is added.

Thus, add support for changing the VHT opmode on station update if
done before (or while) the station is marked as associated. After
this, ignore it, since it used to be ignored.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  4 +++-
 net/wireless/nl80211.c       | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6b76e3b0c18e..bea982af9cfb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1772,7 +1772,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_OPMODE_NOTIF: Operating mode field from Operating Mode
  *	Notification Element based on association request when used with
- *	%NL80211_CMD_NEW_STATION; u8 attribute.
+ *	%NL80211_CMD_NEW_STATION or %NL80211_CMD_SET_STATION (only when
+ *	%NL80211_FEATURE_FULL_AP_CLIENT_STATE is supported, or with TDLS);
+ *	u8 attribute.
  *
  * @NL80211_ATTR_VENDOR_ID: The vendor ID, either a 24-bit OUI or, if
  *	%NL80211_VENDOR_ID_IS_LINUX is set, a special Linux ID (not used yet)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ef5eff93a8b8..5c1b267e22be 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4615,6 +4615,15 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		break;
 	}
 
+	/*
+	 * Older kernel versions ignored this attribute entirely, so don't
+	 * reject attempts to update it but mark it as unused instead so the
+	 * driver won't look at the data.
+	 */
+	if (statype != CFG80211_STA_AP_CLIENT_UNASSOC &&
+	    statype != CFG80211_STA_TDLS_PEER_SETUP)
+		params->opmode_notif_used = false;
+
 	return 0;
 }
 EXPORT_SYMBOL(cfg80211_check_station_change);
@@ -4854,6 +4863,12 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.local_pm = pm;
 	}
 
+	if (info->attrs[NL80211_ATTR_OPMODE_NOTIF]) {
+		params.opmode_notif_used = true;
+		params.opmode_notif =
+			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
+	}
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
-- 
2.9.3
