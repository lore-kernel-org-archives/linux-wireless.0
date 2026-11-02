Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655025;
	b=kkt1/S5wstGHTtFkW8V+oJz1IEESBkbz7ji2pWvddBc96IvruJrO+yG0JaFoAg0vnWjK
	 Ov2xWY9Ss4wOAE2XJ3XDSysAsNTq6a6CN6QQSF8ew7djC5ZG1vRepzQqK7sBymjjtcsE0
	 X4kEhAxEudi/ng1KgUgjNju07c+Klmzt8VodPMe/9WOoto+JW86e1OvEga4RK3/D1ewYx
	 UJ3Du9fR/k30sTSWwK5opJ8sfljKeSCbJrP4IHyonkE/j3qnsQs4LD5PAOXh/buBtDEHF
	 YvOmJvGbJlvWoCmX6vgBUmuxbCBbFeMaCf+SiIHdSXHxqiy0uSD3dZKlpIRjKQ53itA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655025;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ltW4Wc+ke/wZYVePi4iGVeqtnDBR1bV0348UWw01K8g=;
	b=p1eAUUzA8UcI1bFquT3KNN12t/vRnyEvHrQa4KAOXnJvh2GcfzHXQSdtvKhmI6eyAnXH
	 pV33VjV6VWqEWH193sqR6//sNgEuWLDwZuzwlncYxzrNHzYolVO9E2Ml1v2Vzssu5P1uy
	 oP+P2Mms6CPNqlUMa6/N/TK4N2d28yY1f5Ib898R4CHtgBC927KrUCb0Hniy53JBoeiYa
	 EAVyoHY23523XbT+qEWWGi6xSi4CkrlUDaWX39bRdiQ5XhFashdKGjm29e6T7yH9hHRo5
	 htyvMA1ZfIvytD4Hf/w8XIB6A7+QMiClsft4Xd6bvoK5JT0J7k0dsmC899jcyWJWlvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kruKhUQh;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6E36082BEA
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kruKhUQh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ltW4Wc+ke/wZYVePi4iGVeqtnDBR1bV0348UWw01K8g=;
	t=1793655024; x=1794864624; b=kruKhUQhMvEhxEGzUbENXA+3t02D1uY/h+udz7DMq4xspn4
	mWCuXlXdi+zfispo0fJY6/Je+5g7Itf4umX+f2bOMXKzUX5jTKAqRN6mC+XbLZ4CWXfMqYSEpHy+M
	9L5Kge8wjdrKFEAsqQGpnZtUsZiBj6hYX16mvmb1VWlX2FncgVwrAsC87NSumSkIwrJOwo/+WLslJ
	jKKocMd/F2KoyoRuOtpOtuAWc6MqCzSeyVn/dIQgcovBst2x+vl3J4zt95RoYN3kRPdU2X/q5uwAh
	vAe1bxOvKJz50juRlycUx/sofjQtnZ2JUMld3qc9zI5k9UW1VsEWJ7A9rzzml2sA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzbi-00000001zui-1MAn;
	Mon, 02 Nov 2026 22:30:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 4/4] wifi: mac80211: mlme: partially handle UHR updates
Date: Mon,  2 Nov 2026 22:26:31 +0100
Message-ID: <20261102223017.ec6333334341.I5971719ca3b4e4a7ddf552907e892aded74996ef@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102213017.1095413-6-johannes@sipsolutions.net>
References: <20261102213017.1095413-6-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Partially handle UHR updates, notably only handle them
if beacons with UHR parameter update element are received,
i.e. for now don't attempt to catch up on missed beacons
or inactive links by handling the Enhanced BSS Parameter
Change counter.

