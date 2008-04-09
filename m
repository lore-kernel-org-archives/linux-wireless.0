Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYDJAFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 20:05:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH RFC v2] mac80211: no BSS changes to driver from beacons processed during scanning
Date: Wed,  9 Apr 2008 16:56:15 -0700
Message-Id: <1207785375-13470-1-git-send-email-reinette.chatre@intel.com> (sfid-20080410_010541_441570_040FDAE3)
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
This patch applies to the latest code after mac80211 filename changes.

 include/net/mac80211.h |    3 +--
 net/mac80211/mlme.c    |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 079e7bd..4a80d74 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1020,8 +1020,7 @@ enum ieee80211_ampdu_mlme_action {
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
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 83e8b49..e3f2cb0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2797,6 +2797,17 @@ static void ieee80211_rx_mgmt_beacon(struct net_=
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
 	else {
@@ -2816,11 +2827,6 @@ static void ieee80211_rx_mgmt_beacon(struct net_=
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
