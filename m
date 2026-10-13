Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638F4509F01
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898615; cv=none; b=PMRF56UIGKKHsNLx1D7NOXBCEaIBXvnaPF4zN8HP9fXMU0AYBypCNSo6ObL/6dyyfm4tTeEdAm5m6zQ5N4ZqvM0nUPI49xE6OHqSUMbchxUbY6KKgIT9fijCvNNXrPsDcdA6+W9614Nmp3823upB3wqbRZ0C3quv/bHHxNe7FKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898615; c=relaxed/simple;
	bh=ofmwdUp17tgc4saQ1W0vRi7xU/7PMebtkYk7U8fD39g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFhghZxnyPjWf1k66vI1W3s0+w8F9jns0sPNytCUWFl83kHZh/LCicwg4moB2XIL8jqZS0Wd991jJ1SZckJxzcFyQmwMr9jRvDGecD5LSXxG9syn/ORzAKhXn+UJe48FHzLDRSbXlXZeEnZTFcMhwr34ZVnWUJXhup4VALYSNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CZS1Jt2j; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CZS1Jt2j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3Gy6dnq3ylfl+IArxfuKfKxq4u3m8TgNqjPx6jpBv1k=;
	t=1791898613; x=1793108213; b=CZS1Jt2jKwaUBrtJephPUdfYg6v4SI9A/pYUSGWhWNIInn3
	vtA4nRUi0nDyeDQqIV5pUjNdIyhL4VdwtAv3jPk4cWLX1p8JvuDxRlPwYTTAAJbPu5PvRMVakNsFx
	grU9NlbomtQr20MGE4dtz/ezhhcJWdnYbDV7x8hTmD4NeF/ASh9EIde2U+cH3T7IzadQ/KiYueHNU
	VotR7SgwZ7ZeGaOUeNQ664upSVsBT7ZJ9hiuOblXPO+ycuvaoxBGy3hu1PExecnIu4fPjQI8xCoxt
	/nwrWrzuM4wUEWbsIwuU+Iv9uYRmHfBU6GHL5wGCQB0t+9Sk6VeOOVdo8ryMhJjQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgP-0000000HRBK-0Y89;
	Tue, 13 Oct 2026 15:36:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 02/10] wifi: mac80211: refactor UHR code from AP channel determination
