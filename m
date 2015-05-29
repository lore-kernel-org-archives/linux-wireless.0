Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35241 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbbE2WYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 18:24:45 -0400
Received: by labko7 with SMTP id ko7so62156495lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 15:24:44 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 May 2015 15:24:44 -0700
Message-ID: <CAAnMG+MdokAvP4YNHnPX+o+0vi2vDfYB8Bj0x-kSci0yDa+bEg@mail.gmail.com> (sfid-20150530_002449_472835_CA9451BC)
Subject: [PATCH] mac80211: Always check rates and capabilities in mesh mode
From: Alexis Green <agreen@cococorp.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mesh mode there is a race between establishing links and processing rates
and capabilities in beacons. This is very noticeable with slow beacons (e.g.
beacon intervals of 1s) and manifested for us as stations using minstrel when
minstrel_ht should be used. Fixed by changing mesh_sta_info_init so that it
always checks rates and such if it has not already done so.

Signed-off-by: Alexis Green <agreen@cococorp.com>
CC: Jesse Jones <jjones@cococorp.com>

---

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ac843fc..4f9f23c 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -394,8 +394,9 @@ static void mesh_sta_info_init(struct
ieee80211_sub_if_data *sdata,
        sta->last_rx = jiffies;

        /* rates and capabilities don't change during peering */
-       if (sta->plink_state == NL80211_PLINK_ESTAB)
+       if (sta->plink_state == NL80211_PLINK_ESTAB && sta->processedBeacon)
                goto out;
+       sta->processedBeacon = true;

        if (sta->sta.supp_rates[band] != rates)
                changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9bd1e97..e3ae2b0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -369,6 +369,8 @@ struct ieee80211_fast_tx {
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *     entry for non-QoS frames
  * @fast_tx: TX fastpath information
+ * @processedBeacon: set to true after peer rates and capabilities are
+ *     processed
  */
 struct sta_info {
        /* General information, mostly static */
@@ -473,6 +475,7 @@ struct sta_info {
        enum nl80211_mesh_power_mode local_pm;
        enum nl80211_mesh_power_mode peer_pm;
        enum nl80211_mesh_power_mode nonpeer_pm;
+       bool processedBeacon;
 #endif

 #ifdef CONFIG_MAC80211_DEBUGFS
