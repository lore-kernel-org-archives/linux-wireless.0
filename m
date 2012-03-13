Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62200 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2CMOrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 10:47:39 -0400
Received: by eaaq10 with SMTP id q10so32406eaa.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 07:47:37 -0700 (PDT)
From: Paul Stewart <pstew@chromium.org>
Date: Tue, 13 Mar 2012 07:46:18 -0700
Subject: [PATCH RESEND] mac80211: Don't let regulatory make us deaf
To: linux-wireless@vger.kernel.org
Cc: sleffler@chromium.org, johannes@sipsolutions.net,
	mcgrof@frijolero.org
Message-Id: <20120313144736.7DC272046A@glenhelen.mtv.corp.google.com> (sfid-20120313_154743_484969_03750987)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When regulatory information changes our HT behavior (e.g,
when we get a country code from the AP we have just associated
with), we should use this information to change the power with
which we transmit, and what channels we transmit.  Sometimes
the channel parameters we derive from regulatory information
contradicts the parameters we used in association.  For example,
we could have associated specifying HT40, but the regulatory
rules we apply may forbid HT40 operation.

In the situation above, we should reconfigure ourselves to
transmit in HT20 only, however it makes no sense for us to
disable receive in HT40, since if we associated with these
parameters, the AP has every reason to expect we can and
will receive packets this way.  The code in mac80211 does
not have the capability of sending the appropriate action
frames to signal a change in HT behaviour so the AP has
no clue we can no longer receive frames encoded this way.
In some broken AP implementations, this can leave us
effectively deaf if the AP never retries in lower HT rates.

This change breaks up the channel_type parameter in the
ieee80211_enable_ht function into a separate receive and
transmit part.  It honors the channel flags set by regulatory
in order to configure the rate control algorithm, but uses
the capability flags to configure the channel on the radio,
since these were used in association to set the AP's transmit
rate.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Cc: Sam Leffler <sleffler@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis R Rodriguez <mcgrof@frijolero.org>
---
 net/mac80211/chan.c        |   27 +++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   32 ++++++++++++++++----------------
 net/mac80211/rx.c          |    8 +++++---
 4 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index d1f7abd..e00ce8c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/nl80211.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
 
 static enum ieee80211_chan_mode
@@ -134,3 +135,29 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 
 	return result;
 }
+
+/*
+ * ieee80211_get_tx_channel_type returns the channel type we should
+ * use for packet transmission, given the channel capability and
+ * whatever regulatory flags we have been given.
+ */
+enum nl80211_channel_type ieee80211_get_tx_channel_type(
+				struct ieee80211_local *local,
+				enum nl80211_channel_type channel_type)
+{
+	switch (channel_type) {
+	case NL80211_CHAN_HT40PLUS:
+		if (local->hw.conf.channel->flags &
+				IEEE80211_CHAN_NO_HT40PLUS)
+			return NL80211_CHAN_HT20;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		if (local->hw.conf.channel->flags &
+				IEEE80211_CHAN_NO_HT40MINUS)
+			return NL80211_CHAN_HT20;
+		break;
+	default:
+		break;
+	}
+	return channel_type;
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 74594f0..a385342 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1468,6 +1468,9 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				enum nl80211_channel_type chantype);
 enum nl80211_channel_type
 ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);
+enum nl80211_channel_type ieee80211_get_tx_channel_type(
+					struct ieee80211_local *local,
+					enum nl80211_channel_type channel_type);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 52133da..4f90cb6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -187,7 +187,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	u16 ht_opmode;
 	bool enable_ht = true;
 	enum nl80211_channel_type prev_chantype;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type rx_channel_type = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type tx_channel_type;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -220,7 +221,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (enable_ht) {
-		channel_type = NL80211_CHAN_HT20;
+		rx_channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 		    !ieee80111_cfg_override_disables_ht40(sdata) &&
@@ -228,29 +229,28 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40PLUS))
-					channel_type = NL80211_CHAN_HT40PLUS;
+				rx_channel_type = NL80211_CHAN_HT40PLUS;
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40MINUS))
-					channel_type = NL80211_CHAN_HT40MINUS;
+				rx_channel_type = NL80211_CHAN_HT40MINUS;
 				break;
 			}
 		}
 	}
 
+	tx_channel_type = ieee80211_get_tx_channel_type(local, rx_channel_type);
+
 	if (local->tmp_channel)
-		local->tmp_channel_type = channel_type;
+		local->tmp_channel_type = rx_channel_type;
 
-	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+	if (!ieee80211_set_channel_type(local, sdata, rx_channel_type)) {
 		/* can only fail due to HT40+/- mismatch */
-		channel_type = NL80211_CHAN_HT20;
-		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
+		rx_channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+						    rx_channel_type));
 	}
 
-	if (beacon_htcap_ie && (prev_chantype != channel_type)) {
+	if (beacon_htcap_ie && (prev_chantype != rx_channel_type)) {
 		/*
 		 * Whenever the AP announces the HT mode change that can be
 		 * 40MHz intolerant or etc., it would be safer to stop tx
@@ -268,13 +268,13 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
-	if (prev_chantype != channel_type) {
+	if (prev_chantype != tx_channel_type) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
 						 IEEE80211_RC_HT_CHANGED,
-						 channel_type);
+						 tx_channel_type);
 		rcu_read_unlock();
 
 		if (beacon_htcap_ie)
@@ -287,7 +287,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	/* if bss configuration changed store the new one */
 	if (sdata->ht_opmode_valid != enable_ht ||
 	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode ||
-	    prev_chantype != channel_type) {
+	    prev_chantype != rx_channel_type) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 		sdata->ht_opmode_valid = enable_ht;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3ab85c0..a1693cc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2266,9 +2266,11 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 			sband = rx->local->hw.wiphy->bands[status->band];
 
-			rate_control_rate_update(local, sband, rx->sta,
-						 IEEE80211_RC_SMPS_CHANGED,
-						 local->_oper_channel_type);
+			rate_control_rate_update(
+				local, sband, rx->sta,
+				IEEE80211_RC_SMPS_CHANGED,
+				ieee80211_get_tx_channel_type(
+					local, local->_oper_channel_type));
 			goto handled;
 		}
 		default:
-- 
1.7.7.3

