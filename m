Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab0CSK6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 06:58:21 -0400
Date: Fri, 19 Mar 2010 11:56:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC PATCH 1/2] mac80211: add interface for disabling QoS
Message-ID: <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net> <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com> <1268774282.4054.1.camel@jlt3.sipsolutions.net> <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com> <1268841106.5989.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268841106.5989.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add BSS_CHANGE_QOS_DISABLED flag to pass to drivers when want to disable
QoS (aka WMM, WME).

When AP do not provide QoS parameters, we should assume that it not
supporting QoS and we should not send QoS frames to it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/mlme.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d7d44..11a192d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,6 +144,7 @@ struct ieee80211_low_level_stats {
  *	new beacon (beaconing modes)
  * @BSS_CHANGED_BEACON_ENABLED: Beaconing should be
  *	enabled/disabled (beaconing modes)
+ * @BSS_CHANGED_QOS_DISABLED: QoS should be disabled
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -156,6 +157,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BSSID		= 1<<7,
 	BSS_CHANGED_BEACON		= 1<<8,
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
+	BSS_CHANGED_QOS_DISABLED	= 1<<10,
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..64be5f4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1130,7 +1130,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
-		ieee80211_set_wmm_default(sdata);
+		changed |= BSS_CHANGED_QOS_DISABLED;
 
 	local->oper_channel = wk->chan;
 
-- 
1.6.2.5

