Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKKcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 05:32:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Subject: [PATCH] mac80211: reset probe_send_count also in HW_CONNECTION_MONITOR case
Date: Tue, 11 Feb 2014 12:30:18 +0200
Message-Id: <1392114618-26573-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140211_113217_088733_E7D1C172)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In case of beacon_loss with IEEE80211_HW_CONNECTION_MONITOR
device, mac80211 probes the ap (and disconnects on timeout)
but ignores the ack.

If we already got an ack, there's no reason to continue
disconnecting. this can help devices that supports
IEEE80211_HW_CONNECTION_MONITOR only partially (e.g. take
care of keep alives, but does not probe the ap.

In case the device wants to disconnect without probing,
it can just call ieee80211_connection_loss.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 include/net/mac80211.h | 2 --
 net/mac80211/mlme.c    | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 87a3cc6..c851249 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1507,8 +1507,6 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_CONNECTION_MONITOR:
  *	The hardware performs its own connection monitoring, including
  *	periodic keep-alives to the AP and probing the AP on beacon loss.
- *	When this flag is set, signaling beacon-loss will cause an immediate
- *	change to disassociated state.
  *
  * @IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC:
  *	This device needs to get data from beacon before association (i.e.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index da4b09e..a70a59e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -131,13 +131,13 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 	if (unlikely(!sdata->u.mgd.associated))
 		return;
 
+	ifmgd->probe_send_count = 0;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
-
-	ifmgd->probe_send_count = 0;
 }
 
 static int ecw2cw(int ecw)
-- 
1.8.3.2