This also only handles the two features already present,
i.e. NPCA and DBE. For NPCA we still assume that drivers
will handle the OMP frame, but that may be better changed.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h |   2 +
 net/mac80211/ieee80211_i.h    |  10 +
 net/mac80211/mlme.c           | 514 +++++++++++++++++++++++++++++-----
 3 files changed, 452 insertions(+), 74 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 5c9a074ef7ef..7ecfbf0b6ea1 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -714,6 +714,8 @@ enum ieee80211_uhr_param_update_mode_id {
 	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE			= 4,
 	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_AP_PUO		= 5,
 	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_ELR_RX		= 6,
+
+	NUM_IEEE80211_UHR_PARAM_UPDATE_MODE_IDS
 };
 
 struct ieee80211_uhr_param_update_tuple {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6fd7f29349ab..05fa36a9066d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1105,6 +1105,16 @@ struct ieee80211_link_data_managed {
 
 	int wmm_last_param_set;
 	int mu_edca_last_param_set;
+
+	struct {
+		struct wiphy_hrtimer_work work;
+		/* bitfields using BIT(IEEE80211_UHR_PARAM_UPDATE_MODE_ID_*) */
+		u8 disabling, updating;
+		/* DBE was already enabled when this update was noticed */
+		bool dbe_was_enabled;
+
+		struct ieee80211_uhr_npca_info npca;
+	} uhr_param_upd;
 };
 
 struct ieee80211_link_data_ap {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d918f7ca36e7..40d535df3a4b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -182,7 +182,7 @@ struct ieee80211_determine_ap_chan_output {
 	/* filled to indicate UHR DBE was used */
 	bool dbe_used;
 	/* and need to know non-DBE width */
-	enum nl80211_chan_width non_dbe_width;
+	enum ieee80211_sta_rx_bandwidth non_dbe_width;
 };
 
 static bool
@@ -193,17 +193,53 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 {
 	const struct ieee802_11_elems *elems = data->elems;
 	const struct ieee80211_uhr_operation *uhr_oper = elems->uhr_operation;
+	bool beacon = elems->frame_type == (IEEE80211_FTYPE_MGMT |
+					    IEEE80211_STYPE_BEACON);
 	struct cfg80211_chan_def *chandef = data->chandef;
 	const struct ieee80211_uhr_param_update_tuple *tuple;
+	const struct ieee80211_uhr_npca_info *npca = NULL;
 	struct cfg80211_chan_def npca_chandef = *chandef;
+	const struct ieee80211_uhr_dbe_info *dbe = NULL;
 	const struct ieee80211_sta_uhr_cap *uhr_cap;
-	const struct ieee80211_uhr_npca_info *npca;
-	const struct ieee80211_uhr_dbe_info *dbe;
 	struct cfg80211_chan_def dbe_chandef;
 	bool npca_being_disabled = false;
 	bool dbe_being_disabled = false;
 
-	if (elems->frame_type == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
+	out->non_dbe_width = ieee80211_chan_width_to_rx_bw(chandef->width);
+
+	for_each_uhr_param_update_tuple(elems->uhr_param_upd,
+					elems->uhr_param_upd_len,
+					tuple) {
+		u8 mode = u8_get_bits(tuple->control,
+				      IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID);
+
+		if (tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE) {
+			/* ignore during pre-announcement */
+			if (elems->uhr_param_upd->countdown > 0 &&
+			    elems->uhr_param_upd->countdown < 128)
+				continue;
+			/* handle already enabled */
+			switch (mode) {
+			case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+				npca = (const void *)&tuple->variable[1];
+				break;
+			case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+				dbe = (const void *)&tuple->variable[1];
+				break;
+			}
+		} else {
+			switch (mode) {
+			case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+				npca_being_disabled = true;
+				break;
+			case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+				dbe_being_disabled = true;
+				break;
+			}
+		}
+	}
+
+	if (!dbe && beacon) {
 		int dbe_bw_mhz;
 		u8 dbe_bw;
 
@@ -211,6 +247,14 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 		    !cfg80211_chandef_compatible(chandef, data->cur_chandef))
 			return true;
 
+		/*
+		 * During DBE disable we still have cur_dbe_used until the
+		 * timer fires but could get the beacon slightly before that,
+		 * nothing to check and no DBE bandwidth to use in that case.
+		 */
+		if (!(uhr_oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_ENA)))
+			return true;
+
 		dbe_bw = le16_get_bits(uhr_oper->params,
 				       IEEE80211_UHR_OPER_PARAMS_DBE_BW);
 		dbe_bw_mhz = ieee80211_uhr_dbe_bw_mhz(dbe_bw);
@@ -228,71 +272,73 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* frames other than beacons carry UHR capability too */
-	if (!elems->uhr_cap)
+	if (!beacon && !elems->uhr_cap)
 		return false;
 
-	for_each_uhr_param_update_tuple(elems->uhr_param_upd,
-					elems->uhr_param_upd_len,
-					tuple) {
-		u8 mode = u8_get_bits(tuple->control,
-				      IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID);
-
-		/* ignore enabling/updates - handle from beacons later */
-		if (tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE)
-			continue;
-
-		switch (mode) {
-		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
-			npca_being_disabled = true;
-			break;
-		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
-			dbe_being_disabled = true;
-			break;
-		}
-	}
-
-	npca = ieee80211_uhr_npca_info(uhr_oper);
-
-	if (npca && !(elems->uhr_cap->mac.mac_cap[0] &
-			IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)) {
-		sdata_info(sdata,
-			   "AP without UHR NPCA capability uses it, disabling UHR\n");
-		return false;
-	}
-
-	/* DBE is not considered yet, so this works */
-	if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
-					 &npca_chandef, npca) ||
-	    cfg80211_chandef_add_npca(sdata->local->hw.wiphy,
-				      &npca_chandef,
-				      npca_being_disabled ? NULL : npca)) {
-		sdata_info(sdata,
-			   "AP UHR NPCA settings invalid, disabling UHR\n");
-		return false;
-	}
-
 	uhr_cap = ieee80211_get_uhr_iftype_cap_vif(sband, &sdata->vif);
 	/* can't happen since we must have UHR to parse the elems */
 	if (WARN_ON(!uhr_cap))
 		return false;
 
-	if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP) {
-		/* no-op if NPCA wasn't present or being disabled */
-		*chandef = npca_chandef;
+	if (!npca && !beacon)
+		npca = ieee80211_uhr_npca_info(uhr_oper);
+	if (npca) {
+		if (elems->uhr_cap &&
+		    !(elems->uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)) {
+			sdata_info(sdata,
+				   "AP without UHR NPCA capability uses it, disabling UHR\n");
+			return false;
+		}
+
+		/* DBE is not considered yet, so this works */
+		if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
+						 &npca_chandef, npca) ||
+		    cfg80211_chandef_add_npca(sdata->local->hw.wiphy,
+					      &npca_chandef,
+					      npca_being_disabled ? NULL : npca)) {
+			sdata_info(sdata,
+				   "AP UHR NPCA settings invalid, disabling UHR\n");
+			return false;
+		}
+
+		if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP) {
+			/* no-op if NPCA wasn't present or being disabled */
+			*chandef = npca_chandef;
+		}
 	}
 
