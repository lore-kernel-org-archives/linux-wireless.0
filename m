Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02051C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 18:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C062170E
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 18:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1C062170E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbeI1AaF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:30:05 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:59884 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeI1AaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 20:30:05 -0400
Received: from ben-dt3.candelatech.com (firewall.candelatech.com [50.251.239.81])
        by mail2.candelatech.com (Postfix) with ESMTP id 30AC040A626;
        Thu, 27 Sep 2018 11:10:34 -0700 (PDT)
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Improve connection-loss probing.
Date:   Thu, 27 Sep 2018 11:10:29 -0700
Message-Id: <1538071829-18527-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 2.4.11
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

This makes the mlme code probe multiple times spread out across
the time-out period instead of lots of probes all at once.

It also makes the ap-probe and the nullfunc probe logic
act similarly, which allows us to remove some code.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/mlme.c        | 62 ++++++++++++++++++----------------------------
 2 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 17de2d0..0a0f693 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -444,7 +444,6 @@ struct ieee80211_if_managed {
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
 	int probe_send_count;
-	bool nullfunc_failed;
 	bool connection_loss;
 
 	struct cfg80211_bss *associated;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a1b08af..eb784ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2203,8 +2203,6 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 	    sdata->u.mgd.probe_send_count > 0) {
 		if (ack)
 			ieee80211_sta_reset_conn_monitor(sdata);
-		else
-			sdata->u.mgd.nullfunc_failed = true;
 		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 		return;
 	}
@@ -2220,6 +2218,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	u8 *dst = ifmgd->associated->bssid;
 	u8 unicast_limit = max(1, max_probe_tries - 3);
 	struct sta_info *sta;
+	u32 max_tries;
 
 	/*
 	 * Try sending broadcast probe requests for the last three
@@ -2247,11 +2246,13 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
-		ifmgd->nullfunc_failed = false;
+		max_tries = max_nullfunc_tries;
 		ieee80211_send_nullfunc(sdata->local, sdata, false);
 	} else {
 		int ssid_len;
 
+		max_tries = max_probe_tries;
+
 		rcu_read_lock();
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 		if (WARN_ON_ONCE(ssid == NULL))
@@ -2266,7 +2267,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		rcu_read_unlock();
 	}
 
-	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
+	ifmgd->probe_timeout = jiffies +
+		msecs_to_jiffies(probe_wait_ms / max_tries);
 	run_again(sdata, ifmgd->probe_timeout);
 }
 
@@ -3978,54 +3980,38 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 		int max_tries;
+		bool ack_status = ieee80211_hw_check(&local->hw,
+						     REPORTS_TX_ACK_STATUS);
 
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+		if (ack_status)
 			max_tries = max_nullfunc_tries;
 		else
 			max_tries = max_probe_tries;
 
 		/* ACK received for nullfunc probing frame */
-		if (!ifmgd->probe_send_count)
+		if (!ifmgd->probe_send_count) {
+			/* probe_send_count of zero means probe succeeded */
 			ieee80211_reset_ap_probe(sdata);
-		else if (ifmgd->nullfunc_failed) {
-			if (ifmgd->probe_send_count < max_tries) {
-				mlme_dbg(sdata,
-					 "No ack for nullfunc frame to AP %pM, try %d/%i\n",
-					 bssid, ifmgd->probe_send_count,
-					 max_tries);
-				ieee80211_mgd_probe_ap_send(sdata);
-			} else {
-				mlme_wrn(sdata,
-					 "No ack for nullfunc frame to AP %pM, disconnecting.\n",
-					 bssid);
-				ieee80211_sta_connection_lost(sdata, bssid,
-					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-					false);
-			}
-		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
+		} else if (time_is_after_jiffies(ifmgd->probe_timeout)) {
+			/* probe_timeout is after current jiffies
+			 * Not time to (re)probe yet
+			 */
 			run_again(sdata, ifmgd->probe_timeout);
-		else if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
-			mlme_wrn(sdata,
-				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
-				 bssid, probe_wait_ms);
-			ieee80211_sta_connection_lost(sdata, bssid,
-				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
 		} else if (ifmgd->probe_send_count < max_tries) {
-			mlme_dbg(sdata,
-				 "No probe response from AP %pM after %dms, try %d/%i\n",
-				 bssid, probe_wait_ms,
-				 ifmgd->probe_send_count, max_tries);
+			mlme_dbg(sdata, "No %s AP %pM, try %d/%i\n",
+				 ack_status ? "ack for nullfunc frame to" :
+				 "probe response from",
+				 bssid, ifmgd->probe_send_count, max_tries);
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
-			/*
-			 * We actually lost the connection ... or did we?
-			 * Let's make sure!
-			 */
 			mlme_wrn(sdata,
-				 "No probe response from AP %pM after %dms, disconnecting.\n",
-				 bssid, probe_wait_ms);
+				 "No %s AP %pM after %dms, tried %d/%i, disconnecting.\n",
+				 ack_status ? "ack for nullfunc frame to" :
+				 "probe response from",
+				  bssid, probe_wait_ms, ifmgd->probe_send_count,
+				  max_tries);
 
 			ieee80211_sta_connection_lost(sdata, bssid,
 				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
-- 
2.4.11

