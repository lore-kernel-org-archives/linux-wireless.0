Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1397 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbbCRGqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 02:46:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg/mac80211: add regulatory classes IE during TDLS setup
Date: Wed, 18 Mar 2015 08:46:08 +0200
Message-Id: <1426661168-11610-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150318_074617_001545_C0F2DCB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Seems Broadcom TDLS peers (Nexus 5, Xperia Z3) refuse to allow TDLS
connection when channel-switching is supported but the regulatory
classes IE is missing from the setup request.
Add a chandef to reg-class translation function to cfg80211 and use it
to add the required IE during setup. For now add only the current
regulatory class as supported - it is enough to resolve the
compatibility issue.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h |  11 +++++
 net/mac80211/tdls.c    |  21 ++++++++
 net/wireless/util.c    | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 161 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 12a6121..c4d873b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4903,6 +4903,17 @@ void cfg80211_ch_switch_started_notify(struct net_device *dev,
 bool ieee80211_operating_class_to_band(u8 operating_class,
 				       enum ieee80211_band *band);
 
+/**
+ * ieee80211_chandef_to_operating_class - convert chandef to operation class
+ *
+ * @chandef: the chandef to convert
+ * @op_class: a pointer to the resulting operating class
+ *
+ * Returns %true if the conversion was successful, %false otherwise.
+ */
+bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
+					  u8 *op_class);
+
 /*
  * cfg80211_tdls_oper_request - request userspace to perform TDLS operation
  * @dev: the device on which the operation is requested
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index bc7e404..79ed59a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -136,6 +136,24 @@ ieee80211_tdls_add_supp_channels(struct ieee80211_sub_if_data *sdata,
 	*pos = 2 * subband_cnt;
 }
 
+static void ieee80211_tdls_add_oper_classes(struct ieee80211_sub_if_data *sdata,
+					    struct sk_buff *skb)
+{
+	u8 *pos;
+	u8 op_class;
+
+	if (!ieee80211_chandef_to_operating_class(&sdata->vif.bss_conf.chandef,
+						  &op_class))
+		return;
+
+	pos = skb_put(skb, 4);
+	*pos++ = WLAN_EID_SUPPORTED_REGULATORY_CLASSES;
+	*pos++ = 2; /* len */
+
+	*pos++ = op_class;
+	*pos++ = op_class; /* give current operating class as alternate too */
+}
+
 static void ieee80211_tdls_add_bss_coex_ie(struct sk_buff *skb)
 {
 	u8 *pos = (void *)skb_put(skb, 3);
@@ -350,6 +368,8 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	ieee80211_tdls_add_oper_classes(sdata, skb);
+
 	/*
 	 * with TDLS we can switch channels, and HT-caps are not necessarily
 	 * the same on all bands. The specification limits the setup to a
@@ -786,6 +806,7 @@ ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
 			       50 + /* supported channels */
 			       3 + /* 40/20 BSS coex */
 			       4 + /* AID */
+			       4 + /* oper classes */
 			       extra_ies_len +
 			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f7b3598..f218b15 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1314,6 +1314,135 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
 }
 EXPORT_SYMBOL(ieee80211_operating_class_to_band);
 
+bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
+					  u8 *op_class)
+{
+	u8 vht_opclass;
+	u16 freq = chandef->center_freq1;
+
+	if (freq >= 2412 && freq <= 2472) {
+		if (chandef->width > NL80211_CHAN_WIDTH_40)
+			return false;
+
+		/* 2.407 GHz, channels 1..13 */
+		if (chandef->width == NL80211_CHAN_WIDTH_40) {
+			if (freq > chandef->chan->center_freq)
+				*op_class = 83; /* HT40+ */
+			else
+				*op_class = 84; /* HT40- */
+		} else {
+			*op_class = 81;
+		}
+
+		return true;
+	}
+
+	if (freq == 2484) {
+		if (chandef->width > NL80211_CHAN_WIDTH_40)
+			return false;
+
+		*op_class = 82; /* channel 14 */
+		return true;
+	}
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80:
+		vht_opclass = 128;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		vht_opclass = 129;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		vht_opclass = 130;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+	case NL80211_CHAN_WIDTH_5:
+		return false; /* unsupported for now */
+	default:
+		vht_opclass = 0;
+		break;
+	}
+
+	/* 5 GHz, channels 36..48 */
+	if (freq >= 5180 && freq <= 5240) {
+		if (vht_opclass) {
+			*op_class = vht_opclass;
+		} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+			if (freq > chandef->chan->center_freq)
+				*op_class = 116;
+			else
+				*op_class = 117;
+		} else {
+			*op_class = 115;
+		}
+
+		return true;
+	}
+
+	/* 5 GHz, channels 52..64 */
+	if (freq >= 5260 && freq <= 5320) {
+		if (vht_opclass) {
+			*op_class = vht_opclass;
+		} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+			if (freq > chandef->chan->center_freq)
+				*op_class = 119;
+			else
+				*op_class = 120;
+		} else {
+			*op_class = 118;
+		}
+
+		return true;
+	}
+
+	/* 5 GHz, channels 100..144 */
+	if (freq >= 5500 && freq <= 5720) {
+		if (vht_opclass) {
+			*op_class = vht_opclass;
+		} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+			if (freq > chandef->chan->center_freq)
+				*op_class = 122;
+			else
+				*op_class = 123;
+		} else {
+			*op_class = 121;
+		}
+
+		return true;
+	}
+
+	/* 5 GHz, channels 149..169 */
+	if (freq >= 5745 && freq <= 5845) {
+		if (vht_opclass) {
+			*op_class = vht_opclass;
+		} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+			if (freq > chandef->chan->center_freq)
+				*op_class = 126;
+			else
+				*op_class = 127;
+		} else if (freq <= 5805) {
+			*op_class = 124;
+		} else {
+			*op_class = 125;
+		}
+
+		return true;
+	}
+
+	/* 56.16 GHz, channel 1..4 */
+	if (freq >= 56160 + 2160 * 1 && freq <= 56160 + 2160 * 4) {
+		if (chandef->width >= NL80211_CHAN_WIDTH_40)
+			return false;
+
+		*op_class = 180;
+		return true;
+	}
+
+	/* not supported yet */
+	return false;
+}
+EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int)
 {
-- 
1.9.1

