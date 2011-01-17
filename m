Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:28326 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135Ab1AQEha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 23:37:30 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0708639046
	for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 13:37:28 +0900 (JST)
Subject: [PATCH 2] cfg80211: Extend channel to frequency mapping for 802.11j
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: gwingerde@gmail.com, libertas-dev@lists.infradead.org,
	dcbw@redhat.com, IvDoorn@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, bprodoehl@gmail.com
Date: Mon, 17 Jan 2011 13:37:28 +0900
Message-ID: <20110117043728.8024.13541.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend channel to frequency mapping for 802.11j Japan 4.9GHz band, according to
IEEE802.11 section 17.3.8.3.2 and Annex J. Because there are now overlapping
channel numbers in the 2GHz and 5GHz band we can't map from channel to
frequency without knowing the band. This is no problem as in most contexts we
know the band. In places where we don't know the band (and WEXT compatibility)
we assume the 2GHz band for channels below 14.

This patch does not implement all channel to frequency mappings defined in
802.11, it's just an extension for 802.11j 20MHz channels. 5MHz and 10MHz
channels as well as 802.11y channels have been omitted.

The following drivers have been updated to reflect the API changes:
iwl-3945, iwl-agn, iwmc3200wifi, libertas, mwl8k, rt2x00, wl1251, wl12xx.
The drivers have been compile-tested only.

Signed-off-by: Bruno Randolf <br1@einfach.org>

---

v2:	Added necessary driver changes first posted by Brian Prodoehl.
	Brian, do you want to add your Signed-off-by?
---
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    5 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    5 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c      |    3 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    3 +-
 drivers/net/wireless/iwmc3200wifi/rx.c       |    7 ++++-
 drivers/net/wireless/libertas/cfg.c          |    6 +++-
 drivers/net/wireless/mwl8k.c                 |    6 +++-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |    5 +++-
 drivers/net/wireless/wl1251/rx.c             |    3 +-
 drivers/net/wireless/wl12xx/rx.c             |    2 +
 include/net/cfg80211.h                       |    3 +-
 net/mac80211/ibss.c                          |    3 +-
 net/mac80211/mesh.c                          |    2 +
 net/mac80211/mlme.c                          |    8 ++++--
 net/mac80211/scan.c                          |    3 +-
 net/wireless/reg.c                           |    6 ++--
 net/wireless/util.c                          |   36 ++++++++++++++++----------
 net/wireless/wext-compat.c                   |    5 +++-
 18 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a9b852b..1d9dcd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -594,10 +594,11 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 
 	rx_status.flag = 0;
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel));
 	rx_status.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel),
+					       rx_status.band);
 
 	rx_status.rate_idx = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3dee87e..a800318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1157,10 +1157,11 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 
 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel));
 	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
+					       rx_status.band);
 	rx_status.rate_idx =
 		iwlagn_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index efbde1f..a8d4a93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -227,7 +227,8 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 		geo_ch = &sband->channels[sband->n_channels++];
 
 		geo_ch->center_freq =
-				ieee80211_channel_to_frequency(ch->channel);
+				ieee80211_channel_to_frequency(ch->channel,
+							       sband->band);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;
diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 5a49822..ed57e44 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -287,7 +287,8 @@ int iwm_cfg80211_inform_bss(struct iwm_priv *iwm)
 			return -EINVAL;
 		}
 
