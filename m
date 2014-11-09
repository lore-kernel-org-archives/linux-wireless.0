Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64933 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKIQui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:38 -0500
Received: by mail-wi0-f173.google.com with SMTP id n3so8438558wiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:37 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/16] mac80211: track AP and peer STA TDLS chan-switch support
Date: Sun,  9 Nov 2014 18:50:15 +0200
Message-Id: <1415551822-20121-9-git-send-email-arik@wizery.com> (sfid-20141109_175045_376393_E6A8B33E)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AP or peer can prohibit TDLS channel switch via a bit in the
extended capabilities IE. Parse the IE and track this bit. Set an
appropriate STA flag if both the AP and peer STA support TDLS
channel-switching.

Add the new STA flag and the missing TDLS_INITIATOR to debugfs.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c         | 7 +++++++
 net/mac80211/debugfs_sta.c | 5 +++--
 net/mac80211/ieee80211_i.h | 3 +++
 net/mac80211/mlme.c        | 3 +++
 net/mac80211/sta_info.h    | 2 ++
 net/mac80211/util.c        | 5 +++++
 6 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3d1611a..257edd2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1042,6 +1042,13 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			clear_sta_flag(sta, WLAN_STA_TDLS_PEER);
 	}
 
+	/* mark TDLS channel switch support, if the AP allows it */
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
+	    !sdata->u.mgd.tdls_chan_switch_prohibited &&
+	    params->ext_capab_len >= 4 &&
+	    params->ext_capab[3] & WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH)
+		set_sta_flag(sta, WLAN_STA_TDLS_CHAN_SWITCH);
+
 	if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD) {
 		sta->sta.uapsd_queues = params->uapsd_queues;
 		sta->sta.max_sp = params->max_sp;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index bafe489..2ba7f53 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -74,7 +74,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -82,7 +82,8 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(WDS), TEST(CLEAR_PS_FILT),
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
-			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
+			    TEST(TDLS_PEER_AUTH), TEST(TDLS_INITIATOR),
+			    TEST(TDLS_CHAN_SWITCH), TEST(4ADDR_EVENT),
 			    TEST(INSERTED), TEST(RATE_CONTROL),
 			    TEST(TOFFSET_KNOWN), TEST(MPSP_OWNER),
 			    TEST(MPSP_RECIPIENT));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 53eb41f..4b3a7e7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -531,6 +531,7 @@ struct ieee80211_if_managed {
 	struct sk_buff *orig_teardown_skb; /* The original teardown skb */
 	struct sk_buff *teardown_skb; /* A copy to send through the AP */
 	spinlock_t teardown_lock; /* To lock changing teardown_skb */
+	bool tdls_chan_switch_prohibited;
 
 	/* WMM-AC TSPEC support */
 	struct ieee80211_sta_tx_tspec tx_tspec[IEEE80211_NUM_ACS];
@@ -1399,6 +1400,7 @@ struct ieee802_11_elems {
 	size_t total_len;
 
 	/* pointers to IEs */
+	const u8 *ext_capab;
 	const u8 *ssid;
 	const u8 *supp_rates;
 	const u8 *ds_params;
@@ -1433,6 +1435,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
 
 	/* length of them, respectively */
+	u8 ext_capab_len;
 	u8 ssid_len;
 	u8 supp_rates_len;
 	u8 tim_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc7f088..6851dd4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2797,6 +2797,9 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ifmgd->aid = aid;
+	ifmgd->tdls_chan_switch_prohibited =
+		elems.ext_capab && elems.ext_capab_len >= 5 &&
+		(elems.ext_capab[4] & WLAN_EXT_CAPA5_TDLS_CH_SW_PROHIBITED);
 
 	/*
 	 * Some APs are erroneously not including some information in their
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index bcda2ac..b6702c8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -49,6 +49,7 @@
  *	packets. This means the link is enabled.
  * @WLAN_STA_TDLS_INITIATOR: We are the initiator of the TDLS link with this
  *	station.
+ * @WLAN_STA_TDLS_CHAN_SWITCH: This TDLS peer supports TDLS channel-switching
  * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
@@ -78,6 +79,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TDLS_PEER,
 	WLAN_STA_TDLS_PEER_AUTH,
 	WLAN_STA_TDLS_INITIATOR,
+	WLAN_STA_TDLS_CHAN_SWITCH,
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f9319a5..3ca0c2e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -831,6 +831,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
 		case WLAN_EID_CHAN_SWITCH_PARAM:
+		case WLAN_EID_EXT_CAPABILITY:
 		/*
 		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
 		 * that if the content gets bigger it might be needed more than once
@@ -850,6 +851,10 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		elem_parse_failed = false;
 
 		switch (id) {
+		case WLAN_EID_EXT_CAPABILITY:
+			elems->ext_capab = pos;
+			elems->ext_capab_len = elen;
+			break;
 		case WLAN_EID_SSID:
 			elems->ssid = pos;
 			elems->ssid_len = elen;
-- 
1.9.1

