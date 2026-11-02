Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657438;
	b=Pqg6F2ngXbXrCr5gFkC3yOQtIjwE89sZ+KLHhaVzYg+yE06qYLxIwteF7lh2nPSxoO27
	 A/3guk0eZy7OSBrjjS0JOqTSPPycxVuTlmD7APeAhXNZ9SvQWmY7qmu7HNknx99MSj6zk
	 sicmGCO7NI6LeOBfYgleoH99ghalKEVhQ9KR+907Dp75Lt87JXLzi7b98LcRyrzZoNpJs
	 Buh4vwHARxCFGRvO2ayEgEPBI7JXJKwYpguiX0W0y6HFREq0na18PNcmGAWA/41zH6Fz7
	 CruncCcbgmhySfuLvqA4CfKMnugIChcqcR/ZXQm1FZLDa/M5W7nLuTKoQJsS6Zc3hHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657438;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=G9sF6n1JvOBP8pU9dqvE1LpY/nXpuIi8KwQSRByx4g0=;
	b=hpewmJXnofOpMkHKEAa/mlHfIWrPplVGtwl64jNUhYRUVm86SnImhvkaFOF9nxfozTxj
	 aU9jnxMxB6j1HbUyDPA2KBKlSi0xunbxikwHA4cL6yGmGjEtL4zo5CcHNXoJoaIIljLxR
	 MttWJxme/Bas9dJwae5lPKI6COqCpiFiwbofQjrqYtySp86PJKYfRl30cdoffqtLjVoI/
	 xYDm6cDLzv7JHkmfyZQfgIdIbYSslgqrPFp4lbjmCvTWxroz5rXtip1uk6r4KcA/p1u1I
	 d8cLNv9L2wNALcSTwRrtfG1q88wgs/pWIjuzcLEJwChzXLWCObC/8Ev2BRZKXwtyO3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="HRZlpqV/";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD551606D808
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=HRZlpqV/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=G9sF6n1JvOBP8pU9dqvE1LpY/nXpuIi8KwQSRByx4g0=;
	t=1793657437; x=1794867037; b=HRZlpqV/KB/hgVzOQ5XD6gzi8nFMNsra1RmfpYqeafS6y1k
	OQ+CrKopxJtM7RzG4KTp3q8ZqtqaWhIMw3f29q92x2RUgMHPOhgsfXfMVFXP9tgbQHy34iRnxZ7WB
	9FRyZn+jLBQDtgL0gY5OB0AQgS/S1C1l8ClPPrkgOOFgjft6EjPV5czar6OZNvAeDr1ZC2g+/qhbD
	LtdjAjGd0y0pwNwngpBI5/mBgcgC+e07YM5dRCniOviLTxe+oBX9bIIZM2v/q2Sd0tGSJ+HIoY2Qw
	6/K1JmgYCv3pZMvVolCzWuXNCurjhYIjl71FiCJU3MixwmuyTiz+IsgOJ9EgrMzg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ed-000000022rO-0kZG;
	Mon, 02 Nov 2026 23:10:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 5/8] wifi: mac80211: parse SMD BSS Transition Parameters element
Date: Mon,  2 Nov 2026 23:08:25 +0100
Message-ID: <20261102231028.2e53b1ad268e.If340f9b82f7cc02dae09a730d6162436947b3a79@changeid>
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

As previously defined in the header file, this element has a
different layout depending on the action frame it's carried
in, so the 'type' is no longer sufficient. Add a new enum
indicating which 'action_frame' we're parsing to allow for
this, and parse the element accordingly in SMD Transition
preparation and execution responses, in preparation for ST
implementation.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 26 ++++++++++++++++++++++++++
 net/mac80211/parse.c       | 18 ++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eb31691c89d5..7e6e87ccce08 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1916,6 +1916,8 @@ struct ieee802_11_elems {
 	const struct ieee80211_uhr_operation *uhr_operation;
 	const struct ieee80211_cip_cap *cip_cap;
 	const struct ieee80211_uhr_parameters_update *uhr_param_upd;
+	const struct ieee80211_smd_bss_trans_params_prep_resp *smd_prep_resp;
+	const struct ieee80211_smd_bss_trans_params_exec_resp *smd_exec_resp;
 
 	/* not the order in the psd values is per element, not per chandef */
 	struct ieee80211_parsed_tpe tpe;
@@ -2553,6 +2555,26 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, NULL, 7, -1);
 }
 
+/**
+ * enum ieee80211_parse_action_frame - action frame context for element parsing
+ *
+ * Some elements reuse the same element ID for different structures depending
+ * on which action frame they appear in. This selects the action frame the
+ * elements came from so the parser can extract the correct variant.
+ *
+ * @IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED: not one of the action frames that
+ *	need such disambiguation - parse elements normally
+ * @IEEE80211_PARSE_ACTION_FRAME_ST_PREP_RESP: SMD transition preparation
+ *	response
+ * @IEEE80211_PARSE_ACTION_FRAME_ST_EXEC_RESP: SMD transition execution
+ *	response
+ */
+enum ieee80211_parse_action_frame {
+	IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED = 0,
+	IEEE80211_PARSE_ACTION_FRAME_ST_PREP_RESP,
+	IEEE80211_PARSE_ACTION_FRAME_ST_EXEC_RESP,
+};
+
 /**
  * struct ieee80211_elems_parse_params - element parsing parameters
  * @mode: connection mode for parsing
@@ -2572,6 +2594,9 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
  *	(or re-association) response frame if this is given
  * @from_ap: frame is received from an AP (currently used only
  *	for EHT capabilities parsing)
+ * @action_frame: which action frame the elements came from, to
+ *	disambiguate elements that reuse the same element ID across different
+ *	action frames, or %IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED
  */
 struct ieee80211_elems_parse_params {
 	enum ieee80211_conn_mode mode;
@@ -2583,6 +2608,7 @@ struct ieee80211_elems_parse_params {
 	struct cfg80211_bss *bss;
 	int link_id;
 	bool from_ap;
+	enum ieee80211_parse_action_frame action_frame;
 };
 
 struct ieee802_11_elems *
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 22bba5adef26..c392ecf58b0c 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -236,6 +236,20 @@ ieee80211_parse_extension_element(u32 *crc,
 		elems_parse->uhr_param_upd.start = params->start;
 		elems_parse->uhr_param_upd.len = params->len;
 		break;
+	case WLAN_EID_EXT_BSS_SMD_TRANS_PARAMS:
+		switch (params->action_frame) {
+		case IEEE80211_PARSE_ACTION_FRAME_ST_PREP_RESP:
+			if (ieee80211_smd_prep_resp_size_ok(data, len))
+				elems->smd_prep_resp = data;
+			break;
+		case IEEE80211_PARSE_ACTION_FRAME_ST_EXEC_RESP:
+			if (ieee80211_smd_exec_resp_size_ok(data, len))
+				elems->smd_exec_resp = data;
+			break;
+		default:
+			break;
+		}
+		break;
 	}
 
 	if (crc && calc_crc)
@@ -351,6 +365,10 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 		break;
 	}
 
+	WARN(params->type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION) &&
+	     params->action_frame != IEEE80211_PARSE_ACTION_FRAME_UNSPECIFIED,
+	     "action frame type specified for non-action frame\n");
+
 	for_each_element(elem, params->start, params->len) {
 		const struct element *subelem;
 		u8 elem_parse_failed;
-- 
2.56.0

