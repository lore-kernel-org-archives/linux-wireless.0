Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32284 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZLAMGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 07:06:41 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C6OAa010420
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:06:45 +0200
Received: from [127.0.1.1] (essapo-nirac253175.europe.nokia.com [10.162.253.175])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C6eIg009983
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:06:40 +0200
Subject: [PATCH v3 1/2] mac80211: add U-APSD client support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 14:06:35 +0200
Message-ID: <20091201120635.4264.63154.stgit@tikku>
In-Reply-To: <20091201120508.4264.25010.stgit@tikku>
References: <20091201120508.4264.25010.stgit@tikku>
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

Tested with wl1251 and Cisco Aironet 1200 AP.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/ieee80211.h  |   12 ++++++++++++
 include/net/mac80211.h     |    6 ++++++
 net/mac80211/cfg.c         |    7 +++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |   39 ++++++++++++++++++++++++++++++++++-----
 net/mac80211/scan.c        |   18 ++++++++++++++++++
 net/mac80211/util.c        |    2 ++
 7 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d9724a2..b389965 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -120,6 +120,18 @@
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
 #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
 
+/* U-APSD queues for WMM IEs sent by STA */
+#define IEEE80211_WMM_IE_STA_AC_VO	(1<<0)
+#define IEEE80211_WMM_IE_STA_AC_VI	(1<<1)
+#define IEEE80211_WMM_IE_STA_AC_BK	(1<<2)
+#define IEEE80211_WMM_IE_STA_AC_BE	(1<<3)
+
+/* U-APSD max SP length for WMM IEs sent by STA */
+#define IEEE80211_WMM_IE_STA_SP_ALL	(0<<5)
+#define IEEE80211_WMM_IE_STA_SP_2	(2<<5)
+#define IEEE80211_WMM_IE_STA_SP_4	(1<<5)
+#define IEEE80211_WMM_IE_STA_SP_6	(3<<5)
+
 struct ieee80211_hdr {
 	__le16 frame_control;
 	__le16 duration_id;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1d75b96..2e484bc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -113,6 +113,7 @@ struct ieee80211_tx_queue_params {
 	u16 cw_min;
 	u16 cw_max;
 	u8 aifs;
+	bool uapsd;
 };
 
 /**
@@ -928,6 +929,10 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_BEACON_FILTER:
  *	Hardware supports dropping of irrelevant beacon frames to
  *	avoid waking up cpu.
+ *
+ * @IEEE80211_HW_UAPSD:
+ *	Hardware supports Unscheduled Automatic Power Save Delivery
+ *	(U-APSD).
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -945,6 +950,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_BEACON_FILTER			= 1<<14,
+	IEEE80211_HW_UAPSD				= 1<<15,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 93ee1fd..fd17958 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1134,6 +1134,13 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
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
index 785df97..94eaf21 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -81,6 +81,7 @@ struct ieee80211_bss {
 	u8 dtim_period;
 
 	bool wmm_used;
+	bool uapsd_supported;
 
 	unsigned long last_probe_resp;
 
@@ -264,6 +265,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_11N	= BIT(4),
 	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
+	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 };
 
 /* flags for MLME request */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6dc7b5a..c1c3f82 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -82,6 +82,8 @@ enum rx_mgmt_action {
 	RX_MGMT_CFG80211_ASSOC_TO,
 };
 
+#define IEEE80211_DEFAULT_UAPSD_QUEUES IEEE80211_WMM_IE_STA_AC_VO
+
 /* utils */
 static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
 {
@@ -235,13 +237,14 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
+	u8 *pos, qos_info;
 	const u8 *ies, *ht_ie;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	int wmm = 0;
 	struct ieee80211_supported_band *sband;
 	u32 rates = 0;
+	bool uapsd;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + wk->ie_len +
@@ -268,6 +271,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 		capab |= WLAN_CAPABILITY_PRIVACY;
 	if (wk->bss->wmm_used)
 		wmm = 1;
+	uapsd = wk->bss->uapsd_supported;
 
 	/* get all rates supported by the device and the AP as
 	 * some APs don't like getting a superset of their rates
@@ -368,6 +372,15 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED)) {
+		if (uapsd && (local->hw.flags & IEEE80211_HW_UAPSD)) {
+			qos_info = IEEE80211_DEFAULT_UAPSD_QUEUES;
+			qos_info |= IEEE80211_WMM_IE_STA_SP_ALL;
+			ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
+		} else {
+			qos_info = 0;
+			ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
+		}
+
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
@@ -377,7 +390,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 		*pos++ = 2; /* WME */
 		*pos++ = 0; /* WME info */
 		*pos++ = 1; /* WME ver */
-		*pos++ = 0;
+		*pos++ = qos_info;
 	}
 
 	/* wmm support is a must to HT */
@@ -786,7 +799,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	struct ieee80211_tx_queue_params params;
 	size_t left;
 	int count;
-	u8 *pos;
+	u8 *pos, uapsd_queues = 0;
 
 	if (!(ifmgd->flags & IEEE80211_STA_WMM_ENABLED))
 		return;
@@ -796,6 +809,10 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
+
+	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
+		uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)
 		return;
@@ -810,6 +827,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	for (; left >= 4; left -= 4, pos += 4) {
 		int aci = (pos[0] >> 5) & 0x03;
 		int acm = (pos[0] >> 4) & 0x01;
+		bool uapsd = false;
 		int queue;
 
 		switch (aci) {
@@ -817,22 +835,30 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			queue = 3;
 			if (acm)
 				local->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_AC_BK)
+				uapsd = true;
 			break;
 		case 2: /* AC_VI */
 			queue = 1;
 			if (acm)
 				local->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_AC_VI)
+				uapsd = true;
 			break;
 		case 3: /* AC_VO */
 			queue = 0;
 			if (acm)
 				local->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_AC_VO)
+				uapsd = true;
 			break;
 		case 0: /* AC_BE */
 		default:
 			queue = 2;
 			if (acm)
 				local->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
+			if (uapsd_queues & IEEE80211_WMM_IE_STA_AC_BE)
+				uapsd = true;
 			break;
 		}
 
@@ -840,11 +866,14 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
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
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4cf387c..b11ae49 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -50,6 +50,23 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 	cfg80211_put_bss((struct cfg80211_bss *)bss);
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
+	return qos_info & 0x80;
+}
+
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
@@ -111,6 +128,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	}
 
 	bss->wmm_used = elems->wmm_param || elems->wmm_info;
+	bss->uapsd_supported = is_uapsd_supported(elems);
 
 	if (!beacon)
 		bss->last_probe_resp = jiffies;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d09f78b..7129b39 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -781,6 +781,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 			break;
 		}
 
+		qparam.uapsd = false;
+
 		drv_conf_tx(local, queue, &qparam);
 	}
 }

