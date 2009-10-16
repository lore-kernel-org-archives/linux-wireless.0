Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26872 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbZJPM26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:28:58 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n9GCRIvI015325
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 07:27:31 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration struct
Date: Fri, 16 Oct 2009 15:27:20 +0300
Message-Id: <1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chips need to know the BSSID that we are interested in before we start
the association process.  This patch adds an operating BSSID to the device
configuration struct ieee80211_conf so that it can be passed to the driver
when op_config is called.

With this solution we also solve the problem of some chips that require
an explicit disconnect command when disassociating.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/mac80211.h |    8 ++++++++
 net/mac80211/mlme.c    |   27 +++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 466859b..654d753 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -599,6 +599,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_OPER_BSSID	= BIT(9),
 };
 
 /**
@@ -629,6 +630,11 @@ enum ieee80211_conf_changed {
  * @short_frame_max_tx_count: Maximum number of transmissions for a "short"
  *    frame, called "dot11ShortRetryLimit" in 802.11, but actually means the
  *    number of transmissions not the number of retries
+ *
+ * @oper_bssid: BSSID on which we are operating; some chips need to know
+ *    which BSSID we are "tuned" to in order to improve power management,
+ *    coexistence with other technologies (such as Bluetooth) and other
+ *    filtering issues.
  */
 struct ieee80211_conf {
 	u32 flags;
@@ -641,6 +647,8 @@ struct ieee80211_conf {
 
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
+
+	u8 oper_bssid[ETH_ALEN];
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8d26e9b..cac542d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1077,6 +1077,11 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 
+	if (!is_zero_ether_addr(sdata->local->hw.conf.oper_bssid)) {
+		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
+		memset(sdata->local->hw.conf.oper_bssid, 0, ETH_ALEN);
+	}
+
 	/* on the next assoc, re-program HT parameters */
 	sdata->ht_opmode_valid = false;
 
@@ -2356,6 +2361,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
 	struct ieee80211_mgd_work *wk;
+	u32 config_changed = 0;
 	u16 auth_alg;
 
 	switch (req->auth_type) {
@@ -2405,7 +2411,15 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	 *	to sleep and then change channel etc.
 	 */
 	sdata->local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(sdata->local, 0);
+
+	if (memcmp(sdata->local->hw.conf.oper_bssid,
+		   req->bss->bssid, ETH_ALEN)) {
+		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
+		memcpy(sdata->local->hw.conf.oper_bssid,
+		       req->bss->bssid, ETH_ALEN);
+	}
+
+	ieee80211_hw_config(sdata->local, config_changed);
 
 	mutex_lock(&ifmgd->mtx);
 	list_add(&wk->list, &sdata->u.mgd.work_list);
@@ -2420,6 +2434,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_work *wk, *found = NULL;
+	u32 config_changed = 0;
 	int i, err;
 
 	mutex_lock(&ifmgd->mtx);
@@ -2457,7 +2472,15 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 	sdata->local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(sdata->local, 0);
+
+	if (memcmp(sdata->local->hw.conf.oper_bssid,
+		   req->bss->bssid, ETH_ALEN)) {
+		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
+		memcpy(sdata->local->hw.conf.oper_bssid,
+		       req->bss->bssid, ETH_ALEN);
+	}
+
+	ieee80211_hw_config(sdata->local, config_changed);
 
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
-- 
1.5.6.5

