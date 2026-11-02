Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657439;
	b=3Nf3LJdUej+pA1CDDMf5+WouTygIZrJRBNSf4wj1xizeyde8UfiRI5iXTwqqqAhVjOtB
	 w7mKN2l4A2Ar1INE0o057pUrmQKNcF1ZwM6p55VgcIYe3kf/9XButjdXAEi3X3EgmSBV1
	 HL1dF0QA7xoKu82K1ciM9GH9FhiHRzS3/Qt/Jz8Ueo2OdKWYUL/SXLBm0Gt09rADq0uWM
	 E+qBZdooQTtb2TZOmQWfNolduM84KrtwfJ2RnSDsmVajtIFVY8gpoUeuEjxHX8voLB92L
	 0wtLurS1m/Ab16B0DDs3otLVjL1wSZoGXRvauZu458XTywD22MQJFNVKzJe6xsZz5jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657439;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SfZrUiLf62TRGe7oDk9xAaCX4FOcc1sF1U/BxBj157Q=;
	b=uKCtC4w9Ee3pGriWuo0UST6WtCdEOXrflhGGlWccZOGQkmCn1A4YdQX2JKLq3BPx5PwF
	 HNWvJwp/cdONcukiBA6ZFx5Ftw0qdtqfKWPOZo1e13+6uQzCKFk5xZ+3YhfFkG6eppP5L
	 ZV+vffNup0YaN0/t4ZDVn5uLmBLvkaLC22RP/maT1NXfWgpUI4Fs28aytylvb6zvjCe1X
	 +sNFcA+nBAwYTGx2x/KqROeq8f2bueMzvzKvt9zGxShi9BguZW3CT98s64QrBjUpVoT4D
	 DjLWRkFgD/ay6HopmPc1V/+i3i2F0OQEpo9bZisyIM3fdBOr17hDNaBJDlt2a/B8pUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ep1u79WD;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B55606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ep1u79WD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SfZrUiLf62TRGe7oDk9xAaCX4FOcc1sF1U/BxBj157Q=;
	t=1793657439; x=1794867039; b=ep1u79WD9qp7t9sSerOw1/hwu2AMjjgH3Buc1b0+UwdE66t
	R5ooeWr+t2omzZcCl6XG12EbWtIsaWZL7XxRzbg0WjSsldUf5GE0kjnBl+abuYk5R1o7Lx7NuRvn8
	oAgBbOGY3k+V0f1XlZuRm0OguT2ZcNGurnp6NntCry00UTPKPJjEjXVZ1TIJMsbr9WlsLzMjNnx8G
	6S6XDvSZmJIi+CK8uWpl2dfTxqG3qG2kVuVCFx7x5c4sdke9kVaTBvhfTH61kfZir39+CrEcjUA/h
	9LHq7qpM32IBzESi2byYhvJ1bv1EYnfY1DGINwO+BnAgdJ8kAX8CgQKrXUA4raXw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ee-000000022rO-2Nlf;
	Mon, 02 Nov 2026 23:10:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 7/8] wifi: mac80211: pass assoc_data to link config
Date: Mon,  2 Nov 2026 23:08:27 +0100
Message-ID: <20261102231028.0a464da06900.If6be234003d024866c2c55872e7de97df19851a0@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102221028.1124852-10-johannes@sipsolutions.net>
References: <20261102221028.1124852-10-johannes@sipsolutions.net>
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

This function is already used for association and
EHT link reconfiguration, but auto-detects which
of the two. Pass the assoc_data explicitly to be
able to use it for SMD transition as well later.

Also wrap most of the (many) arguments in a struct,
expose the function for SMD Transition and add an
argument to skip the bandwidth check, which cannot
be done during SMD Transition.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 57 +++++++++++++++++++++++++++------------------
 net/mac80211/mlme.h | 15 ++++++++++++
 2 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bb2063f18b4e..8081f0547434 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1678,8 +1678,6 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	u16 ht_opmode;
 	int ret;
 