Date: Tue, 13 Oct 2026 15:25:14 +0200
Message-ID: <20261013153640.2c019565b808.Ia668cdf25c3bce621fd178e47790b3285393c647@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013133640.270974-12-johannes@sipsolutions.net>
References: <20261013133640.270974-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This code is only going to grow with more UHR complexity
(e.g. I'm going to add checks for UHR parameter updates)
and it's already long, move it to a separate function.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 276 ++++++++++++++++++++++++--------------------
 1 file changed, 148 insertions(+), 128 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6ec45a9f7221..5a02bf98e14f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -185,6 +185,152 @@ struct ieee80211_determine_ap_chan_output {
 	enum nl80211_chan_width non_dbe_width;
 };
 
+static bool
+ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_supported_band *sband,
+				const struct ieee80211_determine_ap_chan_data *data,
+				struct ieee80211_determine_ap_chan_output *out)
+{
+	const struct ieee802_11_elems *elems = data->elems;
+	const struct ieee80211_uhr_operation *uhr_oper = elems->uhr_operation;
+	struct cfg80211_chan_def *chandef = data->chandef;
+	struct cfg80211_chan_def npca_chandef = *chandef;
+	const struct ieee80211_sta_uhr_cap *uhr_cap;
+	const struct ieee80211_uhr_npca_info *npca;
+	const struct ieee80211_uhr_dbe_info *dbe;
+	struct cfg80211_chan_def dbe_chandef;
+
+	if (elems->frame_type == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
+		int dbe_bw_mhz;
+		u8 dbe_bw;
+
+		if (!data->cur_chandef || !data->cur_dbe_used ||
+		    !cfg80211_chandef_compatible(chandef, data->cur_chandef))
+			return true;
+
+		dbe_bw = le16_get_bits(uhr_oper->params,
+				       IEEE80211_UHR_OPER_PARAMS_DBE_BW);
+		dbe_bw_mhz = ieee80211_uhr_dbe_bw_mhz(dbe_bw);
+		if (dbe_bw_mhz < 0) {
+			sdata_info(sdata, "AP UHR DBE bandwidth invalid, drop UHR\n");
+			return false;
+		}
+
+		if (cfg80211_chandef_get_width(data->cur_chandef) == dbe_bw_mhz) {
+			*chandef = *data->cur_chandef;
+			out->dbe_used = true;
+		}
+
+		return true;
+	}
+
+	/* frames other than beacons carry UHR capability too */
+	if (!elems->uhr_cap)
+		return false;
+
+	npca = ieee80211_uhr_npca_info(uhr_oper);
+
+	if (npca && !(elems->uhr_cap->mac.mac_cap[0] &
+			IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)) {
+		sdata_info(sdata,
+			   "AP without UHR NPCA capability uses it, disabling UHR\n");
+		return false;
+	}
+
+	/* DBE is not considered yet, so this works */
+	if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
+					 &npca_chandef, npca) ||
+	    cfg80211_chandef_add_npca(sdata->local->hw.wiphy,
+				      &npca_chandef, npca)) {
+		sdata_info(sdata,
+			   "AP UHR NPCA settings invalid, disabling UHR\n");
+		return false;
+	}
+
+	uhr_cap = ieee80211_get_uhr_iftype_cap_vif(sband, &sdata->vif);
+	/* can't happen since we must have UHR to parse the elems */
+	if (WARN_ON(!uhr_cap))
+		return false;
+
+	if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)
+		*chandef = npca_chandef;
+
+	dbe = ieee80211_uhr_oper_dbe_info(uhr_oper);
+	if (dbe) {
+		const struct ieee80211_uhr_cap_dbe *dbe_cap;
+		u8 dbe_bw_oper;
+		u8 dbe_bw_cap;
+
+		dbe_cap = ieee80211_uhr_dbe_cap(elems->uhr_cap);
+
+		if (!dbe_cap) {
+			sdata_info(sdata,
+				   "AP without UHR DBE capability uses it, disabling UHR\n");
+			return false;
+		}
+
+		dbe_bw_oper = u8_get_bits(dbe->params,
+					  IEEE80211_UHR_DBE_OPER_BANDWIDTH);
+
+		if (le16_get_bits(uhr_oper->params,
+				  IEEE80211_UHR_OPER_PARAMS_DBE_BW) != dbe_bw_oper) {
+			sdata_info(sdata,
+				   "AP UHR DBE settings mismatch, disabling UHR\n");
+			return false;
+		}
+
+		if (ieee80211_uhr_dbe_bw_mhz(dbe_bw_oper) < 0) {
+			sdata_info(sdata,
+				   "AP UHR DBE bandwidth invalid, disabling UHR\n");
+			return false;
+		}
+
+		dbe_bw_cap = u8_get_bits(dbe_cap->cap,
+					 IEEE80211_UHR_MAC_CAP_DBE_MAX_BW);
+
+		switch (dbe_bw_cap) {
+		case IEEE80211_UHR_DBE_MAX_BW_40:
+		case IEEE80211_UHR_DBE_MAX_BW_80:
+		case IEEE80211_UHR_DBE_MAX_BW_160:
+		case IEEE80211_UHR_DBE_MAX_BW_320:
+			break;
+		default:
+			sdata_info(sdata,
+				   "AP UHR DBE capability invalid, disabling UHR\n");
+			return false;
+		}
+
+		/* 1-4 are same in DBE capabilities, map 320-2 to 320 */
+		if (dbe_bw_oper == IEEE80211_UHR_DBE_OPER_BW_320_2)
+			dbe_bw_oper = IEEE80211_UHR_DBE_MAX_BW_320;
+		if (dbe_bw_oper > dbe_bw_cap) {
+			sdata_info(sdata,
+				   "AP UHR DBE wider than capability, disabling UHR\n");
+			return false;
+		}
+	}
+
+	dbe_chandef = *chandef;
+
+	if (cfg80211_chandef_add_dbe(&dbe_chandef, dbe)) {
+		sdata_info(sdata,
+			   "AP UHR DBE settings invalid, disabling UHR\n");
+		return false;
+	}
+
+	if (dbe &&
+	    /* maybe driver would like to never use DBE */
+	    uhr_cap->mac.mac_cap[1] & IEEE80211_UHR_MAC_CAP1_DBE_SUPP &&
+	    ieee80211_chandef_usable(sdata, &dbe_chandef,
+				     IEEE80211_CHAN_DISABLED)) {
+		out->non_dbe_width = chandef->width;
+		*chandef = dbe_chandef;
+		out->dbe_used = true;
+	}
+
+	return true;
+}
+
 static enum ieee80211_conn_mode
 ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 			    const struct ieee80211_determine_ap_chan_data *data,
@@ -404,134 +550,8 @@ ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 	if (conn->mode < IEEE80211_CONN_MODE_UHR || !uhr_oper || !elems->ml_basic)
 		return IEEE80211_CONN_MODE_EHT;
 
