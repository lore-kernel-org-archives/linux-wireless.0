Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbbCLGxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/7] mac80211: ignore CSA to same channel
Date: Thu, 12 Mar 2015 08:53:26 +0200
Message-Id: <1426143210-25635-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075347_999236_B85EA5C7)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the AP is confused and starts doing a CSA to the same channel,
just ignore that request instead of trying to act it out since it
was likely sent in error anyway.

In the case of the bug I was investigating the GO was misbehaving
and sending out a beacon with CSA IEs still included after having
actually done the channel switch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0266c57..994d1b3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -453,6 +453,7 @@ struct ieee80211_if_managed {
 	unsigned int flags;
 
 	bool csa_waiting_bcn;
+	bool csa_ignored_same_chan;
 
 	bool beacon_crc_valid;
 	u32 beacon_crc;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1999bc0..6205206 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1150,6 +1150,17 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	if (cfg80211_chandef_identical(&csa_ie.chandef,
+				       &sdata->vif.bss_conf.chandef)) {
+		if (ifmgd->csa_ignored_same_chan)
+			return;
+		sdata_info(sdata,
+			   "AP %pM tries to chanswitch to same channel, ignore\n",
+			   ifmgd->associated->bssid);
+		ifmgd->csa_ignored_same_chan = true;
+		return;
+	}
+
 	mutex_lock(&local->mtx);
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
@@ -1194,6 +1205,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.csa_active = true;
 	sdata->csa_chandef = csa_ie.chandef;
 	sdata->csa_block_tx = csa_ie.mode;
+	ifmgd->csa_ignored_same_chan = false;
 
 	if (sdata->csa_block_tx)
 		ieee80211_stop_vif_queues(local, sdata,
@@ -2076,6 +2088,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
+	ifmgd->csa_ignored_same_chan = false;
 	if (sdata->csa_block_tx) {
 		ieee80211_wake_vif_queues(local, sdata,
 					  IEEE80211_QUEUE_STOP_REASON_CSA);
-- 
1.9.1

