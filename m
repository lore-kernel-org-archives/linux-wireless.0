Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbXH3Oq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:46:27 -0400
Subject: [PATCH] mac80211: remove turbo modes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:47:33 +0200
Message-Id: <1188485253.3978.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all mention of the atheros turbo modes that
can't possibly work properly anyway since in some places we don't
check for them when we should.

Due to the crappy hostapd ioctl interface, some contortions
are required there to keep it stable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>

---
This will leave ath5k uncompilable but I didn't dare touch
it with a long stick. Mess.

I think Zhu Yi acked the iwlwifi part, but not sure what's
up with that now.

Michael is fine with removing the stuff from mac80211 and I've tested
with hostapd to make sure it still works.

 drivers/net/wireless/iwl-4965-rs.c |   18 ++------
 drivers/net/wireless/iwl-4965.c    |   12 +----
 drivers/net/wireless/iwl-base.c    |   36 +++--------------
 drivers/net/wireless/iwl-channel.h |    6 --
 include/net/mac80211.h             |    7 ---
 net/mac80211/debugfs.c             |    2 
 net/mac80211/ieee80211.c           |    6 --
 net/mac80211/ieee80211_common.h    |    2 
 net/mac80211/ieee80211_ioctl.c     |   78 +++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_sta.c       |   33 +--------------
 net/mac80211/regdomain.c           |    6 --
 net/mac80211/rx.c                  |    2 
 net/mac80211/tx.c                  |    2 
 net/mac80211/util.c                |   11 -----
 14 files changed, 88 insertions(+), 133 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-30 14:35:19.982051253 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-30 14:35:32.902051253 +0200
