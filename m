Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49883 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2BUGJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 01:09:35 -0500
Received: by eekb15 with SMTP id b15so220983eek.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 22:09:33 -0800 (PST)
MIME-Version: 1.0
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpza10.eem.corp.google.com (Postfix) with ESMTP id 458A120004E
	for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 22:09:33 -0800 (PST)
From: Paul Stewart <pstew@chromium.org>
Date: Mon, 20 Feb 2012 21:25:54 -0800
Subject: [RFC] mac80211: Don't let regulatory make us deaf
To: linux-wireless@vger.kernel.org
Message-Id: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com> (sfid-20120221_070938_821553_FF9DC9D4)
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
---
 net/mac80211/mlme.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 52133da..22a1bcd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -187,7 +187,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	u16 ht_opmode;
 	bool enable_ht = true;
 	enum nl80211_channel_type prev_chantype;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type xmit_channel_type = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type recv_channel_type = NL80211_CHAN_NO_HT;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -220,7 +221,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (enable_ht) {
-		channel_type = NL80211_CHAN_HT20;
+		xmit_channel_type = NL80211_CHAN_HT20;
+		recv_channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 		    !ieee80111_cfg_override_disables_ht40(sdata) &&
@@ -228,26 +230,32 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				recv_channel_type = NL80211_CHAN_HT40PLUS;
 				if (!(local->hw.conf.channel->flags &
 				    IEEE80211_CHAN_NO_HT40PLUS))
-					channel_type = NL80211_CHAN_HT40PLUS;
+					xmit_channel_type =
+						NL80211_CHAN_HT40PLUS;
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				recv_channel_type = NL80211_CHAN_HT40MINUS;
 				if (!(local->hw.conf.channel->flags &
 				    IEEE80211_CHAN_NO_HT40MINUS))
-					channel_type = NL80211_CHAN_HT40MINUS;
+					xmit_channel_type =
+						NL80211_CHAN_HT40MINUS;
 				break;
 			}
 		}
 	}
 
 	if (local->tmp_channel)
-		local->tmp_channel_type = channel_type;
+		local->tmp_channel_type = recv_channel_type;
 
-	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+	if (!ieee80211_set_channel_type(local, sdata, recv_channel_type)) {
 		/* can only fail due to HT40+/- mismatch */
-		channel_type = NL80211_CHAN_HT20;
-		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
+		xmit_channel_type = NL80211_CHAN_HT20;
+		recv_channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+						    recv_channel_type));
 	}
 
 	if (beacon_htcap_ie && (prev_chantype != channel_type)) {
@@ -268,13 +276,13 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
-	if (prev_chantype != channel_type) {
+	if (prev_chantype != xmit_channel_type) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
 						 IEEE80211_RC_HT_CHANGED,
-						 channel_type);
+						 xmit_channel_type);
 		rcu_read_unlock();
 
 		if (beacon_htcap_ie)
@@ -287,7 +295,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	/* if bss configuration changed store the new one */
 	if (sdata->ht_opmode_valid != enable_ht ||
 	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode ||
-	    prev_chantype != channel_type) {
+	    prev_chantype != recv_channel_type) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
 		sdata->ht_opmode_valid = enable_ht;
-- 
1.7.7.3

