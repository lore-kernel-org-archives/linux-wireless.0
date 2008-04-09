Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbYDIXb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 19:31:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH RFC] mac80211: no BSS changes to driver from beacons processed during scanning
Date: Wed,  9 Apr 2008 16:31:55 -0700
Message-Id: <1207783915-13260-1-git-send-email-reinette.chatre@intel.com> (sfid-20080410_003200_973599_A6CEC3E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to send BSS changes to driver from beacons processed
during scanning. We are more interested in beacons from an AP with whic=
h
we are associated - these will still be used to send updates to driver =
as
the beacons are received without scanning.

This change=C2=B7removes the requirement that bss_info_changed needs to=
 be atomic.
The beacons received during scanning are processed from a tasklet, but =
if we
do not call bss_info_changed for these beacons there is no need for it =
to be
atomic. This function (bss_info_changed) is called either from workqueu=
e or
ioctl in all other instances.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h       |    3 +--
 net/mac80211/ieee80211_sta.c |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0bc73e2..417b6aa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1019,8 +1019,7 @@ enum ieee80211_ampdu_mlme_action {
  *	level driver (e.g. assoc/disassoc status, erp parameters).
  *	This function should not be used if no BSS has been set, unless
  *	for association indication. The @changed parameter indicates which
- *	of the bss parameters has changed when a call is made. This callbac=
k
- *	has to be atomic.
+ *	of the bss parameters has changed when a call is made.
  *
  * @configure_filter: Configure the device's RX filter.
  *	See the section "Frame filtering" for more information.
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.=
c
index 5120e38..b469c8a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2791,6 +2791,17 @@ static void ieee80211_rx_mgmt_beacon(struct net_=
device *dev,
=20
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems=
);
=20
+	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
+					 elems.wmm_param_len);
+	}
+
+	/* Do not send changes to driver if we are scanning. This removes
+	 * requirement that driver's bss_info_changed function needs to be
+	 * atomic. */
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
+		return;
+
 	if (elems.erp_info && elems.erp_info_len >=3D 1)
 		changed |=3D ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
=20
@@ -2805,11 +2816,6 @@ static void ieee80211_rx_mgmt_beacon(struct net_=
device *dev,
 					       &bss_info);
 	}
=20
-	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
-					 elems.wmm_param_len);
-	}
-
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
=20
--=20
1.5.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