-		freq = ieee80211_channel_to_frequency(umac_bss->channel);
+		freq = ieee80211_channel_to_frequency(umac_bss->channel,
+						      band->band);
 		channel = ieee80211_get_channel(wiphy, freq);
 		signal = umac_bss->rssi * 100;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index a944893..9a57cf6 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -543,7 +543,10 @@ static int iwm_mlme_assoc_complete(struct iwm_priv *iwm, u8 *buf,
 	switch (le32_to_cpu(complete->status)) {
 	case UMAC_ASSOC_COMPLETE_SUCCESS:
 		chan = ieee80211_get_channel(wiphy,
-			ieee80211_channel_to_frequency(complete->channel));
+			ieee80211_channel_to_frequency(complete->channel,
+				complete->band == UMAC_BAND_2GHZ ?
+					IEEE80211_BAND_2GHZ :
+					IEEE80211_BAND_5GHZ));
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
 			/* Associated to a unallowed channel, disassociate. */
 			__iwm_invalidate_mlme_profile(iwm);
@@ -841,7 +844,7 @@ static int iwm_mlme_update_bss_table(struct iwm_priv *iwm, u8 *buf,
 		goto err;
 	}
 
-	freq = ieee80211_channel_to_frequency(umac_bss->channel);
+	freq = ieee80211_channel_to_frequency(umac_bss->channel, band->band);
 	channel = ieee80211_get_channel(wiphy, freq);
 	signal = umac_bss->rssi * 100;
 
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 698a1f7..30ef035 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -607,7 +607,8 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 		/* No channel, no luck */
 		if (chan_no != -1) {
 			struct wiphy *wiphy = priv->wdev->wiphy;
-			int freq = ieee80211_channel_to_frequency(chan_no);
+			int freq = ieee80211_channel_to_frequency(chan_no,
+							IEEE80211_BAND_2GHZ);
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);
 
@@ -1597,7 +1598,8 @@ static int lbs_get_survey(struct wiphy *wiphy, struct net_device *dev,
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	survey->channel = ieee80211_get_channel(wiphy,
-		ieee80211_channel_to_frequency(priv->channel));
+		ieee80211_channel_to_frequency(priv->channel,
+					       IEEE80211_BAND_2GHZ));
 
 	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 809f2bf..b62f7ef 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -906,7 +906,8 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
-	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+	status->freq = ieee80211_channel_to_frequency(rxd->channel,
+						      status->band);
 
 	*qos = rxd->qos_control;
 
@@ -1013,7 +1014,8 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
-	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+	status->freq = ieee80211_channel_to_frequency(rxd->channel,
+						      status->band);
 
 	*qos = rxd->qos_control;
 	if ((rxd->rx_ctrl & MWL8K_STA_RX_CTRL_DECRYPT_ERROR) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9597a03..31b7db0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -649,7 +649,10 @@ static void rt2x00lib_channel(struct ieee80211_channel *entry,
 			      const int channel, const int tx_power,
 			      const int value)
 {
-	entry->center_freq = ieee80211_channel_to_frequency(channel);
+	/* XXX: this assumption about the band is wrong for 802.11j */
+	entry->band = channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	entry->center_freq = ieee80211_channel_to_frequency(channel,
+							    entry->band);
 	entry->hw_value = value;
 	entry->max_power = tx_power;
 	entry->max_antenna_gain = 0xff;
diff --git a/drivers/net/wireless/wl1251/rx.c b/drivers/net/wireless/wl1251/rx.c
index efa5360..86eef45 100644
--- a/drivers/net/wireless/wl1251/rx.c
+++ b/drivers/net/wireless/wl1251/rx.c
@@ -78,7 +78,8 @@ static void wl1251_rx_status(struct wl1251 *wl,
 	 */
 	wl->noise = desc->rssi - desc->snr / 2;
 
-	status->freq = ieee80211_channel_to_frequency(desc->channel);
+	status->freq = ieee80211_channel_to_frequency(desc->channel,
+						      status->band);
 
 	status->flag |= RX_FLAG_TSFT;
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 682304c..ec8d843 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -76,7 +76,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	 */
 	wl->noise = desc->rssi - (desc->snr >> 1);
 
-	status->freq = ieee80211_channel_to_frequency(desc->channel);
+	status->freq = ieee80211_channel_to_frequency(desc->channel, desc_band);
 
 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1322695..679a049 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1790,8 +1790,9 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
 /**
  * ieee80211_channel_to_frequency - convert channel number to frequency
  * @chan: channel number
+ * @band: band, necessary due to channel number overlap
  */
-extern int ieee80211_channel_to_frequency(int chan);
+extern int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band);
 
 /**
  * ieee80211_frequency_to_channel - convert frequency to channel number
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 53c7077..775fb63 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -270,7 +270,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = rx_status->band;
 
 	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
+						      band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2563fd1..2a57cc0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			       &elems);
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..33bd6d4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -176,7 +176,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 
 	/* check that channel matches the right operating channel */
 	if (local->hw.conf.channel->center_freq !=
-	    ieee80211_channel_to_frequency(hti->control_chan))
+	    ieee80211_channel_to_frequency(hti->control_chan, sband->band))
 		enable_ht = false;
 
 	if (enable_ht) {
@@ -429,7 +429,8 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
+	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
+						      cbss->channel->band);
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -1519,7 +1520,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
+						      rx_status->band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fb274db..1ef73be 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -196,7 +196,8 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0],
+						      rx_status->band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 37693b6..c565689 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1801,9 +1801,9 @@ void regulatory_hint_disconnect(void)
 
 static bool freq_is_chan_12_13_14(u16 freq)
 {
-	if (freq == ieee80211_channel_to_frequency(12) ||
-	    freq == ieee80211_channel_to_frequency(13) ||
-	    freq == ieee80211_channel_to_frequency(14))
+	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
 		return true;
 	return false;
 }
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7620ae2..4ed065d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -29,29 +29,37 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
-int ieee80211_channel_to_frequency(int chan)
+int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
 {
-	if (chan < 14)
-		return 2407 + chan * 5;
-
-	if (chan == 14)
-		return 2484;
-
-	/* FIXME: 802.11j 17.3.8.3.2 */
-	return (chan + 1000) * 5;
+	/* see 802.11 17.3.8.3.2 and Annex J
+	 * there are overlapping channel numbers in 5GHz and 2GHz bands */
+	if (band == IEEE80211_BAND_5GHZ) {
+		if (chan >= 182 && chan <= 196)
+			return 4000 + chan * 5;
+		else
+			return 5000 + chan * 5;
+	} else { /* IEEE80211_BAND_2GHZ */
+		if (chan == 14)
+			return 2484;
+		else if (chan < 14)
+			return 2407 + chan * 5;
+		else
+			return 0; /* not supported */
+	}
 }
 EXPORT_SYMBOL(ieee80211_channel_to_frequency);
 
 int ieee80211_frequency_to_channel(int freq)
 {
+	/* see 802.11 17.3.8.3.2 and Annex J */
 	if (freq == 2484)
 		return 14;
-
-	if (freq < 2484)
+	else if (freq < 2484)
 		return (freq - 2407) / 5;
-
-	/* FIXME: 802.11j 17.3.8.3.2 */
-	return freq/5 - 1000;
+	else if (freq >= 4910 && freq <= 4980)
+		return (freq - 4000) / 5;
+	else
+		return (freq - 5000) / 5;
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 3e5dbd4..7f1f4ec 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -267,9 +267,12 @@ int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq)
 	 * -EINVAL for impossible things.
 	 */
 	if (freq->e == 0) {
+		enum ieee80211_band band = IEEE80211_BAND_2GHZ;
 		if (freq->m < 0)
 			return 0;
-		return ieee80211_channel_to_frequency(freq->m);
+		if (freq->m > 14)
+			band = IEEE80211_BAND_5GHZ;
+		return ieee80211_channel_to_frequency(freq->m, band);
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)

