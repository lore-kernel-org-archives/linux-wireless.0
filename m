Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53948 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab0ELVQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 17:16:09 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Move part of the MLME code to helper functions
Date: Wed, 12 May 2010 23:07:38 +0200
Message-Id: <1273698460-18061-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
References: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We moved code parsing the HT Operation IE to get the associated channel
type and the HT Capabilities IE generation code to util.c. This is a
preliminary step that will be used by HT IBSS code later.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ieee80211_i.h |   12 +++
 net/mac80211/mlme.c        |   20 +-----
 net/mac80211/util.c        |  179 ++++++++++++++++++++++++++++++++++++++------
 net/mac80211/work.c        |   96 -----------------------
 4 files changed, 170 insertions(+), 137 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 69e7f41..742e12b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1215,6 +1215,18 @@ size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 
+enum nl80211_channel_type ieee80211_channel_type_from_ht_info(
+	struct ieee80211_local *local,
+	struct ieee80211_ht_info *hti, u16 ap_ht_cap_flags);
+
+void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
+			 struct ieee80211_supported_band *sband,
+			 struct ieee80211_channel *channel,
+			 enum ieee80211_smps_mode smps);
+
+u8 *ieee80211_add_ht_cap(u8 *pos,
+			 struct ieee80211_supported_band *sband);
+
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
 void ieee80211_add_work(struct ieee80211_work *wk);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3093e46..55d96a6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -155,24 +155,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		enable_ht = false;
 
 	if (enable_ht) {
-		channel_type = NL80211_CHAN_HT20;
-
-		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
-			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40PLUS))
-					channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				if (!(local->hw.conf.channel->flags &
-				    IEEE80211_CHAN_NO_HT40MINUS))
-					channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
-		}
+		channel_type = ieee80211_channel_type_from_ht_info(local,
+					 hti, ap_ht_cap_flags);
 	}
 
 	if (local->tmp_channel)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5b79d55..4a76fa5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -965,29 +965,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported) {
-		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
-
-		if (ieee80211_disable_40mhz_24ghz &&
-		    sband->band == IEEE80211_BAND_2GHZ) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density <<
-				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
-	}
+	pos = ieee80211_add_ht_cap(pos, sband);
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1389,3 +1367,158 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
 
 	return pos;
 }
+
+enum nl80211_channel_type ieee80211_channel_type_from_ht_info(
+	struct ieee80211_local *local,
+	struct ieee80211_ht_info *hti, u16 ap_ht_cap_flags)
+{
+	struct ieee80211_supported_band *sband;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_HT20;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+	    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+	    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+		switch (hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			if (!(local->hw.conf.channel->flags &
+			      IEEE80211_CHAN_NO_HT40PLUS))
+				channel_type = NL80211_CHAN_HT40PLUS;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			if (!(local->hw.conf.channel->flags &
+			      IEEE80211_CHAN_NO_HT40MINUS))
+				channel_type = NL80211_CHAN_HT40MINUS;
+			break;
+		}
+	}
+
+	return channel_type;
+}
+
+u8 *ieee80211_add_ht_cap(u8 *pos,
+			 struct ieee80211_supported_band *sband)
+{
+	if (sband->ht_cap.ht_supported) {
+		u16 cap = sband->ht_cap.cap;
+		__le16 tmp;
+
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		tmp = cpu_to_le16(cap);
+		memcpy(pos, &tmp, sizeof(u16));
+		pos += sizeof(u16);
+		*pos++ = sband->ht_cap.ampdu_factor |
+			(sband->ht_cap.ampdu_density <<
+			 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		pos += sizeof(sband->ht_cap.mcs);
+		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
+	}
+
+	return pos;
+}
+
+void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
+			 struct ieee80211_supported_band *sband,
+			 struct ieee80211_channel *channel,
+			 enum ieee80211_smps_mode smps)
+{
+	struct ieee80211_ht_info *ht_info;
+	u8 *pos;
+	u32 flags = channel->flags;
+	u16 cap = sband->ht_cap.cap;
+	__le16 tmp;
+
+	if (!sband->ht_cap.ht_supported)
+		return;
+
+	if (!ht_info_ie)
+		return;
+
+	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
+		return;
+
+	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+	/* determine capability flags */
+
+	if (ieee80211_disable_40mhz_24ghz &&
+	    sband->band == IEEE80211_BAND_2GHZ) {
+		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		cap &= ~IEEE80211_HT_CAP_SGI_40;
+	}
+
+	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	}
+
+	/* set SM PS mode properly */
+	cap &= ~IEEE80211_HT_CAP_SM_PS;
+	switch (smps) {
+	case IEEE80211_SMPS_AUTOMATIC:
+	case IEEE80211_SMPS_NUM_MODES:
+		WARN_ON(1);
+	case IEEE80211_SMPS_OFF:
+		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_STATIC:
+		cap |= WLAN_HT_CAP_SM_PS_STATIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_DYNAMIC:
+		cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	}
+
+	/* reserve and fill IE */
+
+	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+
+	/* capability flags */
+	tmp = cpu_to_le16(cap);
+	memcpy(pos, &tmp, sizeof(u16));
+	pos += sizeof(u16);
+
+	/* AMPDU parameters */
+	*pos++ = sband->ht_cap.ampdu_factor |
+		 (sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+
+	/* MCS set */
+	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+	pos += sizeof(sband->ht_cap.mcs);
+
+	/* extended capabilities */
+	pos += sizeof(__le16);
+
+	/* BF capabilities */
+	pos += sizeof(__le32);
+
+	/* antenna selection */
+	pos += sizeof(u8);
+}
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 3dd0760..df6940d 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -101,102 +101,6 @@ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 
 /* frame sending functions */
 
-static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
-				struct ieee80211_supported_band *sband,
-				struct ieee80211_channel *channel,
-				enum ieee80211_smps_mode smps)
-{
-	struct ieee80211_ht_info *ht_info;
-	u8 *pos;
-	u32 flags = channel->flags;
-	u16 cap = sband->ht_cap.cap;
-	__le16 tmp;
-
-	if (!sband->ht_cap.ht_supported)
-		return;
-
-	if (!ht_info_ie)
-		return;
-
-	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
-		return;
-
-	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
-
-	/* determine capability flags */
-
-	if (ieee80211_disable_40mhz_24ghz &&
-	    sband->band == IEEE80211_BAND_2GHZ) {
-		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		cap &= ~IEEE80211_HT_CAP_SGI_40;
-	}
-
-	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-		break;
-	}
-
-	/* set SM PS mode properly */
-	cap &= ~IEEE80211_HT_CAP_SM_PS;
-	switch (smps) {
-	case IEEE80211_SMPS_AUTOMATIC:
-	case IEEE80211_SMPS_NUM_MODES:
-		WARN_ON(1);
-	case IEEE80211_SMPS_OFF:
-		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	case IEEE80211_SMPS_STATIC:
-		cap |= WLAN_HT_CAP_SM_PS_STATIC <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	case IEEE80211_SMPS_DYNAMIC:
-		cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	}
-
-	/* reserve and fill IE */
-
-	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-
-	/* capability flags */
-	tmp = cpu_to_le16(cap);
-	memcpy(pos, &tmp, sizeof(u16));
-	pos += sizeof(u16);
-
-	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
-		 (sband->ht_cap.ampdu_density <<
-			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-
-	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
-
-	/* extended capabilities */
-	pos += sizeof(__le16);
-
-	/* BF capabilities */
-	pos += sizeof(__le32);
-
-	/* antenna selection */
-	pos += sizeof(u8);
-}
-
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_work *wk)
 {
-- 
1.5.6.5