-	memset(out, 0, sizeof(*out));
-
 	switch (stype) {
 	case IEEE80211_STYPE_BEACON:
 		frame = "beacon";
@@ -5941,33 +5939,32 @@ static void ieee80211_epcs_teardown(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
-					struct link_sta_info *link_sta,
-					struct cfg80211_bss *cbss,
-					struct ieee80211_mgmt *mgmt,
-					const u8 *elem_start,
-					unsigned int elem_len,
-					u64 *changed)
+bool ieee80211_assoc_config_link(struct ieee80211_mgd_assoc_data *assoc_data,
+				 struct ieee80211_link_data *link,
+				 const struct ieee80211_assoc_config_link_params *params,
+				 u64 *changed)
 {
+	struct link_sta_info *link_sta = params->link_sta;
+	struct cfg80211_bss *cbss = params->cbss;
+	struct ieee80211_mgmt *mgmt = params->mgmt;
 	struct ieee80211_sub_if_data *sdata = link->sdata;
-	struct ieee80211_mgd_assoc_data *assoc_data =
-		sdata->u.mgd.assoc_data ?: sdata->u.mgd.reconf.add_links_data;
 	struct ieee80211_bss_conf *bss_conf = link->conf;
 	struct ieee80211_local *local = sdata->local;
 	unsigned int link_id = link->link_id;
 	struct ieee80211_elems_parse_params parse_params = {
 		.mode = link->u.mgd.conn.mode,
-		.start = elem_start,
-		.len = elem_len,
+		.start = params->elem_start,
+		.len = params->elem_len,
 		.link_id = link_id == assoc_data->assoc_link_id ? -1 : link_id,
 		.from_ap = true,
 		.type = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_TYPE,
+		.action_frame = params->action_frame,
 	};
 	bool is_5ghz = cbss->channel->band == NL80211_BAND_5GHZ;
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
-	struct ieee80211_config_bw_out config_bw_out;
+	struct ieee80211_config_bw_out config_bw_out = {};
 	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
@@ -6185,7 +6182,8 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	}
 
 	/* check/update if AP changed anything in assoc response vs. scan */
-	if (ieee80211_config_bw(link, elems,
+	if (!params->skip_bw_check &&
+	    ieee80211_config_bw(link, elems,
 				link_id == assoc_data->assoc_link_id,
 				le16_to_cpu(mgmt->frame_control) &
 					IEEE80211_FCTL_STYPE,
@@ -7215,6 +7213,13 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
+		struct ieee80211_assoc_config_link_params params = {
+			.cbss = cbss,
+			.mgmt = mgmt,
+			.action_frame = IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED,
+			.elem_start = elem_start,
+			.elem_len = elem_len,
+		};
 		struct ieee80211_link_data *link;
 		struct link_sta_info *link_sta;
 
@@ -7258,9 +7263,9 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		if (err)
 			goto out_err;
 
-		if (!ieee80211_assoc_config_link(link, link_sta,
-						 assoc_data->link[link_id].bss,
-						 mgmt, elem_start, elem_len,
+		params.link_sta = link_sta;
+		if (!ieee80211_assoc_config_link(sdata->u.mgd.assoc_data,
+						 link, &params,
 						 &changed[link_id]))
 			goto out_err;
 
@@ -8234,7 +8239,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	size_t baselen;
 	struct ieee802_11_elems *elems;
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_config_bw_out config_bw_out;
+	struct ieee80211_config_bw_out config_bw_out = {};
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
@@ -11201,6 +11206,13 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 	link_mask = 0;
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct cfg80211_bss *cbss = add_links_data->link[link_id].bss;
+		struct ieee80211_assoc_config_link_params params = {
+			.cbss = cbss,
+			.mgmt = mgmt,
+			.action_frame = IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED,
+			.elem_start = pos,
+			.elem_len = len,
+		};
 		struct ieee80211_link_data *link;
 		struct link_sta_info *link_sta;
 		u64 changed = 0;
@@ -11252,10 +11264,9 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 						 add_links_data->link[link_id].bss))
 			goto disconnect;
 
-		if (!ieee80211_assoc_config_link(link, link_sta,
-						 add_links_data->link[link_id].bss,
-						 mgmt, pos, len,
-						 &changed))
+		params.link_sta = link_sta;
+		if (!ieee80211_assoc_config_link(sdata->u.mgd.reconf.add_links_data,
+						 link, &params, &changed))
 			goto disconnect;
 
 		/* The AP MLD indicated success for this link, but the station
diff --git a/net/mac80211/mlme.h b/net/mac80211/mlme.h
index 8bf93212d9c9..e867ea69d702 100644
--- a/net/mac80211/mlme.h
+++ b/net/mac80211/mlme.h
@@ -32,6 +32,21 @@ void ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 				      struct cfg80211_assoc_request *req,
 				      bool wmm_used, int link_id,
 				      struct ieee80211_conn_settings *conn);
+
+struct ieee80211_assoc_config_link_params {
+	struct link_sta_info *link_sta;
+	struct cfg80211_bss *cbss;
+	struct ieee80211_mgmt *mgmt;
+	enum ieee80211_parse_action_frame action_frame;
+	const u8 *elem_start;
+	unsigned int elem_len;
+	bool skip_bw_check;
+};
+
+bool ieee80211_assoc_config_link(struct ieee80211_mgd_assoc_data *assoc_data,
+				 struct ieee80211_link_data *link,
+				 const struct ieee80211_assoc_config_link_params *params,
+				 u64 *changed);
 int ieee80211_calc_channel(struct ieee80211_sub_if_data *sdata,
 			   struct ieee80211_link_data *link,
 			   struct link_sta_info *link_sta, int link_id,
-- 
2.56.0

