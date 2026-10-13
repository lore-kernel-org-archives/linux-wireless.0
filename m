Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB2E5226BD
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898618; cv=none; b=DhOJPw+pG+z5MGmNVMujZ8y2/q5EFABgvJuDwBIkK0EsHD9/Pr3l+8Y6PUtdyiyo1M5QJU7Sh+mhiFPi1HU+GaIb5DagfM+/nKPhPfzPaSWEUXX/4b1oVISE4T8pgUpjYkhKZmlf7p3JSJbo98r4reitmrcT4x88T17dE/+8lt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898618; c=relaxed/simple;
	bh=m5syj4vvD/UedUd2h5L31UjO0bTuoKAfVLJ/ymSlp2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p03p2nnlPV1flBwwa5d8KvPsty0S1Ewh6LACTpWLQlJKvjIcobDVeOIx+XBbRSumOC8pCoQGHsE+eUVvGzS0OEt4flhsJYJ7mqjy3acjBNFJRpw2WNTk7BeutjKT88vQLYW77N0wfmxwqDmjNwKhyWYC3JGZjxu+undztIG13Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=N6wcH89M; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="N6wcH89M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=E4YxA6IKyQb4aZyPyRN0wgHRoBtxrUAgyAPwDrhtEwc=;
	t=1791898616; x=1793108216; b=N6wcH89MZC2dXW2WUkWOYJKGYp8iKUO6LgYepFR8UCqEnWO
	5n5J+nduyEPDg/3XNlxksUk2yd8kLcjyWmEBKy5ngTnAzXXZ20nKwlwad9ivf9oiVLm4wvsjO5tKW
	1tjKLQR3K83L0KJESjKQ+E/ehp9PqtYYSR5hfcyx+FOQE67pVjQRgM3ZKHJk3CtkIoL9wEWtcM3zn
	DbpHs4m713AzN5tJJc4U1rXe2oTyQ6CxJOFLdpQllZM5m7KONE2ppkrAEUG9TUiAdfT8pU399QMrk
	vsMXHes9YtaH2XVBcQ6EifJMm1w4kn+jVR7XQf0b1162et25gCVEOqzWu/e3OsSQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgR-0000000HRBK-30TA;
	Tue, 13 Oct 2026 15:36:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 06/10] wifi: mac80211: track APs UHR DBE capabilities
Date: Tue, 13 Oct 2026 15:25:18 +0200
Message-ID: <20261013153640.79eba411bb74.I2900ed0854bb2cfe3a4eafc19f88a30d044b83f6@changeid>
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

The spec now decided that DBE capabilities are there,
vs. just having EHT capabilities, overriding the EHT
ones for bandwidths that aren't advertised for EHT.

Parse those from the DBE capabilities and store them
in EHT so they're treated the same, regardless of EHT
having advertised them before or not.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h |  2 +-
 net/mac80211/cfg.c            |  3 +-
 net/mac80211/ieee80211_i.h    |  2 +-
 net/mac80211/mlme.c           |  3 +-
 net/mac80211/uhr.c            | 64 ++++++++++++++++++++++++++++++++++-
 5 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index aef487b984e5..f2adb26cad66 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -466,7 +466,7 @@ struct ieee80211_uhr_cap_dbe {
 	u8 max_switch_time_period;
 	u8 mode_change_intvl;
 	/* present 0, 1 or 2 times depending on _PRES bits */
-	struct {
+	struct ieee80211_uhr_cap_dbe_bwcap {
 		struct ieee80211_eht_mcs_nss_supp_bw eht_mcs_map;
 		u8 cap;
 	} __packed bwcap[];
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9608c07bcea7..f5f8efdce48e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2711,8 +2711,7 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	if (params->uhr_capa)
 		ieee80211_uhr_cap_ie_to_sta_uhr_cap(sdata, sband,
 						    params->uhr_capa,
-						    params->uhr_capa_len,
-						    link_sta);
+						    false, link_sta);
 
 	if (params->s1g_capa)
 		ieee80211_s1g_cap_to_sta_s1g_cap(sdata, params->s1g_capa,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e321a50e5a6c..dc1019807693 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -3021,7 +3021,7 @@ void
 ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_uhr_cap *uhr_cap,
-				    u8 uhr_cap_len,
+				    bool from_ap,
 				    struct link_sta_info *link_sta);
 
 #if IS_ENABLED(CONFIG_MAC80211_KUNIT_TEST)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bd9844f2d075..ba3c6ad590bc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6275,8 +6275,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 
 		ieee80211_uhr_cap_ie_to_sta_uhr_cap(sdata, sband,
 						    elems->uhr_cap,
-						    elems->uhr_cap_len,
-						    link_sta);
+						    true, link_sta);
 
 		bss_conf->uhr_support = link_sta->pub->uhr_cap.has_uhr;
 
