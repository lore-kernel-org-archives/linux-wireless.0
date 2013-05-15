Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36123 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182Ab3EOOTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 08/18] cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
Date: Wed, 15 May 2013 16:18:59 +0200
Message-Id: <1368627549-22518-9-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162936_990619_55185BEC)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some regulations (like germany, but also FCC) express their transmission
power limit in dBm/MHz or mW/MHz. To cope with that and be on the safe
side, reduce the maximum power to half (10 MHz) or quarter (5 MHz)
when operating on these reduced bandwidth channels.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |   25 +++++++++++++++++++++++++
 net/mac80211/iface.c   |    2 +-
 net/mac80211/main.c    |    2 +-
 net/mac80211/mlme.c    |    3 ++-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d4c687a..4e4a447 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -472,6 +472,31 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
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
+		return chandef->chan->max_power - 6;
+	case NL80211_CHAN_WIDTH_10:
+		return chandef->chan->max_power - 3;
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
index 28a38a7..3d859c7 100644
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
index f6b6b57..eda4427 100644
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
index 837a580..a7fd1db 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -798,7 +798,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
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

