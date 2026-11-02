Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655023;
	b=piQ0zVzjfbMVoTef6vp1w16KYvgD426qZUzSfHpfLkJosvOR2IBMZp3qlJ2MKavzDwhz
	 DBHBB8L2/2vgTWN54YSqnPsDBOgZq2SiMXzXWQQFX7YzKt1HTBg4BVVzwogGMlkSyXS0r
	 ZN8HVZjc1GZseYzvwlle3e2BEjewZsJuJ6tEV1aVq9ggKbdI+cz9Uz068F5qFm82JANny
	 lVqWo+1uTFKn8BkFEcTOE2sSXK/FYcXn3Zx/dmOrqnYPt83KXZqnGOJn6QEBJhblBoFAh
	 /aEsxb+N+EAVR9YSx/r+UQfjN1TRDo0MXXJtQve8dfxMwjhTb2/x58jY1FQQZ1S2wPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655023;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RLhqs9yp5mDUzdJf5eeLzoYD5Jnjvn6gvSvQbUDEHVo=;
	b=0/ueAO8KMJs/SSsKfSivoWeWjPHwicGWTD10LoMr2NVcdrDx4KevYouPciRvfgvdzAka
	 ZXzHxSo6zKzpS3cka7SqrFHCflFOZw1HHV+A+ZnraWiyM/SUl9lLZ4Igo8L38qtSostS4
	 vSyov2hLnnoijS6FtZo4huVV/2K7Tcq4ybJeR+Q9r1JA2/U2eeInnsHcs/DAPxHO9cm1z
	 zMocSLH2ASbSy/69rCCUGA+b2mV/ZXQNF3XGIuRQY+uCAr76zcmmyQMaoBWu/Pq3QHLLy
	 dU6hidorjEHczF0OoxzGQtc4tsHZDx0N5qv56TBuxwsNKvJ1WyBufc7uI/L4qp74akw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=XVWhWkmu;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610DC606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=XVWhWkmu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RLhqs9yp5mDUzdJf5eeLzoYD5Jnjvn6gvSvQbUDEHVo=;
	t=1793655023; x=1794864623; b=XVWhWkmugdBa02xsf0HUz9cKfCdg2Bb7q46S8ubEdOhKr/A
	RenCMdGs+E6q1lA6n76VAdpOUol8mJfv06D3y92goejwlV91Pvs6nYzGHT1mwod3NZkLTG7Jakfal
	j+qehbe5i/hogbiJHAYMhZkX5Xt05v8oyh2gMG6O0gVSaPG8MSSq8hg8YT9B7UE8O0Zu3BlrMywi8
	gM6UZdY+bKGYDQchKF5CKs5tYYsDX5k5cFCh2hazwOdUTew+ycXWyl4zxJNSEkeNoUU65p72wVsEr
	T9ai5eXCwfEw7W7Rxgs60WpAk4Ak9HS4Nl8Z7kwxSTZaOU+CU86p4oJS8R2yo5yg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzbf-00000001zui-3ydm;
	Mon, 02 Nov 2026 22:30:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 1/4] wifi: mac80211: check for AID assignment issues
Date: Mon,  2 Nov 2026 22:26:28 +0100
Message-ID: <20261102223017.8c38819c98db.Ic8451a2f46dd4250ce7b24e5827a516280c3ef7d@changeid>
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

For UHR AIDs 56-63 are reserved, for EHT 2007, and for
any multi-BSSID the lower values whose bits are used
for the multicast indications. Check for these issues,
log a message, and disconnect in strict mode.

Since this isn't affected by the connection mode, it
requires tracking the AP mode while parsing elements.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 28 ++++++++++++++++++++++++++++
 net/mac80211/parse.c       | 20 ++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..6fd7f29349ab 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1851,6 +1851,9 @@ struct ieee802_11_elems {
 	u8 frame_type;
 	bool from_ap;
 
+	/* the AP mode, not restricted to the parse mode */
+	enum ieee80211_conn_mode unrestricted_ap_mode;
+
 	/* pointers to IEs */
 	const struct ieee80211_tdls_lnkie *lnk_id;
 	const struct ieee80211_ch_switch_timing *ch_sw_timing;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8eda8154ba3d..d918f7ca36e7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6175,6 +6175,34 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 		goto out;
 	}
 
