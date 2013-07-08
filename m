Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58664 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3GHO4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:19 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 07/18] cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
Date: Mon,  8 Jul 2013 16:55:55 +0200
Message-Id: <1373295366-12823-8-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_165624_838953_2A7F364A)
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some regulations (like germany, but also FCC) express their transmission
power limit in dBm/MHz or mW/MHz. To cope with that and be on the safe
side, reduce the maximum power to half (10 MHz) or quarter (5 MHz)
when operating on these reduced bandwidth channels.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Changes to PATCHv3:
 * consider max_reg_power, max_power might contain the hardware limit
---
 include/net/cfg80211.h |   27 +++++++++++++++++++++++++++
 net/mac80211/iface.c   |    2 +-
 net/mac80211/main.c    |    2 +-
 net/mac80211/mlme.c    |    3 ++-
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4ca16ab..75471ee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -461,6 +461,33 @@ ieee80211_chandef_rate_flags(struct cfg80211_chan_def *chandef)
 }
 
 /**
+ * ieee80211_chandef_max_power - maximum transmission power for the chandef
+ *
+ * In some regulations, the transmit power may depend on the configured channel
+ * bandwidth which may be defined as dBm/MHz. This function returns the actual
+ * max_power for non-standard (20 MHz) channels.
+ *
+ * @chandef: channel definition for the channel
+ *
+ * Returns: maximum allowed transmission power in dBm for the chandef
+ */
+static inline int
+ieee80211_chandef_max_power(struct cfg80211_chan_def *chandef)
+{
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		return min(chandef->chan->max_reg_power - 6,
+			   chandef->chan->max_power);
+	case NL80211_CHAN_WIDTH_10:
+		return min(chandef->chan->max_reg_power - 3,
+			   chandef->chan->max_power);
+	default:
+		break;
+	}
+	return chandef->chan->max_power;
+}
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a2a8250..093c34a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -54,7 +54,7 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 		return false;
 	}
 
-	power = chanctx_conf->def.chan->max_power;
+	power = ieee80211_chandef_max_power(&chanctx_conf->def);
 	rcu_read_unlock();
 
 	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 626c83c..a1d51af 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -151,7 +151,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	power = chandef.chan->max_power;
+	power = ieee80211_chandef_max_power(&chandef);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f7552c2..211246b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -747,7 +747,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = chan->max_power; /* max tx power */
+		 /* max tx power */
+		*pos++ = ieee80211_chandef_max_power(&chanctx_conf->def);
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
-- 
1.7.10.4