-	dbe = ieee80211_uhr_oper_dbe_info(uhr_oper);
+	if (!dbe && !beacon)
+		dbe = ieee80211_uhr_oper_dbe_info(uhr_oper);
 	if (dbe) {
-		const struct ieee80211_uhr_cap_dbe *dbe_cap;
+		/* cannot check if there's no UHR capability */
+		u8 dbe_bw_cap = 0xff;
 		u8 dbe_bw_oper;
-		u8 dbe_bw_cap;
 
-		dbe_cap = ieee80211_uhr_dbe_cap(elems->uhr_cap);
+		if (elems->uhr_cap) {
+			const struct ieee80211_uhr_cap_dbe *dbe_cap;
 
-		if (!dbe_cap) {
-			sdata_info(sdata,
-				   "AP without UHR DBE capability uses it, disabling UHR\n");
-			return false;
+			dbe_cap = ieee80211_uhr_dbe_cap(elems->uhr_cap);
+
+			if (!dbe_cap) {
+				sdata_info(sdata,
+					   "AP without UHR DBE capability uses it, disabling UHR\n");
+				return false;
+			}
+
+			dbe_bw_cap = u8_get_bits(dbe_cap->cap,
+						 IEEE80211_UHR_MAC_CAP_DBE_MAX_BW);
+
+			switch (dbe_bw_cap) {
+			case IEEE80211_UHR_DBE_MAX_BW_40:
+			case IEEE80211_UHR_DBE_MAX_BW_80:
+			case IEEE80211_UHR_DBE_MAX_BW_160:
+			case IEEE80211_UHR_DBE_MAX_BW_320:
+				break;
+			default:
+				sdata_info(sdata,
+					   "AP UHR DBE capability invalid, disabling UHR\n");
+				return false;
+			}
 		}
 
 		dbe_bw_oper = u8_get_bits(dbe->params,
@@ -311,21 +357,6 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 			return false;
 		}
 
-		dbe_bw_cap = u8_get_bits(dbe_cap->cap,
-					 IEEE80211_UHR_MAC_CAP_DBE_MAX_BW);
-
-		switch (dbe_bw_cap) {
-		case IEEE80211_UHR_DBE_MAX_BW_40:
-		case IEEE80211_UHR_DBE_MAX_BW_80:
-		case IEEE80211_UHR_DBE_MAX_BW_160:
-		case IEEE80211_UHR_DBE_MAX_BW_320:
-			break;
-		default:
-			sdata_info(sdata,
-				   "AP UHR DBE capability invalid, disabling UHR\n");
-			return false;
-		}
-
 		/* 1-4 are same in DBE capabilities, map 320-2 to 320 */
 		if (dbe_bw_oper == IEEE80211_UHR_DBE_OPER_BW_320_2)
 			dbe_bw_oper = IEEE80211_UHR_DBE_MAX_BW_320;
@@ -352,7 +383,6 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	    uhr_cap->mac.mac_cap[1] & IEEE80211_UHR_MAC_CAP1_DBE_SUPP &&
 	    ieee80211_chandef_usable(sdata, &dbe_chandef,
 				     IEEE80211_CHAN_DISABLED)) {
-		out->non_dbe_width = chandef->width;
 		*chandef = dbe_chandef;
 		out->dbe_used = true;
 	}
@@ -382,6 +412,8 @@ ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 	u32 ht_cfreq;
 
 	memset(out, 0, sizeof(*out));
+	/* restricted to chanctx width later anyway */
+	out->non_dbe_width = IEEE80211_STA_RX_BW_MAX;
 
 	if (ieee80211_hw_check(&sdata->local->hw, STRICT))
 		ignore_ht_channel_mismatch = false;
@@ -1495,8 +1527,7 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (conn->dbe_enabled && link_sta)
-		link_sta->uhr_usable_tx_width =
-			ieee80211_chan_width_to_rx_bw(ap_chan_out.non_dbe_width);
+		link_sta->uhr_usable_tx_width = ap_chan_out.non_dbe_width;
 
 	return elems;
 free:
@@ -1650,6 +1681,7 @@ static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
 
 struct ieee80211_config_bw_out {
 	u64 changed;
+	enum ieee80211_sta_rx_bandwidth ap_non_dbe_width;
 };
 
 static int ieee80211_config_bw(struct ieee80211_link_data *link,
@@ -1711,6 +1743,8 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 					      &ap_chan_out);
 	link->u.mgd.conn.dbe_enabled = ap_chan_out.dbe_used;
 
+	out->ap_non_dbe_width = ap_chan_out.non_dbe_width;
+
 	if (ap_mode != link->u.mgd.conn.mode) {
 		link_info(link,
 			  "AP %pM appears to change mode (expected %s, found %s) in %s, disconnect\n",
@@ -8201,6 +8235,314 @@ static bool ieee80211_mgd_ssid_mismatch(struct ieee80211_sub_if_data *sdata,
 	return memcmp(elems->ssid, cfg->ssid, cfg->ssid_len);
 }
 
+static bool
+ieee80211_prepare_uhr_param_upd_dbe(struct ieee80211_link_data *link,
+				    struct link_sta_info *link_sta,
+				    const struct ieee80211_uhr_param_update_tuple *tuple,
+				    enum ieee80211_sta_rx_bandwidth ap_non_dbe_width,
+				    bool dbe_enabled_before)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+	enum ieee80211_sta_rx_bandwidth usable_width;
+
+	if (tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE) {
+		const struct ieee80211_uhr_dbe_info *dbe;
+		u8 dbe_bw_new;
+
+		/* validity already checked */
+		dbe = (const void *)(tuple->variable + 1);
+
+		link->u.mgd.uhr_param_upd.dbe_was_enabled = dbe_enabled_before;
+
+		/*
+		 * if we hadn't enabled it only enable after the AP - but
+		 * leave the STA at non-DBE until the OMP handshake
+		 */
+		if (!dbe_enabled_before) {
+			link_sta->uhr_usable_tx_width = ap_non_dbe_width;
+			ieee80211_link_sta_update_rc_bw(link, link_sta);
+			return true;
+		}
+
+		dbe_bw_new = u8_get_bits(dbe->params,
+					 IEEE80211_UHR_DBE_OPER_BANDWIDTH);
+
+		switch (dbe_bw_new) {
+		case IEEE80211_UHR_DBE_OPER_BW_40:
+			usable_width = IEEE80211_STA_RX_BW_40;
+			break;
+		case IEEE80211_UHR_DBE_OPER_BW_80:
+			usable_width = IEEE80211_STA_RX_BW_80;
+			break;
+		case IEEE80211_UHR_DBE_OPER_BW_160:
+		case IEEE80211_UHR_DBE_OPER_BW_320_1:
+		case IEEE80211_UHR_DBE_OPER_BW_320_2:
+			/*
+			 * Limit to 160 even for 320 here as the AP might switch
+			 * from 320-1 to 320-2 or vice versa and the chandef
+			 * isn't updated yet, and won't be until the switch.
+			 */
+			usable_width = IEEE80211_STA_RX_BW_160;
+			break;
+		default:
+			sdata_info(sdata,
+				   "AP switches to DBE BW %d, disconnect\n",
+				   dbe_bw_new);
+			__ieee80211_disconnect(sdata);
+			return false;
+		}
+	} else {
+		usable_width = ap_non_dbe_width;
+	}
+
+	/* to avoid races stop using the wider BW towards the AP immediately */
+	link_sta->uhr_usable_tx_width = usable_width;
+	ieee80211_link_sta_update_rc_bw(link, link_sta);
+	return true;
+}
+
+static void
+ieee80211_apply_uhr_param_upd_dbe(struct ieee80211_link_data *link,
+				  struct link_sta_info *link_sta)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+
+	if (link->u.mgd.uhr_param_upd.disabling &
+			BIT(IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE)) {
+		/* prepare() already narrowed the STA's bw */
+		link->u.mgd.conn.dbe_enabled = false;
+		return;
+	}
+
+	if (link->u.mgd.uhr_param_upd.dbe_was_enabled) {
+		/* the chanctx bandwidth was already handled, update the STA */
+		link_sta->uhr_usable_tx_width = IEEE80211_STA_RX_BW_MAX;
+		ieee80211_link_sta_update_rc_bw(link, link_sta);
+		return;
+	}
+
+	/* newly enabled, now that the AP is using it send an OMP request */
+	link->u.mgd.conn.dbe_enabled = true;
+	ieee80211_send_uhr_omp_req_dbe(sdata, BIT(link->link_id), false);
+}
+
+static void
+ieee80211_prepare_uhr_param_upd_npca(struct ieee80211_link_data *link,
+				     const struct ieee80211_uhr_param_update_tuple *tuple)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+
+	if (tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE) {
+		const struct ieee80211_uhr_npca_info *npca;
+
+		/* validity already checked */
+		npca = (const void *)(tuple->variable + 1);
+
+		link->u.mgd.uhr_param_upd.npca = *npca;
+		return;
+	}
+
+	/* disable NPCA immediately - currently expect driver to handle OMP */
+	link->conf->npca.enabled = false;
+	ieee80211_link_info_change_notify(sdata, link, BSS_CHANGED_NPCA);
+}
+
+static void
+ieee80211_apply_uhr_param_upd_npca(struct ieee80211_link_data *link)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+	const struct ieee80211_uhr_npca_info *npca =
+		&link->u.mgd.uhr_param_upd.npca;
+	struct ieee80211_bss_npca_params params = {
+		.min_dur_thresh =
+			le32_get_bits(npca->params,
+				      IEEE80211_UHR_NPCA_PARAMS_MIN_DUR_THRESH),
+		.switch_delay =
+			le32_get_bits(npca->params,
+				      IEEE80211_UHR_NPCA_PARAMS_SWITCH_DELAY),
+		.switch_back_delay =
+			le32_get_bits(npca->params,
+				      IEEE80211_UHR_NPCA_PARAMS_SWITCH_BACK_DELAY),
+		.init_qsrc =
+			le32_get_bits(npca->params,
+				      IEEE80211_UHR_NPCA_PARAMS_INIT_QSRC),
+		.moplen =
+			le32_get_bits(npca->params,
+				      IEEE80211_UHR_NPCA_PARAMS_MOPLEN),
+		.enabled = true,
+	};
+
+	/* already handled */
+	if (link->u.mgd.uhr_param_upd.disabling &
+			BIT(IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA))
+		return;
+
+	if (!memcmp(&params, &link->conf->npca, sizeof(params)))
+		return;
+
+	link->conf->npca = params;
+	ieee80211_link_info_change_notify(sdata, link, BSS_CHANGED_NPCA);
+}
+
+static bool
+ieee80211_prepare_uhr_param_upd(struct ieee80211_link_data *link,
+				struct link_sta_info *link_sta,
+				const struct ieee80211_uhr_parameters_update *upd,
+				size_t upd_len,
+				enum ieee80211_sta_rx_bandwidth ap_non_dbe_width,
+				bool dbe_enabled_before)
+{
+	const struct ieee80211_uhr_param_update_tuple *tuple;
+
+	BUILD_BUG_ON(NUM_IEEE80211_UHR_PARAM_UPDATE_MODE_IDS >
+		     BITS_PER_BYTE * sizeof(link->u.mgd.uhr_param_upd.updating));
+
+	for_each_uhr_param_update_tuple(upd, upd_len, tuple) {
+		u8 mode = u8_get_bits(tuple->control,
+				      IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID);
+		bool enable = tuple->control &
+			      IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE;
+
+		if (mode >= NUM_IEEE80211_UHR_PARAM_UPDATE_MODE_IDS)
+			continue;
+
+		/*
+		 * Check if it's already tracked from a previous beacon RX,
+		 * in which case we would already have done the preparation.
+		 * This should be true for all or none, so could be 'return'
+		 * instead of continue, but this way might work better if we
+		 * miss a lot of beacons.
+		 */
+		if (link->u.mgd.uhr_param_upd.updating & BIT(mode))
+			continue;
+
+		link->u.mgd.uhr_param_upd.updating |= BIT(mode);
+		if (!enable)
+			link->u.mgd.uhr_param_upd.disabling |= BIT(mode);
+
+		switch (mode) {
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+			if (!ieee80211_prepare_uhr_param_upd_dbe(link, link_sta,
+								 tuple,
+								 ap_non_dbe_width,
+								 dbe_enabled_before))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+			ieee80211_prepare_uhr_param_upd_npca(link, tuple);
+			break;
+		}
+	}
+
+	return true;
+}
+
+static void ieee80211_apply_uhr_param_upd(struct ieee80211_link_data *link,
+					  struct link_sta_info *link_sta)
+{
+	unsigned long updating = link->u.mgd.uhr_param_upd.updating;
+	u8 mode;
+
+	for_each_set_bit(mode, &updating, NUM_IEEE80211_UHR_PARAM_UPDATE_MODE_IDS) {
+		switch (mode) {
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+			ieee80211_apply_uhr_param_upd_dbe(link, link_sta);
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+			ieee80211_apply_uhr_param_upd_npca(link);
+			break;
+		}
+	}
+	/* TODO: apply pending UHR parameter update */
+
+	/* all done, no further tracking of this update */
+	link->u.mgd.uhr_param_upd.updating = 0;
+	link->u.mgd.uhr_param_upd.disabling = 0;
+	link->u.mgd.uhr_param_upd.dbe_was_enabled = false;
+}
+
+static void ieee80211_uhr_param_upd_work(struct wiphy *wiphy,
+					 struct wiphy_work *work)
+{
+	struct ieee80211_link_data *link =
+		container_of(work, struct ieee80211_link_data,
+			     u.mgd.uhr_param_upd.work.work);
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+	struct link_sta_info *link_sta;
+	struct sta_info *sta;
+
+	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
+	if (WARN_ON(!sta))
+		return;
+
+	link_sta = sdata_dereference(sta->link[link->link_id], sdata);
+	if (WARN_ON(!link_sta))
+		return;
+
+	ieee80211_apply_uhr_param_upd(link, link_sta);
+}
+
+static bool
+ieee80211_rx_mgmt_beacon_uhr_param_upd(struct ieee80211_local *local,
+				       struct ieee80211_link_data *link,
+				       struct link_sta_info *link_sta,
+				       const struct ieee802_11_elems *elems,
+				       enum ieee80211_sta_rx_bandwidth ap_non_dbe_width,
+				       bool dbe_enabled_before)
+{
+	if (!elems->uhr_param_upd) {
+		/*
+		 * This should be the common case, there are no updates
+		 * (no element present) and there were no updates that
+		 * we're still tracking.
+		 */
+		if (!link->u.mgd.uhr_param_upd.updating)
+			return true;
+
+		/*
+		 * Otherwise, the element got dropped (we may have missed
+		 * many beacons) - cancel the timer and apply pending changes.
+		 */
+		wiphy_hrtimer_work_cancel(local->hw.wiphy,
+					  &link->u.mgd.uhr_param_upd.work);
+		ieee80211_apply_uhr_param_upd(link, link_sta);
+		return true;
+	}
+
+	if (elems->uhr_param_upd->countdown >= 128 ||
+	    elems->uhr_param_upd->countdown == 0) {
+		/*
+		 * AP announces changes happened in the past or right now,
+		 * apply now.
+		 */
+		if (!link->u.mgd.uhr_param_upd.updating &&
+		    !ieee80211_prepare_uhr_param_upd(link, link_sta,
+						     elems->uhr_param_upd,
+						     elems->uhr_param_upd_len,
+						     ap_non_dbe_width,
+						     dbe_enabled_before))
+			return false;
+
+		wiphy_hrtimer_work_cancel(local->hw.wiphy,
+					  &link->u.mgd.uhr_param_upd.work);
+		ieee80211_apply_uhr_param_upd(link, link_sta);
+		return true;
+	}
+
+	/* prepare for updates and arm a timer to handle them */
+	if (!ieee80211_prepare_uhr_param_upd(link, link_sta,
+					     elems->uhr_param_upd,
+					     elems->uhr_param_upd_len,
+					     ap_non_dbe_width,
+					     dbe_enabled_before))
+		return false;
+	wiphy_hrtimer_work_queue(local->hw.wiphy,
+				 &link->u.mgd.uhr_param_upd.work,
+				 ieee80211_tu_to_ktime((u64)elems->uhr_param_upd->countdown *
+						       link->conf->beacon_int));
+	return true;
+}
+
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 				     struct ieee80211_hdr *hdr, size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -8219,6 +8561,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	struct link_sta_info *link_sta;
+	bool dbe_enabled_before;
 	struct sta_info *sta;
 	u64 changed = 0;
 	u32 ncrc = 0;
