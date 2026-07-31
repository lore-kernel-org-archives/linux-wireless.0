Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1730C33D6F0
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505379; cv=none; b=SUrbLN/RBQ+n1zS857wOwl5+N1L75O2hN62kRvDf7mVm5QWLX/x3Z+6ouIheW/Za5Ep/2J66hvt/FAXrwcfROHpcv7S0lU43Sbui6V8FIJBk4v0C01eo7TojHPpduBFbj2uwLmVRmOfPfjQw661qFVngPi+wez3uElz3QTb8EKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505379; c=relaxed/simple;
	bh=erS8pyQtPYO8AxujzIlSavu30qtjBkgQZ6WDbC7Bvbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+6AZDsa9EPpC0GTCJvpmLOTFI0tcFQ49D1H5ILyEK/9HmmIaEy/COBHdFne19nwDSDQGvPonw5mPOc/o7hx2fg/dBXYQmfw57KXuO4Bi49yy/ZRliRi3KYgFR0x0zOG0fkIKiaWQmCwi5jelA9wsePgleBCwzUUuY7PNxfv+5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fKcbYVLR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fKcbYVLR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=V84WcufziRcybLCjOcVsll7Zl/kNp9hcCa6emON2vHc=;
	t=1785505378; x=1786714978; b=fKcbYVLR0OHj5IB3c5Yp0OytD8on1HR3lf8rx4eoNvyeUvp
	wRBZQmYhluc6qTHybk/N/XDB5IP7emq9IU061WcrpvFkeH1/fvBjtQbiYS67ArWBzH+ZZhrbnJeVS
	SxeKCOH9sypvONuyps1PKO3Sp/uWNv6Dy16XzSBxEpY6sbB7bsv3bZtbvH1WUhWzFrsq6E2Z8+z1K
	lxrzXzoVl6If1efvBU4sJz3GB7J5bxydVKttsljgZy2CMZni7kesomwog03hl15OAwaUTDS+DeS8q
	X7zIE4dcjQ2I/1P49Ufbkf7UWaCqLMTCSi7T4/hGcxFq8xTtrBTaJjUrqzvfVE7A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpnVm-000000048ua-3dQA;
	Fri, 31 Jul 2026 15:42:55 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 3/5] wifi: mac80211: add helpers to parse/generate CIP Capabilities
Date: Fri, 31 Jul 2026 15:40:09 +0200
Message-ID: <20260731154006.ad3cb5d32dc5.Ia3ea929dd6381cf8b04e3dd0c38e709e335113c2@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The Control Integrity Protocol (CIP) Capabilities need to be
added to and parsed from the association request and response.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 include/linux/ieee80211.h  | 13 +++++++++++++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/parse.c       |  4 ++++
 net/mac80211/util.c        | 19 +++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 26e674038865..16d78fd61c22 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1828,6 +1828,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_BANDWIDTH_INDICATION = 135,
 	WLAN_EID_EXT_KNOWN_STA_IDENTIFCATION = 136,
 	WLAN_EID_EXT_NON_AP_STA_REG_CON = 137,
+	WLAN_EID_EXT_CIP_CAPA = 150,
 	WLAN_EID_EXT_UHR_OPER = 151,
 	WLAN_EID_EXT_UHR_CAPA = 152,
 	WLAN_EID_EXT_MACP = 153,
@@ -2900,4 +2901,16 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 		     __ieee80211_check_tim(tim, tim_len, aid);
 }
 
+/* The MIC padding subfield in the CIP capabilities */
+#define WLAN_CIP_CAPA_MIC_PADDING	0x0F
+
+/**
+ * struct ieee80211_cip_cap - CIP Capabilities element
+ *
+ * @v: The value of the Control Integrity Protocol Capability element
+ */
+struct ieee80211_cip_cap {
+	u8 v;
+} __packed;
+
 #endif /* LINUX_IEEE80211_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a1ef88fe846d..c6e6cb9d90a1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1870,6 +1870,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_ttlm_elem *ttlm[IEEE80211_TTLM_MAX_CNT];
 	const struct ieee80211_uhr_cap *uhr_cap;
 	const struct ieee80211_uhr_operation *uhr_operation;
+	const struct ieee80211_cip_cap *cip_cap;
 
 	/* not the order in the psd values is per element, not per chandef */
 	struct ieee80211_parsed_tpe tpe;
@@ -2775,6 +2776,8 @@ int ieee80211_put_uhr_cap(struct sk_buff *skb,
 			  const struct ieee80211_supported_band *sband);
 void ieee80211_put_reg_conn(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb);
+int ieee80211_put_cip_cap(struct sk_buff *skb,
+			  struct ieee80211_sub_if_data *sdata);
 
 /* channel management */
 bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index cb2be167cde7..3b66ca7d7a5c 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -205,6 +205,10 @@ ieee80211_parse_extension_element(u32 *crc,
 			elems->ttlm_num++;
 		}
 		break;
+	case WLAN_EID_EXT_CIP_CAPA:
+		if (len >= sizeof(*elems->cip_cap))
+			elems->cip_cap = data;
+		break;
 	case WLAN_EID_EXT_UHR_OPER:
 		if (params->mode < IEEE80211_CONN_MODE_UHR)
 			break;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a96078a6bfa2..8303f624b7f6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4680,6 +4680,25 @@ int ieee80211_put_uhr_cap(struct sk_buff *skb,
 	return 0;
 }
 
+int ieee80211_put_cip_cap(struct sk_buff *skb,
+			  struct ieee80211_sub_if_data *sdata)
+{
+	const struct wiphy_iftype_ext_capab *ift_ext_capa =
+		cfg80211_get_iftype_ext_capa(sdata->local->hw.wiphy,
+					     ieee80211_vif_type_p2p(&sdata->vif));
+	u8 cip_capabilities = ift_ext_capa ? ift_ext_capa->cip_capabilities : 0;
+
+	if (skb_tailroom(skb) < 4)
+		return -ENOBUFS;
+
+	skb_put_u8(skb, WLAN_EID_EXTENSION);
+	skb_put_u8(skb, 2);
+	skb_put_u8(skb, WLAN_EID_EXT_CIP_CAPA);
+	skb_put_u8(skb, cip_capabilities);
+
+	return 0;
+}
+
 const char *ieee80211_conn_mode_str(enum ieee80211_conn_mode mode)
 {
 	static const char * const modes[] = {
-- 
2.55.0