+	/* AIDs 56-63 are reserved in UHR APs (Critical Update Type/Counter) */
+	if (elems->unrestricted_ap_mode >= IEEE80211_CONN_MODE_UHR &&
+	    sdata->vif.cfg.aid >= 56 && sdata->vif.cfg.aid <= 63) {
+		link_info(link, "UHR AP %pM assigned AID %d, expect PS issues\n",
+			  link->u.mgd.bssid, sdata->vif.cfg.aid);
+		if (ieee80211_hw_check(&sdata->local->hw, STRICT)) {
+			ret = false;
+			goto out;
+		}
+	} else if (elems->unrestricted_ap_mode >= IEEE80211_CONN_MODE_EHT &&
+		   sdata->vif.cfg.aid == 2007) {
+		link_info(link, "EHT AP %pM assigned AID 2007, expect trigger issues\n",
+			  link->u.mgd.bssid);
+		if (ieee80211_hw_check(&sdata->local->hw, STRICT)) {
+			ret = false;
+			goto out;
+		}
+	} else if (sdata->vif.cfg.aid &&
+		   sdata->vif.cfg.aid < (1 << cbss->max_bssid_indicator)) {
+		link_info(link, "multi-BSSID AP %pM with MaxBSSID %d assigned AID %d, expect PS issues\n",
+			  link->u.mgd.bssid, cbss->max_bssid_indicator,
+			  sdata->vif.cfg.aid);
+		if (ieee80211_hw_check(&sdata->local->hw, STRICT)) {
+			ret = false;
+			goto out;
+		}
+	}
+
 	/* check/update if AP changed anything in assoc response vs. scan */
 	if (ieee80211_config_bw(link, elems,
 				link_id == assoc_data->assoc_link_id,
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 22bba5adef26..debc0dcd3bdf 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -69,6 +69,12 @@ struct ieee80211_elems_parse {
 	u8 scratch[] __counted_by(scratch_len);
 };
 
+static void ieee80211_update_unr_ap_mode(struct ieee802_11_elems *elems,
+					 enum ieee80211_conn_mode mode)
+{
+	elems->unrestricted_ap_mode = max(mode, elems->unrestricted_ap_mode);
+}
+
 static void
 ieee80211_parse_extension_element(u32 *crc,
 				  const struct element *elem,
@@ -94,6 +100,7 @@ ieee80211_parse_extension_element(u32 *crc,
 			elems->mu_edca_param_set = data;
 		break;
 	case WLAN_EID_EXT_HE_CAPABILITY:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_HE);
 		if (params->mode < IEEE80211_CONN_MODE_HE)
 			break;
 		if (ieee80211_he_capa_size_ok(data, len)) {
@@ -102,6 +109,7 @@ ieee80211_parse_extension_element(u32 *crc,
 		}
 		break;
 	case WLAN_EID_EXT_HE_OPERATION:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_HE);
 		if (params->mode < IEEE80211_CONN_MODE_HE)
 			break;
 		calc_crc = true;
@@ -137,6 +145,7 @@ ieee80211_parse_extension_element(u32 *crc,
 			elems->he_6ghz_capa = data;
 		break;
 	case WLAN_EID_EXT_EHT_CAPABILITY:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_EHT);
 		if (params->mode < IEEE80211_CONN_MODE_EHT)
 			break;
 		if (ieee80211_eht_capa_size_ok(elems->he_cap,
@@ -147,6 +156,7 @@ ieee80211_parse_extension_element(u32 *crc,
 		}
 		break;
 	case WLAN_EID_EXT_EHT_OPERATION:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_EHT);
 		if (params->mode < IEEE80211_CONN_MODE_EHT)
 			break;
 		if (ieee80211_eht_oper_size_ok(data, len))
@@ -211,6 +221,7 @@ ieee80211_parse_extension_element(u32 *crc,
 			elems->cip_cap = data;
 		break;
 	case WLAN_EID_EXT_UHR_OPER:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_UHR);
 		if (params->mode < IEEE80211_CONN_MODE_UHR)
 			break;
 		calc_crc = true;
@@ -220,6 +231,7 @@ ieee80211_parse_extension_element(u32 *crc,
 		}
 		break;
 	case WLAN_EID_EXT_UHR_CAPA:
+		ieee80211_update_unr_ap_mode(elems, IEEE80211_CONN_MODE_UHR);
 		if (params->mode < IEEE80211_CONN_MODE_UHR)
 			break;
 		calc_crc = true;
@@ -507,6 +519,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 			elems->ext_supp_rates_len = elen;
 			break;
 		case WLAN_EID_HT_CAPABILITY:
+			ieee80211_update_unr_ap_mode(elems,
+						     IEEE80211_CONN_MODE_HT);
 			if (params->mode < IEEE80211_CONN_MODE_HT)
 				break;
 			if (elen >= sizeof(struct ieee80211_ht_cap))
@@ -516,6 +530,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			break;
 		case WLAN_EID_HT_OPERATION:
+			ieee80211_update_unr_ap_mode(elems,
+						     IEEE80211_CONN_MODE_HT);
 			if (params->mode < IEEE80211_CONN_MODE_HT)
 				break;
 			if (elen >= sizeof(struct ieee80211_ht_operation))
@@ -525,6 +541,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			break;
 		case WLAN_EID_VHT_CAPABILITY:
+			ieee80211_update_unr_ap_mode(elems,
+						     IEEE80211_CONN_MODE_VHT);
 			if (params->mode < IEEE80211_CONN_MODE_VHT)
 				break;
 			if (elen >= sizeof(struct ieee80211_vht_cap))
@@ -534,6 +552,8 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			break;
 		case WLAN_EID_VHT_OPERATION:
+			ieee80211_update_unr_ap_mode(elems,
+						     IEEE80211_CONN_MODE_VHT);
 			if (params->mode < IEEE80211_CONN_MODE_VHT)
 				break;
 			if (elen >= sizeof(struct ieee80211_vht_operation)) {
-- 
2.56.0

