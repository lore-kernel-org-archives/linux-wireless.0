Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A24963B3;
	Mon, 21 Sep 2026 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994480; cv=none; b=O1U+kMMjh82VK6edhPYrECzNews+dzY8VhSM5TDk1EHt79mNPQ2MDgihXOjHfWGn3Owj59TTrDJOEWjVsK/FPJ1soGCxpVYwsWEOF7DqSWVNwRmBDs7jEIFhcb3mZ8SSkp5T/lMlPeD867PtYT0uIHfNw3SxS0X2x2vhnMt+W3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994480; c=relaxed/simple;
	bh=1N4yNqzc3HDX0ay9qRAYO99byOUlLkTZYU7q6+owNGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzdX/BHHn4dsZMvZox9nloQw0HlhJvUOd/Wc2Fvn/7bDh8iN20xI+rphruU/RaUBHBEuvs9f+VeekWyAktGn7llUwGgNx7gj2SxAt9MVpVsrl2uwVntBrd5XyY2UVe/JEz4auDYCU6VGieaaXKX7mQ8dSsMuXbg+Wg1BIz94X/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=B1z/WSk0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="B1z/WSk0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sw5CnvN8+88wAIgd9JsdaXXB+CcEUIe6bSnkzMUo2sE=;
	t=1789994479; x=1791204079; b=B1z/WSk0gi3di1g+d5Yy2SvBazyO+tPl+QdNpqHjJ7ZbZmq
	3l+BZN9Dv+iJGlAvXuIBTEyWoBYvja1tdZpAO5XaR1r+Zrec9H4sSIk7JNuat8CGH2Pb4eVnlH8ib
	rpj+ioARmo+gWO2x1TX2040/IdHN7FIII2T08IkYXAoLilDRssPb9TJRSlPtzjx27SzNsMLdTrL8h
	OiMu4t+iomP8/+wVLiv+hfHIFAg3dsRM/Vbu/ZqnNa3dn3HVzJaFt2MGOUY9cV9i0dLwtJE+ShWG+
	zqb7a5bBJVukIhQiGRRShnBCfQpmGJsBmSt2SNHIVn6hsNpyYpFctfN5Q7tyOKBQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKd-00000005oVO-349z;
	Mon, 21 Sep 2026 14:41:16 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 5/7] wifi: mac80211: add helpers to parse/generate CIP Capabilities
Date: Mon, 21 Sep 2026 14:40:54 +0200
Message-ID: <20260921144048.a3249c0b78ad.Ia3ea929dd6381cf8b04e3dd0c38e709e335113c2@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921124048.4146576-9-benjamin@sipsolutions.net>
References: <20260921124048.4146576-9-benjamin@sipsolutions.net>
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

v3:
- Add new bit defined in REVmf D3.0
---
 include/linux/ieee80211.h  | 22 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/parse.c       |  4 ++++
 net/mac80211/util.c        | 19 +++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7fbc51f873ff..73ac5336a17a 100644
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
@@ -2899,4 +2900,25 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 		     __ieee80211_check_tim(tim, tim_len, aid);
 }
 
+/**
+ * enum ieee80211_cip_cap_fields - CIP Capabilities element fields
+ * @IEEE80211_CIP_CAP_MIC_PADDING: The MIC padding subfield in the CIP
+ *	capabilities
+ * @IEEE80211_CIP_CAP_PROTECTED_CTRL_FRAME_ONLY: The MIC Padding For Protected
+ *	Control Frames Only bit in CIP capabilities
+ */
+enum ieee80211_cip_cap_fields {
+	IEEE80211_CIP_CAP_MIC_PADDING			= 0x0F,
+	IEEE80211_CIP_CAP_PROTECTED_CTRL_FRAME_ONLY	= 0x10,
+};
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
index 9514f01778be..674a4676a972 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1878,6 +1878,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_ttlm_elem *ttlm[IEEE80211_TTLM_MAX_CNT];
 	const struct ieee80211_uhr_cap *uhr_cap;
 	const struct ieee80211_uhr_operation *uhr_operation;
+	const struct ieee80211_cip_cap *cip_cap;
 
 	/* not the order in the psd values is per element, not per chandef */
 	struct ieee80211_parsed_tpe tpe;
@@ -2778,6 +2779,8 @@ int ieee80211_put_uhr_cap(struct sk_buff *skb,
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
index e2b5b2b21c34..c193a75ef06e 100644
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

