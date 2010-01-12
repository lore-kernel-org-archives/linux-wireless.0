Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32804 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0ALInW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:22 -0500
Subject: [PATCH PATCH v6 1/7] mac80211: add U-APSD client support
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:42:31 +0200
Message-ID: <20100112084231.27492.77457.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Add Unscheduled Automatic Power-Save Delivery (U-APSD) client support. The
idea is that the data frames from the client trigger AP to send the buffered
frames with ACs which have U-APSD enabled. This decreases latency and makes it
possible to save even more power.

Driver needs to use IEEE80211_HW_UAPSD to enable the feature. The current
implementation assumes that firmware takes care of the wakeup and
hardware needing IEEE80211_HW_PS_NULLFUNC_STACK is not yet supported.

Tested with wl1251 on a Nokia N900 and Cisco Aironet 1231G AP and running
various test traffic with ping.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/ieee80211.h  |   18 ++++++++++++++++++
 include/net/mac80211.h     |    7 +++++++
 net/mac80211/cfg.c         |    7 +++++++
 net/mac80211/ieee80211_i.h |   13 ++++++++++++-
 net/mac80211/main.c        |    4 ++++
 net/mac80211/mlme.c        |   31 ++++++++++++++++++++++++++++---
 net/mac80211/scan.c        |   18 ++++++++++++++++++
 net/mac80211/util.c        |    2 ++
 net/mac80211/work.c        |   12 ++++++++++--
 9 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aeea282..b2b41f8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -120,6 +120,24 @@
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
 #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
 
