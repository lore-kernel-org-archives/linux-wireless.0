Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53782 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2BUNTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 08:19:49 -0500
Received: by eekb15 with SMTP id b15so234677eek.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 05:19:47 -0800 (PST)
MIME-Version: 1.0
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpza9.eem.corp.google.com (Postfix) with ESMTP id 71E855C0050
	for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 05:19:47 -0800 (PST)
In-Reply-To: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
From: Paul Stewart <pstew@chromium.org>
Date: Mon, 20 Feb 2012 21:25:54 -0800
Subject: [RFCv2] mac80211: Don't let regulatory make us deaf
To: linux-wireless@vger.kernel.org
Message-Id: <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com> (sfid-20120221_142005_568435_B65411B9)
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
 net/mac80211/chan.c        |   24 ++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   16 ++++++++--------
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index d1f7abd..494580a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/nl80211.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
 
 static enum ieee80211_chan_mode
@@ -134,3 +135,26 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 
 	return result;
 }
+
+/*
+ * ieee80211_get_xmit_channel_type returns the channel type we should
+ * use for packet transmission, given the channel capability and
+ * whatever regulatory flags we have been given.
+ */
+enum nl80211_channel_type ieee80211_get_xmit_channel_type(
+				struct ieee80211_local *local,
+				enum nl80211_channel_type channel_type) {
+	switch (channel_type) {
+	case NL80211_CHAN_HT40PLUS:
+		if ((local->hw.conf.channel->flags &
+		    IEEE80211_CHAN_NO_HT40PLUS))
+			return NL80211_CHAN_HT20;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		if ((local->hw.conf.channel->flags &
+		    IEEE80211_CHAN_NO_HT40MINUS))
+			return NL80211_CHAN_HT20;
+		break;
+	}
+	return channel_type;
+}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 74594f0..0a3c7df 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1468,6 +1468,9 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				enum nl80211_channel_type chantype);
 enum nl80211_channel_type
 ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);
+enum nl80211_channel_type ieee80211_get_xmit_channel_type(
+					struct ieee80211_local *local,
+					enum nl80211_channel_type channel_type);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 52133da..3bcf4e3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -188,6 +188,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	bool enable_ht = true;
 	enum nl80211_channel_type prev_chantype;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	enum nl80211_channel_type xmit_channel_type;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -228,19 +229,18 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40PLUS))
-					channel_type = NL80211_CHAN_HT40PLUS;
+				channel_type = NL80211_CHAN_HT40PLUS;
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40MINUS))
-					channel_type = NL80211_CHAN_HT40MINUS;
+				channel_type = NL80211_CHAN_HT40MINUS;
 				break;
 			}
 		}
 	}
 
+	xmit_channel_type =
+		ieee80211_get_xmit_channel_type(local, channel_type);
+
 	if (local->tmp_channel)
 		local->tmp_channel_type = channel_type;
 
@@ -268,13 +268,13 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
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
-- 
1.7.7.3