@@ -73,14 +73,13 @@ struct ieee80211_channel {
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
@@ -101,12 +100,10 @@ struct ieee80211_rate {
 
 /* 802.11g is backwards-compatible with 802.11b, so a wlan card can
  * actually be both in 11b and 11g modes at the same time. */
-enum {
+enum ieee80211_phymode {
 	MODE_IEEE80211A, /* IEEE 802.11a */
 	MODE_IEEE80211B, /* IEEE 802.11b only */
-	MODE_ATHEROS_TURBO, /* Atheros Turbo mode (2x.11a at 5 GHz) */
 	MODE_IEEE80211G, /* IEEE 802.11g (and 802.11b compatibility) */
-	MODE_ATHEROS_TURBOG, /* Atheros Turbo mode (2x.11g at 2.4 GHz) */
 
 	/* keep last */
 	NUM_IEEE80211_MODES
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-08-30 14:35:20.002051253 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-08-30 14:35:32.912051253 +0200
@@ -38,8 +38,6 @@ static const char *ieee80211_mode_str(in
 		return "IEEE 802.11b";
 	case MODE_IEEE80211G:
 		return "IEEE 802.11g";
-	case MODE_ATHEROS_TURBO:
-		return "Atheros Turbo (5 GHz)";
 	default:
 		return "UNKNOWN";
 	}
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-30 14:35:20.072051253 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-30 14:35:32.912051253 +0200
@@ -117,10 +117,6 @@ ieee80211_fill_frame_info(struct ieee802
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
@@ -1226,7 +1222,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
 
-	local->enabled_modes = (unsigned int) -1;
+	local->enabled_modes = ~0;
 
 	INIT_LIST_HEAD(&local->modes_list);
 
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:32.122051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:32.912051253 +0200
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
@@ -613,10 +644,14 @@ static int ieee80211_ioctl_set_rate_sets
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
 
@@ -781,7 +816,8 @@ static int ieee80211_ioctl_set_channel_f
 	int i;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode == param->u.set_channel_flag.mode)
+		if (mode_to_hostapd_mode(mode->mode) ==
+		    param->u.set_channel_flag.mode)
 			goto found;
 	}
 	return -ENOENT;
@@ -903,9 +939,6 @@ static int ieee80211_ioctl_giwname(struc
 	case MODE_IEEE80211G:
 		strcpy(name, "IEEE 802.11g");
 		break;
-	case MODE_ATHEROS_TURBO:
-		strcpy(name, "5GHz Turbo");
-		break;
 	default:
 		strcpy(name, "IEEE 802.11");
 		break;
@@ -1362,9 +1395,6 @@ static int ieee80211_ioctl_siwrate(struc
 		struct ieee80211_rate *rates = &mode->rates[i];
 		int this_rate = rates->rate;
 
-		if (mode->mode == MODE_ATHEROS_TURBO ||
-		    mode->mode == MODE_ATHEROS_TURBOG)
-			this_rate *= 2;
 		if (target_rate == this_rate) {
 			sdata->bss->max_ratectrl_rateidx = i;
 			if (rate->fixed)
@@ -1554,6 +1584,7 @@ static int ieee80211_ioctl_prism2_param(
 	int param = *i;
 	int value = *(i + 1);
 	int ret = 0;
+	int mode;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -1633,7 +1664,7 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_NEXT_MODE:
-		local->next_mode = value;
+		local->next_mode = hostapd_mode_to_mode(value);
 		break;
 
 	case PRISM2_PARAM_BROADCAST_SSID:
@@ -1674,7 +1705,15 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_HW_MODES:
-		local->enabled_modes = value;
+		mode = 1;
+		local->enabled_modes = 0;
+		while (value) {
+			if (value & 1)
+				local->enabled_modes |=
+					hostapd_mode_to_mode(mode);
+			mode <<= 1;
+			value >>= 1;
+		}
 		break;
 
 	case PRISM2_PARAM_CREATE_IBSS:
@@ -1728,6 +1767,7 @@ static int ieee80211_ioctl_get_prism2_pa
 	struct ieee80211_sub_if_data *sdata;
 	int *param = (int *) extra;
 	int ret = 0;
+	int mode;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1788,7 +1828,13 @@ static int ieee80211_ioctl_get_prism2_pa
 		break;
 
 	case PRISM2_PARAM_HW_MODES:
-		*param = local->enabled_modes;
+		mode = 0;
+		*param = 0;
+		while (mode < NUM_IEEE80211_MODES) {
+			if (local->enabled_modes & (1<<mode))
+				*param |= mode_to_hostapd_mode(1<<mode);
+			mode++;
+		}
 		break;
 
 	case PRISM2_PARAM_CREATE_IBSS:
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-30 14:35:20.142051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-30 14:35:32.922051253 +0200
@@ -663,8 +663,6 @@ static void ieee80211_send_assoc(struct 
 	*pos++ = len;
 	for (i = 0; i < len; i++) {
 		int rate = mode->rates[i].rate;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
 
@@ -674,8 +672,6 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = mode->num_rates - len;
 		for (i = len; i < mode->num_rates; i++) {
 			int rate = mode->rates[i].rate;
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				rate /= 2;
 			*pos++ = (u8) (rate / 5);
 		}
 	}
@@ -1060,10 +1056,7 @@ void ieee80211_send_dls_req(struct net_d
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
@@ -1133,10 +1126,7 @@ static void ieee80211_send_dls_resp(stru
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
@@ -1343,10 +1333,7 @@ static void ieee80211_send_probe_req(str
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
@@ -1739,16 +1726,12 @@ static void ieee80211_rx_mgmt_assoc_resp
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
@@ -1924,8 +1907,6 @@ static void sta_process_dls_req(struct n
 		else if (elems.ext_supp_rates)
 			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
 		rate = 5 * (rate & 0x7f);
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < num_rates; j++)
 			if (rates[j].rate == rate)
 				supp_rates |= BIT(j);
@@ -1998,8 +1979,6 @@ static void sta_process_dls_resp(struct 
 		else if (elems.ext_supp_rates)
 			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
 		rate = 5 * (rate & 0x7f);
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate *= 2;
 		for (j = 0; j < num_rates; j++)
 			if (rates[j].rate == rate)
 				supp_rates |= BIT(j);
@@ -2236,8 +2215,6 @@ static void ieee80211_rx_bss_info(struct
 				rate = elems.ext_supp_rates
 					[i - elems.supp_rates_len];
 			own_rate = 5 * (rate & 0x7f);
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				own_rate *= 2;
 			for (j = 0; j < num_rates; j++)
 				if (rates[j].rate == own_rate)
 					supp_rates |= BIT(j);
@@ -3293,8 +3270,6 @@ static int ieee80211_sta_join_ibss(struc
 		mode = local->oper_hw_mode;
 		for (i = 0; i < bss->supp_rates_len; i++) {
 			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			if (mode->mode == MODE_ATHEROS_TURBO)
-				bitrate *= 2;
 			for (j = 0; j < mode->num_rates; j++)
 				if (mode->rates[j].rate == bitrate)
 					rates |= BIT(j);
@@ -3367,8 +3342,6 @@ static int ieee80211_sta_create_ibss(str
 	pos = bss->supp_rates;
 	for (i = 0; i < mode->num_rates; i++) {
 		int rate = mode->rates[i].rate;
-		if (mode->mode == MODE_ATHEROS_TURBO)
-			rate /= 2;
 		*pos++ = (u8) (rate / 5);
 	}
 
--- wireless-dev.orig/net/mac80211/regdomain.c	2007-08-30 14:35:20.192051253 +0200
+++ wireless-dev/net/mac80211/regdomain.c	2007-08-30 14:35:32.922051253 +0200
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
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-30 14:35:32.132051253 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-30 14:35:32.922051253 +0200
@@ -104,8 +104,6 @@ ieee80211_rx_h_load_stats(struct ieee802
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
 	if (mode->mode == MODE_IEEE80211A ||
-	    mode->mode == MODE_ATHEROS_TURBO ||
-	    mode->mode == MODE_ATHEROS_TURBOG ||
 	    (mode->mode == MODE_IEEE80211G &&
 	     rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-30 14:35:32.132051253 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-30 14:35:32.922051253 +0200
@@ -746,8 +746,6 @@ ieee80211_tx_h_load_stats(struct ieee802
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
 	if (mode->mode == MODE_IEEE80211A ||
-	    mode->mode == MODE_ATHEROS_TURBO ||
-	    mode->mode == MODE_ATHEROS_TURBOG ||
 	    (mode->mode == MODE_IEEE80211G &&
 	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
--- wireless-dev.orig/net/mac80211/util.c	2007-08-30 14:35:20.322051253 +0200
+++ wireless-dev/net/mac80211/util.c	2007-08-30 14:35:32.932051253 +0200
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
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-30 14:35:20.422051253 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-30 14:35:32.942051253 +0200
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
@@ -3111,8 +3109,7 @@ static void iwl_set_rate(struct iwl_priv
 	priv->active_rate_basic = 0;
 
 	IWL_DEBUG_RATE("Setting rates for 802.11%c\n",
-		       ((hw->mode == MODE_IEEE80211A) ||
-			(hw->mode == MODE_ATHEROS_TURBO)) ?
+		       hw->mode == MODE_IEEE80211A ?
 		       'a' : ((hw->mode == MODE_IEEE80211B) ? 'b' : 'g'));
 
 	for (i = 0; i < hw->num_rates; i++) {
@@ -5441,7 +5438,6 @@ const struct iwl_channel_info *iwl_get_c
 	int i;
 
 	switch (phymode) {
-	case MODE_ATHEROS_TURBO:
 	case MODE_IEEE80211A:
 		for (i = 14; i < priv->channel_count; i++) {
 			if (priv->channel_info[i].channel == channel)
@@ -5451,7 +5447,6 @@ const struct iwl_channel_info *iwl_get_c
 
 	case MODE_IEEE80211B:
 	case MODE_IEEE80211G:
-	case MODE_ATHEROS_TURBOG:
 		if (channel >= 1 && channel <= 14)
 			return &priv->channel_info[channel - 1];
 		break;
@@ -5636,8 +5631,7 @@ static int iwl_init_channel_map(struct i
 
 static inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv, int phymode)
 {
-	if ((phymode == MODE_IEEE80211A) ||
-	    (phymode == MODE_ATHEROS_TURBO))
+	if (phymode == MODE_IEEE80211A)
 		return IWL_ACTIVE_DWELL_TIME_52;
 	else
 		return IWL_ACTIVE_DWELL_TIME_24;
@@ -5646,8 +5640,7 @@ static inline u16 iwl_get_active_dwell_t
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv, int phymode)
 {
 	u16 active = iwl_get_active_dwell_time(priv, phymode);
-	u16 passive = ((phymode != MODE_IEEE80211A) &&
-		       (phymode != MODE_ATHEROS_TURBO)) ?
+	u16 passive = (phymode != MODE_IEEE80211A) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -5728,8 +5721,7 @@ static int iwl_get_channels_for_scan(str
 		/* scan_pwr_info->tpc.dsp_atten; */
 
 		/*scan_pwr_info->tpc.tx_gain; */
-		if ((phymode == MODE_IEEE80211A) ||
-		    (phymode == MODE_ATHEROS_TURBO))
+		if (phymode == MODE_IEEE80211A)
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
@@ -5881,19 +5873,6 @@ static int iwl_init_geos(struct iwl_priv
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
 
@@ -8329,8 +8308,7 @@ static void iwl_mac_get_ht_capab(struct 
 		use_wide_channel = 0;
 
 	/* no fat tx allowed on 2.4GHZ */
-	if ((priv->phymode != MODE_IEEE80211A) &&
-	    (priv->phymode != MODE_ATHEROS_TURBO))
+	if (priv->phymode != MODE_IEEE80211A)
 		use_wide_channel = 0;
 
 	iwl_set_ht_capab(hw, ht_cap, use_wide_channel);
--- wireless-dev.orig/drivers/net/wireless/iwl-channel.h	2007-08-30 14:35:20.442051253 +0200
+++ wireless-dev/drivers/net/wireless/iwl-channel.h	2007-08-30 14:35:32.942051253 +0200
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
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-30 14:35:20.352051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-08-30 14:35:32.942051253 +0200
@@ -73,8 +73,6 @@ enum ieee80211_phytype {
 	ieee80211_phytype_ofdm_dot11_g   = 6,
 	ieee80211_phytype_pbcc_dot11_g   = 7,
 	ieee80211_phytype_ofdm_dot11_a   = 8,
-	ieee80211_phytype_dsss_dot11_turbog = 255,
-	ieee80211_phytype_dsss_dot11_turbo = 256,
 };
 
 enum ieee80211_ssi_type {
--- wireless-dev.orig/drivers/net/wireless/iwl-4965.c	2007-08-30 14:35:20.492051253 +0200
+++ wireless-dev/drivers/net/wireless/iwl-4965.c	2007-08-30 14:35:32.942051253 +0200
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
--- wireless-dev.orig/drivers/net/wireless/iwl-4965-rs.c	2007-08-30 14:35:20.552051253 +0200
+++ wireless-dev/drivers/net/wireless/iwl-4965-rs.c	2007-08-30 14:35:32.952051253 +0200
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


