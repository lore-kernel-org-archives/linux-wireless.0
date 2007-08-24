Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762073AbXHXKIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:08:39 -0400
Subject: [RFC 09/11 v2] mac80211, iwlwifi: remove atheros turbo modes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20070823164524.799041000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164524.799041000@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 02:37:40 +0200
Message-Id: <1187915861.12153.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Awesome. The ioctl interface is tied to the internal definitions and the
machine locks up when you change these. Uh huh. I don't even want to
think about what happens if you make a silly programming mistake in
hostapd. New patch attached that at least doesn't kill the machine in
the normal case.

johannes

From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211, iwlwifi: remove atheros turbo modes

This patch removes all mention of the atheros turbo modes that
can't possibly work properly anyway since in some places we don't
check for them when we should.

I have no idea what the iwlwifi drivers were doing with these but
it can't possibly have been correct.

Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/iwl-4965-rs.c |   18 +++--------
 drivers/net/wireless/iwl-4965.c    |   12 ++-----
 drivers/net/wireless/iwl-base.c    |   36 ++++------------------
 drivers/net/wireless/iwl-channel.h |    6 +--
 include/net/mac80211.h             |    7 ----
 net/mac80211/debugfs.c             |    2 -
 net/mac80211/ieee80211.c           |    4 --
 net/mac80211/ieee80211_common.h    |    2 -
 net/mac80211/ieee80211_ioctl.c     |   60 +++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_sta.c       |   33 +-------------------
 net/mac80211/regdomain.c           |    6 ---
 net/mac80211/rx.c                  |    2 -
 net/mac80211/tx.c                  |    2 -
 net/mac80211/util.c                |   11 ------
 14 files changed, 69 insertions(+), 132 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-24 02:34:25.609427796 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-24 02:34:25.739427796 +0200