@@ -8537,6 +8880,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	changed |= ieee80211_recalc_twt_req(sdata, sband, link, link_sta, elems);
 
+	/* ieee80211_config_bw() can change this */
+	dbe_enabled_before = link->u.mgd.conn.dbe_enabled;
+
 	if (ieee80211_config_bw(link, elems, true, IEEE80211_STYPE_BEACON,
 				&config_bw_out)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
@@ -8551,6 +8897,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	changed |= config_bw_out.changed;
 
+	/*
+	 * This looks odd - but when we track UHR DBE changes, we first
+	 * narrow the TX bandwidth towards the AP and then rely on just
+	 * tracking future beacons to change the chanctx. Once that has
+	 * actually changed, the TX towards the AP is restricted anyway.
+	 *
+	 * Since we don't have an explicit "the DBE update happened"
+	 * signal, just reset the AP STA's bandwidth when we changed BW.
+	 */
+	if (config_bw_out.changed & BSS_CHANGED_BANDWIDTH)
+		link_sta->uhr_usable_tx_width = IEEE80211_STA_RX_BW_MAX;
+
 	if (elems->opmode_notif)
 		ieee80211_vht_handle_opmode(sdata, link_sta,
 					    *elems->opmode_notif,
@@ -8565,6 +8923,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	ieee80211_ml_reconfiguration(sdata, elems);
 	ieee80211_process_adv_ttlm(sdata, elems,
 				      le64_to_cpu(mgmt->u.beacon.timestamp));
+	if (!ieee80211_rx_mgmt_beacon_uhr_param_upd(local, link, link_sta, elems,
+						    config_bw_out.ap_non_dbe_width,
+						    dbe_enabled_before))
+		goto free;
 
 apply:
 	ieee80211_link_info_change_notify(sdata, link, changed);
@@ -9704,6 +10066,8 @@ void ieee80211_mgd_setup_link(struct ieee80211_link_data *link)
 
 	wiphy_hrtimer_work_init(&link->u.mgd.csa.switch_work,
 				ieee80211_csa_switch_work);
+	wiphy_hrtimer_work_init(&link->u.mgd.uhr_param_upd.work,
+				ieee80211_uhr_param_upd_work);
 
 	ieee80211_clear_tpe(&link->conf->tpe);
 
@@ -10955,6 +11319,8 @@ void ieee80211_mgd_stop_link(struct ieee80211_link_data *link)
 			  &link->u.mgd.recalc_smps);
 	wiphy_hrtimer_work_cancel(link->sdata->local->hw.wiphy,
 				  &link->u.mgd.csa.switch_work);
+	wiphy_hrtimer_work_cancel(link->sdata->local->hw.wiphy,
+				  &link->u.mgd.uhr_param_upd.work);
 }
 
 void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
-- 
2.56.0

