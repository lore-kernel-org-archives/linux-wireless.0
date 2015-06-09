Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35507 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbbFIUAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:00:52 -0400
Received: by iesa3 with SMTP id a3so20847652ies.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 13:00:52 -0700 (PDT)
Message-ID: <557745EB.9080907@cococorp.com> (sfid-20150609_220106_006787_5643C673)
Date: Tue, 09 Jun 2015 13:00:43 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Subject: [PATCH v2]: mac80211: Always check rates and capabilities in mesh
 mode
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mesh mode there is a race between establishing links and processing
rates and capabilities in beacons. This is very noticeable with slow
beacons (e.g. beacon intervals of 1s) and manifested for us as stations
using minstrel when minstrel_ht should be used. Fixed by changing
mesh_sta_info_init so that it always checks rates and such if it has not
already done so.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ac843fc..54656af 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -394,8 +394,9 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	sta->last_rx = jiffies;
 
 	/* rates and capabilities don't change during peering */
-	if (sta->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->plink_state == NL80211_PLINK_ESTAB && sta->processed_beacon)
 		goto out;
+	sta->processed_beacon = true;
 
 	if (sta->sta.supp_rates[band] != rates)
 		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9bd1e97..226f8ca4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -369,6 +369,8 @@ struct ieee80211_fast_tx {
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *	entry for non-QoS frames
  * @fast_tx: TX fastpath information
+ * @processed_beacon: set to true after peer rates and capabilities are
+ *	processed
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -473,6 +475,7 @@ struct sta_info {
 	enum nl80211_mesh_power_mode local_pm;
 	enum nl80211_mesh_power_mode peer_pm;
 	enum nl80211_mesh_power_mode nonpeer_pm;
+	bool processed_beacon;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