diff --git a/net/mac80211/uhr.c b/net/mac80211/uhr.c
index ca3b471b7981..80e02f5ccd88 100644
--- a/net/mac80211/uhr.c
+++ b/net/mac80211/uhr.c
@@ -11,10 +11,12 @@ void
 ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_uhr_cap *uhr_cap,
-				    u8 uhr_cap_len,
+				    bool from_ap,
 				    struct link_sta_info *link_sta)
 {
 	struct ieee80211_sta_uhr_cap *sta_uhr_cap = &link_sta->pub->uhr_cap;
+	const struct ieee80211_uhr_cap_dbe *dbe;
+	int idx = 0;
 
 	memset(sta_uhr_cap, 0, sizeof(*sta_uhr_cap));
 
@@ -24,4 +26,64 @@ ieee80211_uhr_cap_ie_to_sta_uhr_cap(struct ieee80211_sub_if_data *sdata,
 	sta_uhr_cap->has_uhr = true;
 	sta_uhr_cap->mac = uhr_cap->mac;
 	sta_uhr_cap->phy = uhr_cap->phy;
+
+	if (!from_ap)
+		return;
+
+	dbe = ieee80211_uhr_dbe_cap(uhr_cap);
+	if (!dbe)
+		return;
+
+	/* must have EHT as well, EHT function must be called first */
+	if (WARN_ON(!link_sta->pub->eht_cap.has_eht))
+		return;
+
+	if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_160_PRES) {
+		const struct ieee80211_uhr_cap_dbe_bwcap *bw = &dbe->bwcap[idx++];
+		u8 *phy_cap = link_sta->pub->eht_cap.eht_cap_elem.phy_cap_info;
+
+		link_sta->pub->eht_cap.eht_mcs_nss_supp.bw._160 = bw->eht_mcs_map;
+		link_sta->pub->he_cap.he_cap_elem.phy_cap_info[0] |=
+			IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+
+		phy_cap[1] =
+			u8_replace_bits(phy_cap[1],
+					u8_get_bits(bw->cap,
+						    IEEE80211_UHR_MAC_CAP_DBE_CAP_BEAMFORMEE_SS),
+					IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK);
+		phy_cap[2] =
+			u8_replace_bits(phy_cap[2],
+					u8_get_bits(bw->cap,
+						    IEEE80211_UHR_MAC_CAP_DBE_CAP_NUM_SND_DIMS),
+					IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_160MHZ_MASK);
+		if (bw->cap & IEEE80211_UHR_MAC_CAP_DBE_CAP_NON_OFDMA_UL_MUMIMO)
+			phy_cap[7] |= IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_160MHZ;
+		if (bw->cap & IEEE80211_UHR_MAC_CAP_DBE_CAP_MU_BEAMFORMER)
+			phy_cap[7] |= IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_160MHZ;
+	}
+
+	if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_320_PRES) {
+		const struct ieee80211_uhr_cap_dbe_bwcap *bw = &dbe->bwcap[idx++];
+		u8 *phy_cap = link_sta->pub->eht_cap.eht_cap_elem.phy_cap_info;
+		u8 snd_dims = u8_get_bits(bw->cap, IEEE80211_UHR_MAC_CAP_DBE_CAP_NUM_SND_DIMS);
+
+		link_sta->pub->eht_cap.eht_mcs_nss_supp.bw._320 = bw->eht_mcs_map;
+		phy_cap[0] |= IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
+
+		phy_cap[1] =
+			u8_replace_bits(phy_cap[1],
+					u8_get_bits(bw->cap,
+						    IEEE80211_UHR_MAC_CAP_DBE_CAP_BEAMFORMEE_SS),
+					IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
+		phy_cap[2] =
+			u8_replace_bits(phy_cap[2], snd_dims,
+					IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK);
+		phy_cap[3] =
+			u8_replace_bits(phy_cap[3], snd_dims >> 2,
+					IEEE80211_EHT_PHY_CAP3_SOUNDING_DIM_320MHZ_MASK);
+		if (bw->cap & IEEE80211_UHR_MAC_CAP_DBE_CAP_NON_OFDMA_UL_MUMIMO)
+			phy_cap[7] |= IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ;
+		if (bw->cap & IEEE80211_UHR_MAC_CAP_DBE_CAP_MU_BEAMFORMER)
+			phy_cap[7] |= IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ;
+	}
 }
-- 
2.56.0

