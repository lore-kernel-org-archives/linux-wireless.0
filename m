Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB71518148
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898617; cv=none; b=JsQ3niwdipTCu6M8XHUJNnbxsqF9QJ6XYlwIsvvte2zfmO2o+arvgjISc2PlIInlO0T813pZYt9m6ExDeQAjhtLuVXW/PFHyjXtZKeeKqaisulyZakN1sRV5RdKFTyctZjypdbtseCUvk/kE399s0b1G7Q0LmdOmdv1uV93g/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898617; c=relaxed/simple;
	bh=dG3MnWrRLUvPIg9Y2YejY9Nua4wjqCUzC/ZSA6p7nd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4sb6N2OkRXlVjtstyyks5XY6RuLjgA4d/JouPLzpUmy4NHwy7m1L5xJrdNxH+cgcvTuMGw7HkKnndM9Y6bNYq1pOpIQ/08FXhk09QeNGV4/vWqPkaN5MQxKDjxWDaYNdvLT2XpKukLehZhsdYpW5b/73wgmgAJ4UIqVjgEhqbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Iz0/LLDH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Iz0/LLDH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Gije/jzJW8GWKaNwX4xM3SS45KhNIwjfWmPyXjLuSgE=;
	t=1791898615; x=1793108215; b=Iz0/LLDHzimjx4NvBTh6uQIWclYCHxNGh7DTgK7bjTEGIeS
	zw7IQtR6dw8q0Vk/If2NcwxYmafA+TVaRcdYaFVRg/ue/2hcu7b4Hb2d0TKwGxGh9cbcSSQs9mmZV
	Q1v1fKz9lLPOIdLUawHnj9i8i5VpgmTHi7OtpCA0D4PneS96oZmkAlUYbI4Yvo0yI3ELlg4QD9wc+
	ZF/D0s/ZASoCWij/1ERe6Glp6eaepSxpEYnZzyyoad8HyUZ9cHyOsII3MjNbeHyInRZiSRJ1g2rhO
	TXe1UqiVNbgnFbbuL9OV7zaBDcKuUy9sVa0sscveaptoNdTrCJKq2weRhIJRBGWA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgR-0000000HRBK-06Wx;
	Tue, 13 Oct 2026 15:36:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 05/10] wifi: mac80211: mlme: refactor ieee80211_config_bw() output
Date: Tue, 13 Oct 2026 15:25:17 +0200
Message-ID: <20261013153640.ac8685b8a102.I3861b5884c0fbf4f81f4abff796c817fde19f5d7@changeid>
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

Move the extra output data (currently only 'changed') to a
new struct so we can add more data in the future for UHR.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eebdd8a12f52..bd9844f2d075 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1644,9 +1644,14 @@ static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
+struct ieee80211_config_bw_out {
+	u64 changed;
+};
+
 static int ieee80211_config_bw(struct ieee80211_link_data *link,
 			       struct ieee802_11_elems *elems,
-			       bool update, u64 *changed, u16 stype)
+			       bool update, u16 stype,
+			       struct ieee80211_config_bw_out *out)
 {
 	struct ieee80211_channel *channel = link->conf->chanreq.oper.chan;
 	struct cfg80211_chan_def ap_chandef;
@@ -1669,6 +1674,8 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	u16 ht_opmode;
 	int ret;
 
+	memset(out, 0, sizeof(*out));
+
 	switch (stype) {
 	case IEEE80211_STYPE_BEACON:
 		frame = "beacon";
@@ -1720,7 +1727,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	if (elems->ht_operation) {
 		ht_opmode = le16_to_cpu(elems->ht_operation->operation_mode);
 		if (link->conf->ht_operation_mode != ht_opmode) {
-			*changed |= BSS_CHANGED_HT;
+			out->changed |= BSS_CHANGED_HT;
 			link->conf->ht_operation_mode = ht_opmode;
 		}
 	}
@@ -1744,7 +1751,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 					&chanreq.oper);
 		if (memcmp(&link->conf->tpe, &elems->tpe, sizeof(elems->tpe))) {
 			link->conf->tpe = elems->tpe;
-			*changed |= BSS_CHANGED_TPE;
+			out->changed |= BSS_CHANGED_TPE;
 		}
 	}
 
@@ -1787,7 +1794,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 		if (memcmp(&params, &link->conf->npca, sizeof(params)) ||
 		    !update) {
 			link->conf->npca = params;
-			*changed |= BSS_CHANGED_NPCA;
+			out->changed |= BSS_CHANGED_NPCA;
 		}
 	}
 
@@ -1833,7 +1840,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	 * less common and wouldn't completely prevent using the AP.
 	 */
 
-	ret = ieee80211_link_change_chanreq(link, &chanreq, changed);
+	ret = ieee80211_link_change_chanreq(link, &chanreq, &out->changed);
 	if (ret) {
 		sdata_info(sdata,
 			   "AP %pM changed bandwidth in %s to incompatible one - disconnect\n",
@@ -1857,7 +1864,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	if (chanreq.oper.npca_chan && chanctx_conf->def.npca_chan &&
 	    !link->conf->npca.enabled && !sdata->vif.cfg.assoc) {
 		link->conf->npca.enabled = true;
-		*changed |= BSS_CHANGED_NPCA;
+		out->changed |= BSS_CHANGED_NPCA;
 	}
 
 	return 0;
@@ -5937,6 +5944,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee80211_config_bw_out config_bw_out;
 	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
@@ -6156,13 +6164,15 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	/* check/update if AP changed anything in assoc response vs. scan */
 	if (ieee80211_config_bw(link, elems,
 				link_id == assoc_data->assoc_link_id,
-				changed,
 				le16_to_cpu(mgmt->frame_control) &
-					IEEE80211_FCTL_STYPE)) {
+					IEEE80211_FCTL_STYPE,
+				&config_bw_out)) {
 		ret = false;
 		goto out;
 	}
 
+	*changed |= config_bw_out.changed;
+
 	if (WARN_ON(!link->conf->chanreq.oper.chan)) {
 		ret = false;
 		goto out;
@@ -8195,6 +8205,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	size_t baselen;
 	struct ieee802_11_elems *elems;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_config_bw_out config_bw_out;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
@@ -8517,8 +8528,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	changed |= ieee80211_recalc_twt_req(sdata, sband, link, link_sta, elems);
 
-	if (ieee80211_config_bw(link, elems, true, &changed,
-				IEEE80211_STYPE_BEACON)) {
+	if (ieee80211_config_bw(link, elems, true, IEEE80211_STYPE_BEACON,
+				&config_bw_out)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
@@ -8529,6 +8540,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		goto free;
 	}
 
+	changed |= config_bw_out.changed;
+
 	if (elems->opmode_notif)
 		ieee80211_vht_handle_opmode(sdata, link_sta,
 					    *elems->opmode_notif,
-- 
2.56.0

