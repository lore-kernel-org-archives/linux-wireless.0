Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38767 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbYGNMbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:31:33 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
Date: Mon, 14 Jul 2008 15:31:24 +0300
Message-Id: <1216038684-29725-2-git-send-email-tomas.winkler@intel.com> (sfid-20080714_143137_516908_45AE6A21)
In-Reply-To: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes listen_interval configurable by low level driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/main.c    |    3 +++
 net/mac80211/mlme.c    |    6 ++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f249820..677ba29 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -423,6 +423,7 @@ enum ieee80211_conf_flags {
  * @radio_enabled: when zero, driver is required to switch off the radio.
  *	TODO make a flag
  * @beacon_int: beacon interval (TODO make interface config)
+ * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
  * @max_antenna_gain: maximum antenna gain (in dBi)
@@ -437,6 +438,7 @@ struct ieee80211_conf {
 	int radio_enabled;
 
 	int beacon_int;
+	u16 listen_interval;
 	u32 flags;
 	int power_level;
 	int max_antenna_gain;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index cf477ad..b4b0c2d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1750,6 +1750,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.conf.beacon_int < 10)
 		local->hw.conf.beacon_int = 100;
 
+	if (local->hw.conf.listen_interval == 0)
+		local->hw.conf.listen_interval = 1;
+
 	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
 						  IEEE80211_HW_SIGNAL_DB |
 						  IEEE80211_HW_SIGNAL_DBM) ?
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 22eaf86..73566e6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -778,7 +778,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						   IEEE80211_STYPE_REASSOC_REQ);
 		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval = cpu_to_le16(1);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
 		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
 		       ETH_ALEN);
 	} else {
@@ -786,7 +787,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						   IEEE80211_STYPE_ASSOC_REQ);
 		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.assoc_req.listen_interval = cpu_to_le16(1);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
 	}
 
 	/* SSID */
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

