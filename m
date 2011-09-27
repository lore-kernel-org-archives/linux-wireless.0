Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1I0S4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 14:56:16 -0400
Subject: [PATCH] cfg80211/mac80211: apply station uAPSD parameters
 selectively
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:56:12 +0200
Message-ID: <1317149772.1931.4.camel@jlt3.sipsolutions.net> (sfid-20110927_205621_889232_76432483)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, when hostapd sets the station as authorized
we also overwrite its uAPSD parameter. This obviously
leads to buggy behaviour (later, with my patches that
actually add uAPSD support). To fix this, only apply
those parameters if they were actually set in nl80211,
and to achieve that add a bitmap of things to apply.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
So it'd be possible to fix this much simpler by moving the code, but I'm
doing it like this for two reasons:

1) we might later want to implement TSPEC handling and allow them to
change
2) it adds the bitmap that others can build on in the future for other
parameters

 include/net/cfg80211.h |   12 ++++++++++++
 net/mac80211/cfg.c     |    6 ++++--
 net/wireless/nl80211.c |    2 ++
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c	2011-09-27 20:37:01.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-09-27 20:37:55.000000000 +0200
@@ -714,8 +714,10 @@ static void sta_apply_parameters(struct
 	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
-	sta->sta.uapsd_queues = params->uapsd_queues;
-	sta->sta.max_sp = params->max_sp;
+	if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD) {
+		sta->sta.uapsd_queues = params->uapsd_queues;
+		sta->sta.max_sp = params->max_sp;
+	}
 
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID
--- a/include/net/cfg80211.h	2011-09-27 20:37:00.000000000 +0200
+++ b/include/net/cfg80211.h	2011-09-27 20:37:55.000000000 +0200
@@ -424,6 +424,17 @@ enum plink_actions {
 };
 
 /**
+ * enum station_parameters_apply_mask - station parameter values to apply
+ * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
+ *
+ * Not all station parameters have in-band "no change" signalling,
+ * for those that don't these flags will are used.
+ */
+enum station_parameters_apply_mask {
+	STATION_PARAM_APPLY_UAPSD = BIT(0),
+};
+
+/**
  * struct station_parameters - station parameters
  *
  * Used to change and create a new station.
@@ -450,6 +461,7 @@ struct station_parameters {
 	u8 *supported_rates;
 	struct net_device *vlan;
 	u32 sta_flags_mask, sta_flags_set;
+	u32 sta_modify_mask;
 	int listen_interval;
 	u16 aid;
 	u8 supported_rates_len;
--- a/net/wireless/nl80211.c	2011-09-27 20:37:01.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-09-27 20:37:55.000000000 +0200
@@ -2636,6 +2636,8 @@ static int nl80211_new_station(struct sk
 
 		if (params.max_sp & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
 			return -EINVAL;
+
+		params.sta_modify_mask |= STATION_PARAM_APPLY_UAPSD;
 	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&