@@ -95,14 +95,13 @@ struct ieee80211_channel {
 #define IEEE80211_RATE_SUPPORTED 0x00000010
 #define IEEE80211_RATE_OFDM 0x00000020
 #define IEEE80211_RATE_CCK 0x00000040
-#define IEEE80211_RATE_TURBO 0x00000080
 #define IEEE80211_RATE_MANDATORY 0x00000100
 
 #define IEEE80211_RATE_CCK_2 (IEEE80211_RATE_CCK | IEEE80211_RATE_PREAMBLE2)
 #define IEEE80211_RATE_MODULATION(f) \
 	(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
 
-/* Low-level driver should set PREAMBLE2, OFDM, CCK, and TURBO flags.
+/* Low-level driver should set PREAMBLE2, OFDM and CCK flags.
  * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on the
  * configuration. */
 struct ieee80211_rate {
@@ -128,16 +127,12 @@ struct ieee80211_rate {
  * @MODE_IEEE80211B: 2.4 GHz as defined by 802.11b
  * @MODE_IEEE80211G: 2.4 GHz as defined by 802.11g (with OFDM),
  *	backwards compatible with 11b mode
- * @MODE_ATHEROS_TURBO: Atheros Turbo mode in 5 GHz
- * @MODE_ATHEROS_TURBOG: Atheros Turbo mode in 2.4 GHz
  * @NUM_IEEE80211_MODES: internal
  */
 enum ieee80211_phymode {
 	MODE_IEEE80211A,
 	MODE_IEEE80211B,
-	MODE_ATHEROS_TURBO,
 	MODE_IEEE80211G,
-	MODE_ATHEROS_TURBOG,
 
 	/* keep last */
 	NUM_IEEE80211_MODES
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-08-24 02:34:24.129427796 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-08-24 02:34:25.739427796 +0200
@@ -38,8 +38,6 @@ static const char *ieee80211_mode_str(in
 		return "IEEE 802.11b";
 	case MODE_IEEE80211G:
 		return "IEEE 802.11g";
-	case MODE_ATHEROS_TURBO:
-		return "Atheros Turbo (5 GHz)";
 	default:
 		return "UNKNOWN";
 	}
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-24 02:34:25.659427796 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-24 02:34:25.749427796 +0200
@@ -176,10 +176,6 @@ ieee80211_fill_frame_info(struct ieee802
 		case MODE_IEEE80211G:
 			fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
 			break;
-		case MODE_ATHEROS_TURBO:
-			fi->phytype =
-				htonl(ieee80211_phytype_dsss_dot11_turbo);
-			break;
 		default:
 			fi->phytype = htonl(0xAAAAAAAA);
 			break;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-24 02:34:25.709427796 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-24 02:34:25.749427796 +0200
@@ -27,6 +27,40 @@
 #include "aes_ccm.h"
 
 
+/*
+ * Wow. This ioctl interface is such crap, it's tied
+ * to internal definitions. I hope it dies soon.
+ */
+static int mode_to_hostapd_mode(enum ieee80211_phymode mode)
+{
+	switch (mode) {
+	case MODE_IEEE80211A:
+		return 0;
+	case MODE_IEEE80211B:
+		return 1;
+	case MODE_IEEE80211G:
+		return 3;
+	case NUM_IEEE80211_MODES:
+		WARN_ON(1);
+		break;
+	}
+	WARN_ON(1);
+	return -1;
+}
+
+static enum ieee80211_phymode hostapd_mode_to_mode(int hostapd_mode)
+{
+	switch (hostapd_mode) {
+	case 0:
+		return MODE_IEEE80211A;
+	case 1:
+		return MODE_IEEE80211B;
+	case 3:
+		return MODE_IEEE80211G;
+	}
+	return NUM_IEEE80211_MODES;
+}
+
 static int ieee80211_ioctl_set_beacon(struct net_device *dev,
 				      struct prism2_hostapd_param *param,
 				      int param_len,
@@ -124,7 +158,7 @@ static int ieee80211_ioctl_get_hw_featur
 		left -= sizeof(*hdr) + clen + rlen;
 
 		hdr = (struct hostapd_ioctl_hw_modes_hdr *) pos;
-		hdr->mode = mode->mode;
+		hdr->mode = mode_to_hostapd_mode(mode->mode);
 		hdr->num_channels = mode->num_channels;
 		hdr->num_rates = mode->num_rates;
 
@@ -251,9 +285,6 @@ static int ieee80211_ioctl_add_sta(struc
 	mode = local->oper_hw_mode;
 	for (i = 0; i < sizeof(param->u.add_sta.supp_rates); i++) {
 		int rate = (param->u.add_sta.supp_rates[i] & 0x7f) * 5;
-		if (mode->mode == MODE_ATHEROS_TURBO ||
-		    mode->mode == MODE_ATHEROS_TURBOG)
-			rate *= 2;
 		for (j = 0; j < mode->num_rates; j++) {
 			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
@@ -622,10 +653,14 @@ static int ieee80211_ioctl_set_rate_sets
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	u16 *pos = (u16 *) param->u.set_rate_sets.data;
 	int left = param_len - ((u8 *) pos - (u8 *) param);
-	int i, mode, num_supp, num_basic, *supp, *basic, *prev;
+	int i, num_supp, num_basic, *supp, *basic, *prev;
+	enum ieee80211_phymode mode;
 	struct ieee80211_hw_mode *hw_mode;
 
-	mode = param->u.set_rate_sets.mode;
+	mode = hostapd_mode_to_mode(param->u.set_rate_sets.mode);
+	if (mode == NUM_IEEE80211_MODES)
+		return -EINVAL;
+
 	num_supp = param->u.set_rate_sets.num_supported_rates;
 	num_basic = param->u.set_rate_sets.num_basic_rates;
 
@@ -884,7 +919,8 @@ static int ieee80211_ioctl_set_channel_f
 	int i;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode == param->u.set_channel_flag.mode)
+		if (mode_to_hostapd_mode(mode->mode) ==
+		    param->u.set_channel_flag.mode)
 			goto found;
 	}
 	return -ENOENT;
@@ -1012,9 +1048,6 @@ static int ieee80211_ioctl_giwname(struc
 	case MODE_IEEE80211G:
 		strcpy(name, "IEEE 802.11g");
 		break;
-	case MODE_ATHEROS_TURBO:
-		strcpy(name, "5GHz Turbo");
-		break;
 	default:
 		strcpy(name, "IEEE 802.11");
 		break;
@@ -1068,7 +1101,7 @@ static int ieee80211_ioctl_giwrange(stru
 	list_for_each_entry(mode, &local->modes_list, list) {
 		int i = 0;
 
-		if (!(local->enabled_modes & (1 << mode->mode)) ||
+		if (!(local->enabled_modes & (1 << mode_to_hostapd_mode(mode->mode))) ||
 		    (local->hw_modes & local->enabled_modes &
 		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
 			continue;
@@ -1467,9 +1500,6 @@ static int ieee80211_ioctl_siwrate(struc
 		struct ieee80211_rate *rates = &mode->rates[i];
 		int this_rate = rates->rate;
 
-		if (mode->mode == MODE_ATHEROS_TURBO ||
-		    mode->mode == MODE_ATHEROS_TURBOG)
-			this_rate *= 2;
 		if (target_rate == this_rate) {
 			sdata->bss->max_ratectrl_rateidx = i;
 			if (rate->fixed)
@@ -1731,7 +1761,7 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_NEXT_MODE:
-		local->next_mode = value;
+		local->next_mode = hostapd_mode_to_mode(value);
 		break;
 
 	case PRISM2_PARAM_BROADCAST_SSID:
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-24 02:34:25.659427796 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-24 02:34:25.759427796 +0200
@@ -651,8 +651,6 @@ static void ieee80211_send_assoc(struct 
 	*pos++ = len;
 	for (i = 0; i < len; i++) {
 		int rate = mode->rates[i].rate;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
 
@@ -662,8 +660,6 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = mode->num_rates - len;
 		for (i = len; i < mode->num_rates; i++) {
 			int rate = mode->rates[i].rate;
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				rate /= 2;
 			*pos++ = (u8) (rate / 5);
 		}
 	}
@@ -1047,10 +1043,7 @@ void ieee80211_send_dls_req(struct net_d
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
-			*pos = rate->rate / 10;
-		else
-			*pos = rate->rate / 5;
+		*pos = rate->rate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1120,10 +1113,7 @@ static void ieee80211_send_dls_resp(stru
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
-			*pos = rate->rate / 10;
-		else
-			*pos = rate->rate / 5;
+		*pos = rate->rate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1331,10 +1321,7 @@ static void ieee80211_send_probe_req(str
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			*pos = rate->rate / 10;
-		else
-			*pos = rate->rate / 5;
+		*pos = rate->rate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1728,16 +1715,12 @@ static void ieee80211_rx_mgmt_assoc_resp
 	mode = local->oper_hw_mode;
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < mode->num_rates; j++)
 			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
 	}
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < mode->num_rates; j++)
 			if (mode->rates[j].rate == rate)
 				rates |= BIT(j);
@@ -1913,8 +1896,6 @@ static void sta_process_dls_req(struct n
 		else if (elems.ext_supp_rates)
 			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
 		rate = 5 * (rate & 0x7f);
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < num_rates; j++)
 			if (rates[j].rate == rate)
 				supp_rates |= BIT(j);
@@ -1987,8 +1968,6 @@ static void sta_process_dls_resp(struct 
 		else if (elems.ext_supp_rates)
 			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
 		rate = 5 * (rate & 0x7f);
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < num_rates; j++)
 			if (rates[j].rate == rate)
 				supp_rates |= BIT(j);
@@ -2225,8 +2204,6 @@ static void ieee80211_rx_bss_info(struct
 				rate = elems.ext_supp_rates
 					[i - elems.supp_rates_len];
 			own_rate = 5 * (rate & 0x7f);
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				own_rate *= 2;
 			for (j = 0; j < num_rates; j++)
 				if (rates[j].rate == own_rate)
 					supp_rates |= BIT(j);
@@ -3277,8 +3254,6 @@ static int ieee80211_sta_join_ibss(struc
 		mode = local->oper_hw_mode;
 		for (i = 0; i < bss->supp_rates_len; i++) {
 			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				bitrate *= 2;
 			for (j = 0; j < mode->num_rates; j++)
 				if (mode->rates[j].rate == bitrate)
 					rates |= BIT(j);
@@ -3351,8 +3326,6 @@ static int ieee80211_sta_create_ibss(str
 	pos = bss->supp_rates;
 	for (i = 0; i < mode->num_rates; i++) {
 		int rate = mode->rates[i].rate;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
 
--- wireless-dev.orig/net/mac80211/regdomain.c	2007-08-24 02:32:05.129427796 +0200
+++ wireless-dev/net/mac80211/regdomain.c	2007-08-24 02:34:25.759427796 +0200
@@ -82,12 +82,6 @@ static void ieee80211_unmask_channel(int
 
 	chan->flag = 0;
 
-	if (ieee80211_regdom == 64 &&
-	    (mode == MODE_ATHEROS_TURBO || mode == MODE_ATHEROS_TURBOG)) {
-		/* Do not allow Turbo modes in Japan. */
-		return;
-	}
-
 	for (i = 0; channel_range[i].start_freq; i++) {
 		const struct ieee80211_channel_range *r = &channel_range[i];
 		if (r->start_freq <= chan->freq && r->end_freq >= chan->freq) {
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-24 02:34:25.659427796 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-24 02:34:25.769427796 +0200
@@ -100,8 +100,6 @@ ieee80211_rx_h_load_stats(struct ieee802
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
 	if (mode->mode == MODE_IEEE80211A ||
-	    mode->mode == MODE_ATHEROS_TURBO ||
-	    mode->mode == MODE_ATHEROS_TURBOG ||
 	    (mode->mode == MODE_IEEE80211G &&
 	     rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-24 02:34:25.669427796 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-24 02:34:25.769427796 +0200
@@ -738,8 +738,6 @@ ieee80211_tx_h_load_stats(struct ieee802
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
 	if (mode->mode == MODE_IEEE80211A ||
-	    mode->mode == MODE_ATHEROS_TURBO ||
-	    mode->mode == MODE_ATHEROS_TURBOG ||
 	    (mode->mode == MODE_IEEE80211G &&
 	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
--- wireless-dev.orig/net/mac80211/util.c	2007-08-24 02:32:05.219427796 +0200
+++ wireless-dev/net/mac80211/util.c	2007-08-24 02:36:03.819427796 +0200
@@ -92,11 +92,6 @@ void ieee80211_prepare_rates(struct ieee
 			if (rate->rate == 10 || rate->rate == 20)
 				rate->flags |= IEEE80211_RATE_BASIC;
 			break;
-		case MODE_ATHEROS_TURBO:
-			if (rate->rate == 120 || rate->rate == 240 ||
-			    rate->rate == 480)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
 		case MODE_IEEE80211G:
 			if (rate->rate == 10 || rate->rate == 20 ||
 			    rate->rate == 55 || rate->rate == 110)
@@ -115,8 +110,6 @@ void ieee80211_prepare_rates(struct ieee
 			if (rate->rate == 10)
 				rate->flags |= IEEE80211_RATE_MANDATORY;
 			break;
-		case MODE_ATHEROS_TURBO:
-			break;
 		case MODE_IEEE80211G:
 			if (rate->rate == 10 || rate->rate == 20 ||
 			    rate->rate == 55 || rate->rate == 110 ||
@@ -272,8 +265,7 @@ int ieee80211_frame_duration(struct ieee
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A || erp ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBO) {
+	if (local->hw.conf.phymode == MODE_IEEE80211A || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -287,7 +279,6 @@ int ieee80211_frame_duration(struct ieee
 		 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
 		 *	signal ext = 6 usec
 		 */
-		/* FIX: Atheros Turbo may have different (shorter) duration? */
 		dur = 16; /* SIFS + signal ext */
 		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
 		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-24 02:34:25.099427796 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-24 02:34:25.799427796 +0200
@@ -974,8 +974,7 @@ static int iwl_set_rxon_channel(struct i
 		return 0;
 
 	priv->staging_rxon.channel = cpu_to_le16(channel);
-	if ((phymode == MODE_IEEE80211A) ||
-	    (phymode == MODE_ATHEROS_TURBO))
+	if (phymode == MODE_IEEE80211A)
 		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
@@ -2567,8 +2566,7 @@ static int iwl_set_rxon_hwcrypto(struct 
 
 static void iwl_set_flags_for_phymode(struct iwl_priv *priv, u8 phymode)
 {
-	if ((phymode == MODE_IEEE80211A) ||
-	    (phymode == MODE_ATHEROS_TURBO)) {
+	if (phymode == MODE_IEEE80211A) {
 		priv->staging_rxon.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
@@ -3113,8 +3111,7 @@ static void iwl_set_rate(struct iwl_priv
 	priv->active_rate_basic = 0;
 
 	IWL_DEBUG_RATE("Setting rates for 802.11%c\n",
-		       ((hw->mode == MODE_IEEE80211A) ||
-			(hw->mode == MODE_ATHEROS_TURBO)) ?
+		       hw->mode == MODE_IEEE80211A ?
 		       'a' : ((hw->mode == MODE_IEEE80211B) ? 'b' : 'g'));
 
 	for (i = 0; i < hw->num_rates; i++) {
@@ -5443,7 +5440,6 @@ const struct iwl_channel_info *iwl_get_c
 	int i;
 
 	switch (phymode) {
-	case MODE_ATHEROS_TURBO:
 	case MODE_IEEE80211A:
 		for (i = 14; i < priv->channel_count; i++) {
 			if (priv->channel_info[i].channel == channel)
@@ -5453,7 +5449,6 @@ const struct iwl_channel_info *iwl_get_c
 
 	case MODE_IEEE80211B:
 	case MODE_IEEE80211G:
-	case MODE_ATHEROS_TURBOG:
 		if (channel >= 1 && channel <= 14)
 			return &priv->channel_info[channel - 1];
 		break;
@@ -5638,8 +5633,7 @@ static int iwl_init_channel_map(struct i
 
 static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv, int phymode)
 {
-	if ((phymode == MODE_IEEE80211A) ||
-	    (phymode == MODE_ATHEROS_TURBO))
+	if (phymode == MODE_IEEE80211A)
 		return IWL_ACTIVE_DWELL_TIME_52;
 	else
 		return IWL_ACTIVE_DWELL_TIME_24;
@@ -5648,8 +5642,7 @@ static inline u16 iwl_get_active_dwell_t
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv, int phymode)
 {
 	u16 active = iwl_get_active_dwell_time(priv, phymode);
-	u16 passive = ((phymode != MODE_IEEE80211A) &&
-		       (phymode != MODE_ATHEROS_TURBO)) ?
+	u16 passive = (phymode != MODE_IEEE80211A) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -5730,8 +5723,7 @@ static int iwl_get_channels_for_scan(str
 		/* scan_pwr_info->tpc.dsp_atten; */
 
 		/*scan_pwr_info->tpc.tx_gain; */
-		if ((phymode == MODE_IEEE80211A) ||
-		    (phymode == MODE_ATHEROS_TURBO))
+		if (phymode == MODE_IEEE80211A)
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
@@ -5883,19 +5875,6 @@ static int iwl_init_geos(struct iwl_priv
 	modes[G].num_rates = 12;	/* OFDM & CCK */
 	modes[G].num_channels = 0;
 
-#if IWL == 4965
-	modes[G_11N].mode = MODE_ATHEROS_TURBOG;
-	modes[G_11N].channels = channels;
-	modes[G_11N].num_rates = 13;        /* OFDM & CCK */
-	modes[G_11N].rates = rates;
-	modes[G_11N].num_channels = 0;
-
-	modes[A_11N].mode = MODE_ATHEROS_TURBO;
-	modes[A_11N].channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
-	modes[A_11N].rates = &rates[4];
-	modes[A_11N].num_rates = 9; /* just OFDM */
-	modes[A_11N].num_channels = 0;
-#endif
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
@@ -8353,8 +8332,7 @@ static void iwl_mac_get_ht_capab(struct 
 		use_wide_channel = 0;
 
 	/* no fat tx allowed on 2.4GHZ */
-	if ((priv->phymode != MODE_IEEE80211A) &&
-	    (priv->phymode != MODE_ATHEROS_TURBO))
+	if (priv->phymode != MODE_IEEE80211A)
 		use_wide_channel = 0;
 
 	iwl_set_ht_capab(hw, ht_cap, use_wide_channel);
--- wireless-dev.orig/drivers/net/wireless/iwl-channel.h	2007-08-24 02:32:05.339427796 +0200
+++ wireless-dev/drivers/net/wireless/iwl-channel.h	2007-08-24 02:34:25.799427796 +0200
@@ -136,15 +136,13 @@ static inline int is_channel_radar(const
 
 static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
 {
-	return ((ch_info->phymode == MODE_IEEE80211A) ||
-		(ch_info->phymode == MODE_ATHEROS_TURBO)) ? 1 : 0;
+	return ch_info->phymode == MODE_IEEE80211A;
 }
 
 static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
 {
 	return ((ch_info->phymode == MODE_IEEE80211B) ||
-		(ch_info->phymode == MODE_IEEE80211G) ||
-		(ch_info->phymode == MODE_ATHEROS_TURBOG)) ? 1 : 0;
+		(ch_info->phymode == MODE_IEEE80211G));
 }
 
 static inline int is_channel_passive(const struct iwl_channel_info *ch)
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-24 02:34:23.879427796 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-24 02:34:25.799427796 +0200
@@ -73,8 +73,6 @@ enum ieee80211_phytype {
 	ieee80211_phytype_ofdm_dot11_g   = 6,
 	ieee80211_phytype_pbcc_dot11_g   = 7,
 	ieee80211_phytype_ofdm_dot11_a   = 8,
-	ieee80211_phytype_dsss_dot11_turbog = 255,
-	ieee80211_phytype_dsss_dot11_turbo = 256,
 };
 
 enum ieee80211_ssi_type {
--- wireless-dev.orig/drivers/net/wireless/iwl-4965.c	2007-08-24 02:32:05.379427796 +0200
+++ wireless-dev/drivers/net/wireless/iwl-4965.c	2007-08-24 02:34:25.809427796 +0200
@@ -2558,8 +2558,7 @@ int iwl_hw_reg_send_txpower(struct iwl_p
 	}
 
 	band = ((priv->phymode == MODE_IEEE80211B) ||
-		(priv->phymode == MODE_IEEE80211G) ||
-		(priv->phymode == MODE_ATHEROS_TURBOG)) ? 1 : 0;
+		(priv->phymode == MODE_IEEE80211G));
 
 	is_fat =  is_fat_channel(priv->active_rxon.flags);
 
@@ -2591,8 +2590,7 @@ int iwl_hw_channel_switch(struct iwl_pri
 	const struct iwl_channel_info *ch_info;
 
 	band = ((priv->phymode == MODE_IEEE80211B) ||
-		(priv->phymode == MODE_IEEE80211G) ||
-		(priv->phymode == MODE_ATHEROS_TURBOG)) ? 1 : 0;
+		(priv->phymode == MODE_IEEE80211G));
 
 	ch_info = iwl_get_channel_info(priv, priv->phymode, channel);
 
@@ -4367,8 +4365,7 @@ void iwl4965_add_station(struct iwl_priv
 	 * all the way to 1M in IEEE order and then spin on IEEE */
 	if (is_ap)
 		r = IWL_RATE_54M_INDEX;
-	else if ((priv->phymode == MODE_IEEE80211A) ||
-		 (priv->phymode == MODE_ATHEROS_TURBO))
+	else if (priv->phymode == MODE_IEEE80211A)
 		r = IWL_RATE_6M_INDEX;
 	else
 		r = IWL_RATE_1M_INDEX;
@@ -4432,8 +4429,7 @@ static u8 iwl_is_fat_tx_allowed(struct i
 		return 0;
 
 	/* no fat tx allowed on 2.4GHZ */
-	if ((priv->phymode != MODE_IEEE80211A) &&
-	    (priv->phymode != MODE_ATHEROS_TURBO))
+	if (priv->phymode != MODE_IEEE80211A)
 		return 0;
 	return (iwl_is_channel_extension(priv, priv->phymode,
 					 ht_info->control_chan,
--- wireless-dev.orig/drivers/net/wireless/iwl-4965-rs.c	2007-08-24 02:34:24.099427796 +0200
+++ wireless-dev/drivers/net/wireless/iwl-4965-rs.c	2007-08-24 02:34:25.809427796 +0200
@@ -376,8 +376,7 @@ static int rs_get_tbl_info_from_mcs(cons
 			tbl->lq_type = LQ_NONE;
 		else {
 
-			if ((phymode == MODE_ATHEROS_TURBO) ||
-			    (phymode == MODE_IEEE80211A))
+			if (phymode == MODE_IEEE80211A)
 				tbl->lq_type = LQ_A;
 			else
 				tbl->lq_type = LQ_G;
@@ -554,8 +553,7 @@ static int rs_get_lower_rate(struct iwl_
 	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
 		scale_index = rs_ht_to_legacy[scale_index];
-		if ((lq_data->phymode == MODE_IEEE80211A) ||
-		    (lq_data->phymode == MODE_ATHEROS_TURBO))
+		if (lq_data->phymode == MODE_IEEE80211A)
 			tbl->lq_type = LQ_A;
 		else
 			tbl->lq_type = LQ_G;
@@ -572,8 +570,7 @@ static int rs_get_lower_rate(struct iwl_
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if ((lq_data->phymode == (u8) MODE_IEEE80211A) ||
-		    (lq_data->phymode == (u8) MODE_ATHEROS_TURBO))
+		if (lq_data->phymode == (u8) MODE_IEEE80211A)
 			rate_mask  = (u16)(rate_mask &
 			   (sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
@@ -1411,8 +1408,7 @@ static void rs_rate_scale_perform(struct
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if ((lq_data->phymode == (u8) MODE_IEEE80211A) ||
-		    (lq_data->phymode == (u8) MODE_ATHEROS_TURBO))
+		if (lq_data->phymode == (u8) MODE_IEEE80211A)
 			rate_scale_index_msk = (u16) (rate_mask &
 				(sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
@@ -1657,8 +1653,7 @@ out:
 	/* sta->txrate is an index to A mode rates which start
 	 * at IWL_FIRST_OFDM_RATE
 	 */
-	if ((lq_data->phymode == (u8) MODE_IEEE80211A) ||
-	    (lq_data->phymode == (u8) MODE_ATHEROS_TURBO))
+	if (lq_data->phymode == (u8) MODE_IEEE80211A)
 		sta->txrate = i - IWL_FIRST_OFDM_RATE;
 
 	return;
@@ -1881,8 +1876,7 @@ static void rs_rate_init(void *priv_rate
 	/* For MODE_IEEE80211A mode cck rate are at end
 	 * rate table
 	 */
-	if ((local->hw.conf.phymode == MODE_IEEE80211A) ||
-	    (local->hw.conf.phymode == MODE_ATHEROS_TURBO))
+	if (local->hw.conf.phymode == MODE_IEEE80211A)
 		sta->last_txrate += IWL_FIRST_OFDM_RATE;
 
 	crl->is_dup = priv->is_dup;


