Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54335 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3CNHd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 03:33:26 -0400
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Date: Thu, 14 Mar 2013 09:33:20 +0200
Subject: [RFC 3/3] mac80211: P2P add NOA settings
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com> (sfid-20130314_083329_391100_23876DBF)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add P2P NOA settings for STA mode.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/mac80211.h |   19 +++++++++++++++++++
 net/mac80211/mlme.c    |   40 +++++++++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cdd7cea..4e13f2a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -264,6 +264,24 @@ enum ieee80211_rssi_event {
 	RSSI_EVENT_LOW,
 };
 
+/* struct p2p_noa_desc - holds Notice of Absence parameters
+ *
+ * This structure keeps parameters used in case of Notice
+ * of Absence - P2P PS.
+ *
+ * @count: 1-255 - number of absence intervals.
+ *	   0 - special meaning - descriptor not used
+ * @duration: maximum duration in units of microseconds
+ * @interval: length of NOA in microseconds
+ * @start_time: lower 4 bytes of TSF timer
+ */
+struct p2p_noa_desc {
+	u8 count;
+	u32 duration;
+	u32 interval;
+	u32 start_time;
+};
+
 /**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
@@ -365,6 +383,7 @@ struct ieee80211_bss_conf {
 	int txpower;
 	u8 p2p_ctwindow;
 	bool p2p_oppps;
+	struct p2p_noa_desc p2p_noa_desc[IEEE80211_P2P_NOA_DESC_MAX];
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4fecfb8..7e282ea 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1629,6 +1629,30 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
+static u8 ieee80211_setup_noa_attr(struct ieee80211_bss_conf *bss_conf,
+				   struct ieee80211_p2p_noa_attr *noa)
+{
+	u8 noa_index;
+	int i;
+
+	noa_index = noa->index;
+	bss_conf->p2p_oppps = noa->oppps_ctwindow & 0x80;
+	bss_conf->p2p_ctwindow = noa->oppps_ctwindow & 0x7f;
+
+	for (i = 0; i < IEEE80211_P2P_NOA_DESC_MAX; i++) {
+		bss_conf->p2p_noa_desc[i].count =
+					noa->desc[i].count;
+		bss_conf->p2p_noa_desc[i].duration =
+				le32_to_cpu(noa->desc[i].duration);
+		bss_conf->p2p_noa_desc[i].interval =
+				le32_to_cpu(noa->desc[i].interval);
+		bss_conf->p2p_noa_desc[i].start_time =
+				le32_to_cpu(noa->desc[i].start_time);
+	}
+
+	return noa_index;
+}
+
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss,
 				     u32 bss_info_changed)
@@ -1655,7 +1679,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
 		if (ies) {
-			struct ieee80211_p2p_noa_attr noa;
+			struct ieee80211_p2p_noa_attr noa = {0};
 			int ret;
 
 			ret = cfg80211_get_p2p_attr(
@@ -1663,10 +1687,9 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 					IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 					(u8 *) &noa, sizeof(noa));
 			if (ret >= 2) {
-				bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
-				bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
+				sdata->u.mgd.p2p_noa_index =
+					ieee80211_setup_noa_attr(bss_conf, &noa);
 				bss_info_changed |= BSS_CHANGED_P2P_PS;
-				sdata->u.mgd.p2p_noa_index = noa.index;
 			}
 		}
 		rcu_read_unlock();
@@ -2953,18 +2976,17 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (sdata->vif.p2p) {
-		struct ieee80211_p2p_noa_attr noa;
+		struct ieee80211_p2p_noa_attr noa = {0};
 		int ret;
 
 		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
 					    len - baselen,
 					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 					    (u8 *) &noa, sizeof(noa));
-		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
-			bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
-			bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
+		if (sdata->u.mgd.p2p_noa_index != noa.index) {
+			sdata->u.mgd.p2p_noa_index =
+					ieee80211_setup_noa_attr(bss_conf, &noa);
 			changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa.index;
 			/*
 			 * make sure we update all information, the CRC
 			 * mechanism doesn't look at P2P attributes.
-- 
1.7.9.5