-	if (elems->frame_type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
-		struct cfg80211_chan_def npca_chandef = *chandef;
-		const struct ieee80211_sta_uhr_cap *uhr_cap;
-		const struct ieee80211_uhr_npca_info *npca;
-		const struct ieee80211_uhr_dbe_info *dbe;
-		struct cfg80211_chan_def dbe_chandef;
-
-		/* frames other than beacons carry UHR capability too */
-		if (!elems->uhr_cap)
-			return IEEE80211_CONN_MODE_EHT;
-
-		npca = ieee80211_uhr_npca_info(uhr_oper);
-
-		if (npca && !(elems->uhr_cap->mac.mac_cap[0] &
-				IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)) {
-			sdata_info(sdata,
-				   "AP without UHR NPCA capability uses it, disabling UHR\n");
-			return IEEE80211_CONN_MODE_EHT;
-		}
-
-		/* DBE is not considered yet, so this works */
-		if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
-						 &npca_chandef, npca) ||
-		    cfg80211_chandef_add_npca(sdata->local->hw.wiphy,
-					      &npca_chandef, npca)) {
-			sdata_info(sdata,
-				   "AP UHR NPCA settings invalid, disabling UHR\n");
-			return IEEE80211_CONN_MODE_EHT;
-		}
-
-		uhr_cap = ieee80211_get_uhr_iftype_cap_vif(sband, &sdata->vif);
-		/* can't happen since we must have UHR to parse the elems */
-		if (WARN_ON(!uhr_cap))
-			return IEEE80211_CONN_MODE_EHT;
-
-		if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)
-			*chandef = npca_chandef;
-
-		dbe = ieee80211_uhr_oper_dbe_info(uhr_oper);
-		if (dbe) {
-			const struct ieee80211_uhr_cap_dbe *dbe_cap;
-			u8 dbe_bw_oper;
-			u8 dbe_bw_cap;
-
-			dbe_cap = ieee80211_uhr_dbe_cap(elems->uhr_cap);
-
-			if (!dbe_cap) {
-				sdata_info(sdata,
-					   "AP without UHR DBE capability uses it, disabling UHR\n");
-				return IEEE80211_CONN_MODE_EHT;
-			}
-
-			dbe_bw_oper = u8_get_bits(dbe->params,
-						  IEEE80211_UHR_DBE_OPER_BANDWIDTH);
-
-			if (le16_get_bits(uhr_oper->params,
-					  IEEE80211_UHR_OPER_PARAMS_DBE_BW) != dbe_bw_oper) {
-				sdata_info(sdata,
-					   "AP UHR DBE settings mismatch, disabling UHR\n");
-				return IEEE80211_CONN_MODE_EHT;
-			}
-
-			if (ieee80211_uhr_dbe_bw_mhz(dbe_bw_oper) < 0) {
-				sdata_info(sdata,
-					   "AP UHR DBE bandwidth invalid, disabling UHR\n");
-				return IEEE80211_CONN_MODE_EHT;
-			}
-
-			dbe_bw_cap = u8_get_bits(dbe_cap->cap,
-						 IEEE80211_UHR_MAC_CAP_DBE_MAX_BW);
-
-			switch (dbe_bw_cap) {
-			case IEEE80211_UHR_DBE_MAX_BW_40:
-			case IEEE80211_UHR_DBE_MAX_BW_80:
-			case IEEE80211_UHR_DBE_MAX_BW_160:
-			case IEEE80211_UHR_DBE_MAX_BW_320:
-				break;
-			default:
-				sdata_info(sdata,
-					   "AP UHR DBE capability invalid, disabling UHR\n");
-				return IEEE80211_CONN_MODE_EHT;
-			}
-
-			/* 1-4 are same in DBE capabilities, map 320-2 to 320 */
-			if (dbe_bw_oper == IEEE80211_UHR_DBE_OPER_BW_320_2)
-				dbe_bw_oper = IEEE80211_UHR_DBE_MAX_BW_320;
-			if (dbe_bw_oper > dbe_bw_cap) {
-				sdata_info(sdata,
-					   "AP UHR DBE wider than capability, disabling UHR\n");
-				return IEEE80211_CONN_MODE_EHT;
-			}
-		}
-
-		dbe_chandef = *chandef;
-
-		if (cfg80211_chandef_add_dbe(&dbe_chandef, dbe)) {
-			sdata_info(sdata,
-				   "AP UHR DBE settings invalid, disabling UHR\n");
-			return IEEE80211_CONN_MODE_EHT;
-		}
-
-		if (dbe &&
-		    /* maybe driver would like to never use DBE */
-		    uhr_cap->mac.mac_cap[1] & IEEE80211_UHR_MAC_CAP1_DBE_SUPP &&
-		    ieee80211_chandef_usable(sdata, &dbe_chandef,
-					     IEEE80211_CHAN_DISABLED)) {
-			out->non_dbe_width = chandef->width;
-			*chandef = dbe_chandef;
-			out->dbe_used = true;
-		}
-	} else if (data->cur_chandef && data->cur_dbe_used &&
-		   cfg80211_chandef_compatible(chandef, data->cur_chandef)) {
-		u8 dbe_bw = le16_get_bits(uhr_oper->params,
-					  IEEE80211_UHR_OPER_PARAMS_DBE_BW);
-		int dbe_bw_mhz;
-
-		dbe_bw_mhz = ieee80211_uhr_dbe_bw_mhz(dbe_bw);
-		if (dbe_bw_mhz < 0) {
-			sdata_info(sdata,
-				   "AP UHR DBE bandwidth invalid, drop UHR\n");
-			return IEEE80211_CONN_MODE_EHT;
-		}
-
-		if (cfg80211_chandef_get_width(data->cur_chandef) == dbe_bw_mhz) {
-			*chandef = *data->cur_chandef;
-			out->dbe_used = true;
-		}
-	}
+	if (!ieee80211_determine_ap_chan_uhr(sdata, sband, data, out))
+		return IEEE80211_CONN_MODE_EHT;
 
 	return IEEE80211_CONN_MODE_UHR;
 }
-- 
2.56.0