+/* U-APSD queue for WMM IEs sent by AP */
+#define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
+
+/* U-APSD queues for WMM IEs sent by STA */
+#define IEEE80211_WMM_IE_STA_QOSINFO_AC_VO	(1<<0)
+#define IEEE80211_WMM_IE_STA_QOSINFO_AC_VI	(1<<1)
+#define IEEE80211_WMM_IE_STA_QOSINFO_AC_BK	(1<<2)
+#define IEEE80211_WMM_IE_STA_QOSINFO_AC_BE	(1<<3)
+#define IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK	0x0f
+
+/* U-APSD max SP length for WMM IEs sent by STA */
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL	0x00
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_2	0x01
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_4	0x02
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_6	0x03
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
+#define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5
+
 struct ieee80211_hdr {
 	__le16 frame_control;
 	__le16 duration_id;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f073a2a..f27cb4d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -113,6 +113,7 @@ struct ieee80211_tx_queue_params {
 	u16 cw_min;
 	u16 cw_max;
 	u8 aifs;
+	bool uapsd;
 };
 
 /**
@@ -933,6 +934,11 @@ enum ieee80211_tkip_key_type {
  *	Hardware supports dynamic spatial multiplexing powersave,
  *	ie. can turn off all but one chain and then wake the rest
  *	up as required after, for example, rts/cts handshake.
+ *
+ * @IEEE80211_HW_SUPPORTS_UAPSD:
+ *	Hardware supports Unscheduled Automatic Power Save Delivery
+ *	(U-APSD) in managed mode. The mode is configured with
+ *	conf_tx() operation.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -952,6 +958,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_BEACON_FILTER			= 1<<14,
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
+	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2e5e841..0a432c4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1128,6 +1128,13 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 	p.cw_max = params->cwmax;
 	p.cw_min = params->cwmin;
 	p.txop = params->txop;
+
+	/*
+	 * Setting tx queue params disables u-apsd because it's only
+	 * called in master mode.
+	 */
+	p.uapsd = false;
+
 	if (drv_conf_tx(local, params->queue, &p)) {
 		printk(KERN_DEBUG "%s: failed to set TX queue "
 		       "parameters for queue %d\n",
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a27921e..165de3d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -58,6 +58,15 @@ struct ieee80211_local;
 
 #define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
 
+#define IEEE80211_DEFAULT_UAPSD_QUEUES \
+	(IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |	\
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE |	\
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |	\
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+
+#define IEEE80211_DEFAULT_MAX_SP_LEN		\
+	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -78,6 +87,7 @@ struct ieee80211_bss {
 	u8 dtim_period;
 
 	bool wmm_used;
+	bool uapsd_supported;
 
 	unsigned long last_probe_resp;
 
@@ -285,7 +295,7 @@ struct ieee80211_work {
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
 			u8 ssid_len;
 			u8 supp_rates_len;
-			bool wmm_used, use_11n;
+			bool wmm_used, use_11n, uapsd_used;
 		} assoc;
 		struct {
 			u32 duration;
@@ -306,6 +316,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_11N	= BIT(4),
 	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
+	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4688291..0054bba 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -491,6 +491,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
+	WARN((local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
+	     && (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK),
+	     "U-APSD not supported with HW_PS_NULLFUNC_STACK\n");
+
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 97bcf22..e52ee47 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -567,7 +567,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	struct ieee80211_tx_queue_params params;
 	size_t left;
 	int count;
-	u8 *pos;
+	u8 *pos, uapsd_queues = 0;
 
 	if (local->hw.queues < 4)
 		return;
@@ -577,6 +577,10 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
+
+	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
+		uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)
 		return;
@@ -591,6 +595,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	for (; left >= 4; left -= 4, pos += 4) {
 		int aci = (pos[0] >> 5) & 0x03;
 		int acm = (pos[0] >> 4) & 0x01;
+		bool uapsd = false;
 		int queue;
 
 		switch (aci) {
@@ -598,22 +603,30 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			queue = 3;
 			if (acm)
 				local->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
+				uapsd = true;
 			break;
 		case 2: /* AC_VI */
 			queue = 1;
 			if (acm)
 				local->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
+				uapsd = true;
 			break;
 		case 3: /* AC_VO */
 			queue = 0;
 			if (acm)
 				local->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+				uapsd = true;
 			break;
 		case 0: /* AC_BE */
 		default:
 			queue = 2;
 			if (acm)
 				local->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
+				uapsd = true;
 			break;
 		}
 
@@ -621,11 +634,14 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
 		params.txop = get_unaligned_le16(pos + 2);
+		params.uapsd = uapsd;
+
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
-		       "cWmin=%d cWmax=%d txop=%d\n",
+		       "cWmin=%d cWmax=%d txop=%d uapsd=%d\n",
 		       wiphy_name(local->hw.wiphy), queue, aci, acm,
-		       params.aifs, params.cw_min, params.cw_max, params.txop);
+		       params.aifs, params.cw_min, params.cw_max, params.txop,
+		       params.uapsd);
 #endif
 		if (drv_conf_tx(local, queue, &params) && local->ops->conf_tx)
 			printk(KERN_DEBUG "%s: failed to set TX queue "
@@ -1897,6 +1913,15 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	wk->assoc.ht_information_ie =
 		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_INFORMATION);
 
+	if (bss->wmm_used && bss->uapsd_supported &&
+	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
+		wk->assoc.uapsd_used = true;
+		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
+	} else {
+		wk->assoc.uapsd_used = false;
+		ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
+	}
+
 	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
 	memcpy(wk->assoc.ssid, ssid + 2, ssid[1]);
 	wk->assoc.ssid_len = ssid[1];
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a4c63d4..b7371a9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -54,6 +54,23 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 	cfg80211_put_bss(container_of((void *)bss, struct cfg80211_bss, priv));
 }
 
+static bool is_uapsd_supported(struct ieee802_11_elems *elems)
+{
+	u8 qos_info;
+
+	if (elems->wmm_info && elems->wmm_info_len == 7
+	    && elems->wmm_info[5] == 1)
+		qos_info = elems->wmm_info[6];
+	else if (elems->wmm_param && elems->wmm_param_len == 24
+		 && elems->wmm_param[5] == 1)
+		qos_info = elems->wmm_param[6];
+	else
+		/* no valid wmm information or parameter element found */
+		return false;
+
+	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
+}
+
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
@@ -117,6 +134,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	}
 
 	bss->wmm_used = elems->wmm_param || elems->wmm_info;
+	bss->uapsd_supported = is_uapsd_supported(elems);
 
 	if (!beacon)
 		bss->last_probe_resp = jiffies;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bc73904..206aeed 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -792,6 +792,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 			break;
 		}
 
+		qparam.uapsd = false;
+
 		drv_conf_tx(local, queue, &qparam);
 	}
 }
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 5ba7599..ee6182d 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -202,7 +202,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
+	u8 *pos, qos_info;
 	const u8 *ies;
 	size_t offset = 0, noffset;
 	int i, len, count, rates_len, supp_rates_len;
@@ -375,6 +375,14 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (wk->assoc.wmm_used && local->hw.queues >= 4) {
+		if (wk->assoc.uapsd_used) {
+			qos_info = IEEE80211_DEFAULT_UAPSD_QUEUES;
+			qos_info |= (IEEE80211_DEFAULT_MAX_SP_LEN <<
+				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
+		} else {
+			qos_info = 0;
+		}
+
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
@@ -384,7 +392,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 		*pos++ = 2; /* WME */
 		*pos++ = 0; /* WME info */
 		*pos++ = 1; /* WME ver */
-		*pos++ = 0;
+		*pos++ = qos_info;
 	}
 
 	/* add any remaining custom (i.e. vendor specific here) IEs */

