Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab2CTOkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:14 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 11:42:19 +0100
Subject: [RFC 09/12] mac80211: add initial structures for multi-channel
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <bd8f4acf-a8a6-4a75-beb6-aa42cd93002b@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154020_755567_61FDE074)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_channel_state() function is introduced. It proxies to
appropriate ieee80211_channel_state depending on whether hardware
supports concurrent multi-channel operation or not.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |    2 ++
 net/mac80211/ieee80211_i.h |   14 ++++++++++++++
 net/mac80211/iface.c       |   12 ++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f7f0252..383be0c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -276,6 +276,7 @@ enum ieee80211_rssi_event {
  * @ssid: The SSID of the current vif. Only valid in AP-mode.
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
+ * @chan_conf: Channel configuration (eg. what channel we're tuned to)
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -305,6 +306,7 @@ struct ieee80211_bss_conf {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	bool hidden_ssid;
+	struct ieee80211_channel_conf *chan_conf;
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b459451..a4307dc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -721,6 +721,9 @@ struct ieee80211_sub_if_data {
 	 */
 	struct ieee80211_if_ap *bss;
 
+	/* Channel state */
+	struct ieee80211_channel_state chan_state;
+
 	/* bitmap of allowed (non-MCS) rate indexes for rate control */
 	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
@@ -1303,6 +1306,17 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 	return test_bit(SDATA_STATE_RUNNING, &sdata->state);
 }
 
+static inline struct ieee80211_channel_state *ieee80211_get_channel_state(
+			struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata)
+{
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_MULTI_CHANNEL) {
+		BUG_ON(!sdata);
+		return &sdata->chan_state;
+	} else
+		return &local->chan_state;
+}
+
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
 void ieee80211_tx_pending(unsigned long data);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4ee77a2..2a9df60 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -183,6 +183,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	int res;
 	u32 hw_reconf_flags = 0;
 
+	sdata->vif.bss_conf.chan_conf = &sdata->chan_state.conf;
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_WDS:
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
@@ -1192,8 +1194,18 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		else
 			memset(sdata->rc_rateidx_mcs_mask[i], 0,
 			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
+
+		if (!sdata->chan_state.oper_channel && sband) {
+			/* init channel we're on */
+			sdata->chan_state.conf.channel =
+			sdata->chan_state.oper_channel = &sband->channels[0];
+			sdata->chan_state.conf.channel_type = NL80211_CHAN_NO_HT;
+		}
 	}
 
+	if (WARN_ON(!sdata->chan_state.oper_channel))
+		goto fail;
+
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
-- 
1.7.0.4

