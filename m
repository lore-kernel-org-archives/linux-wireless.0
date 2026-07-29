Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC393B5841
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 05:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785303460; cv=none; b=PdkWSBVwD3fBexKU9150UqcB/ELtZaWJfTm4MhCt8qpN69hMF0DAe2vc7+yYgMjNaSNS93Iu4A0YddGkO77jd2Wj7MEReyjRwVzOaYWzTdZ50I8rSwZK82YIfsHyJQPGwZkDY5OEt1QIrji6yD45xrfy0pb3o9Uc3HNNC7Gyrd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785303460; c=relaxed/simple;
	bh=81WsicO1lnWvPSZw1fn2UG+k9M3g0LSPZQa9sgz45IY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MtfXqDZ7K2Cs84yj3THuRtzXj4aRXSWOvRUySQns+lgf0J97sIa+jj4GtNLxj9LCHbLbd9z8Gy+/rG1SBz8iahzeuTi68xveFjEpLPJpdMJ3HdxBrP+T0DEIHHZPgD29D+ta5DN/6qGIlncHMB6GDVjWKuLl8VmLRTppXTMEE2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jjn8a9kX; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jjn8a9kX"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-495efdede87so8288b6e.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 22:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785303458; x=1785908258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LYEwKBiTcuHNpwjMLcTcd5LYOpcHXXSayMJQAf1r+NQ=;
        b=Jjn8a9kX2I9jpP0PH2u8gVTC5O+kXwcmOwpYoi24sTtud+SmGPPPuW4iyGJIX5TDPZ
         GXwtQiQ6FwOXIluo/LvgfPKxetT4HOP2k7z7+r/MMQ+QUGIBRjwKBmXgDiw+mTH41UdV
         fsftV1WM3wF5V9Lv6ABkJTMS0nODBO1McS3SnlfGwVUEW7g+uBQHbkS9tlm578KLHIqY
         2MimHjRXRO1dfZ7IOgoob+qYLQDouKpGiLyEalVPgN7bzTK8hpHN954QG0my7tCkGvFo
         G51uolHMsDHcQvddu5Vb23MzH1A2tKy1sl20fsE0LtwnFz2kN5yfc9d165p4P+r6Yn4j
         FxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785303458; x=1785908258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LYEwKBiTcuHNpwjMLcTcd5LYOpcHXXSayMJQAf1r+NQ=;
        b=GAgG2Rrxuv+ga42Xn9ym3sCMIsrtCCq847FOs7+CbDvdFij7j+YujCBc3TsvddfZRQ
         DMgebJExrtP8B7OKw2k5VoSMnF6fpJaAeb6Yg2CwNDwr2hjRVBiCxuK6b4pz+zPPL6O9
         syRQc3Gq8mOTflMvxsnr/Y/oFn0iH2ak5t+K4Fhjag2Wz2HsmEuF1dj8pwL/UtNM9QUL
         TYOPdrwK6vjaqTr6U/ClXpCu+QnniCB7XG1K1gBSstt92h9nVJfnGEU/ZXnm+kdSiLOB
         kNOg0pEthH5Ugm16yT6iCTq89Fu5NSNYsUxDpGa/V29f3GCazz6TfI3r+OeKnlhrFIt4
         8peA==
X-Gm-Message-State: AOJu0Ywwraf4dJXg6VUTuJ6ZGeDbnKQ9z7yixZi28U8OuCBq77K9vEg4
	rx5HJjpfEpmXEjR2r3u3726IeC5xyIyevF7vmxPruhJx+crsN03oZrVk
X-Gm-Gg: AR+sD10PNUBTZX8MXqFDe7u/vCbCiFcqxdrSxuwHz9cGEInwU4ioSeGxgMq0uLD59Oj
	8F/Pd3H1V/FMZJZEDXNnXDaH8yA+sfE07EKMhXclx8N0k4nSFqSLQVBi8CxVWqjnlHLkqI5cYUf
	kfTtaCq4Z0qFRlrc5eP0RiQzhWrxvh3zo3+2t4dZfxICU31j1fvnFSir1ar/RGBNsD/TL/OjoDh
	ve6Rs5sHenNdJjSr8shnRQouExRS6Wc3w+kNLgAxmD87Bva5HaDDIljterL2cUlXBgICy2MpGKa
	lc8yEtCC1rZ+kzUAiDTlOPi26SIR8TWDw8wNhlwtyyjaH+Dm5UrkGrEhTB5lOZcxNKf2O1uwuId
	p00hY5KuYf+s2RZL+THPCylGc6JZYYQ/iYZMQenGI2USRf7qZqeWVHoaEmiPkFLEST0iybIlmb2
	fHOQ4XuEMtiY3lw0/6Qc9DeQtTRdXJpL5gXQZiytnxsgBONcPmwpO1QrVLIxLd6fgQklnp4aQ1E
	8J3uUU6zUY0lPpvur0tB5CES/g1WHtwe5mwYrGdYGXlzFM9jFkzNc7xi2420QQ=
X-Received: by 2002:a05:6808:1589:b0:497:e695:3423 with SMTP id 5614622812f47-4ad5b5bcfb1mr2048496b6e.0.1785303457731;
        Tue, 28 Jul 2026 22:37:37 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6efc6ffcsm986864b6e.15.2026.07.28.22.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 22:37:36 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>
Subject: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
Date: Wed, 29 Jul 2026 00:34:08 -0500
Message-ID: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When bringing up a WPA3-SAE SoftAP with external (user space) SAE, the
driver never told the firmware which SAE Password Element (PWE) method to
accept. The firmware was observed to corrupt its heap over time due to
this omission, leading to firmware trap (data abort in heap allocator).

Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
membership selector is present, 0 otherwise. This matches the behaviour
of the upstream/vendor driver and only applies to SAE-capable APs when
external SAE is supported.

Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d32b35ce0..335647916 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -60,6 +60,10 @@
 #define RSN_AKM_SHA256_1X		5	/* SHA256, 802.1X */
 #define RSN_AKM_SHA256_PSK		6	/* SHA256, Pre-shared Key */
 #define RSN_AKM_SAE			8	/* SAE */
+#define BSS_MEMBERSHIP_SELECTOR_SAE_H2E_ONLY 123
+#define BSS_MEMBERSHIP_SELECTOR_SET	0x80
+#define SAE_H2E_ONLY_ENABLE		(BSS_MEMBERSHIP_SELECTOR_SAE_H2E_ONLY | \
+					 BSS_MEMBERSHIP_SELECTOR_SET)
 #define RSN_CAP_LEN			2	/* Length of RSN capabilities */
 #define RSN_CAP_PTK_REPLAY_CNTR_MASK	(BIT(2) | BIT(3))
 #define RSN_CAP_MFPR_MASK		BIT(6)
@@ -5091,6 +5095,73 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 	return err;
 }
 
+static s32
+brcmf_parse_configure_sae_pwe(struct brcmf_if *ifp,
+			      struct cfg80211_ap_settings *settings)
+{
+	s32 err = 0;
+	const struct brcmf_tlv *rsnx_ie;
+	const struct brcmf_tlv *ext_rate_ie;
+	const struct brcmf_tlv *supp_rate_ie;
+	u8 ie_len, i;
+	u32 wpa_auth = 0;
+	/* SAE PWE method(s) to accept: 0 = Hunting-and-Pecking only,
+	 * 1 = H2E only, 2 = both.
+	 */
+	u32 sae_pwe = 0;
+
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SAE_EXT))
+		return 0;
+
+	err = brcmf_fil_bsscfg_int_get(ifp, "wpa_auth", &wpa_auth);
+	if (err || (wpa_auth & WPA3_AUTH_SAE_PSK) == 0) {
+		brcmf_dbg(INFO, "wpa_auth is not SAE:0x%x\n", wpa_auth);
+		return 0;
+	}
+
+	rsnx_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
+				   settings->beacon.tail_len, WLAN_EID_RSNX);
+	if (rsnx_ie && rsnx_ie->len &&
+	    (rsnx_ie->data[0] & WLAN_RSNX_CAPA_SAE_H2E))
+		sae_pwe = 2;
+
+	if (sae_pwe == 2) {
+		supp_rate_ie = brcmf_parse_tlvs((u8 *)settings->beacon.head,
+						settings->beacon.head_len,
+						WLAN_EID_SUPP_RATES);
+		ext_rate_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
+					       settings->beacon.tail_len,
+					       WLAN_EID_EXT_SUPP_RATES);
+		if (ext_rate_ie) {
+			ie_len = ext_rate_ie->len;
+			for (i = 0; i < ie_len; i++) {
+				if (ext_rate_ie->data[i] == SAE_H2E_ONLY_ENABLE) {
+					sae_pwe = 1;
+					break;
+				}
+			}
+		}
+		if (sae_pwe == 2 && supp_rate_ie) {
+			ie_len = supp_rate_ie->len;
+			for (i = 0; i < ie_len; i++) {
+				if (supp_rate_ie->data[i] == SAE_H2E_ONLY_ENABLE) {
+					sae_pwe = 1;
+					break;
+				}
+			}
+		}
+	}
+
+	err = brcmf_fil_iovar_int_set(ifp, "extsae_pwe", sae_pwe);
+	if (err) {
+		brcmf_err("extsae_pwe iovar not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	brcmf_dbg(INFO, "extsae_pwe=%u\n", sae_pwe);
+	return 0;
+}
+
 static s32
 brcmf_parse_configure_security(struct brcmf_if *ifp,
 			       struct cfg80211_ap_settings *settings,
@@ -5124,6 +5195,10 @@ brcmf_parse_configure_security(struct brcmf_if *ifp,
 			err = brcmf_configure_wpaie(ifp, tmp_ie, true);
 			if (err < 0)
 				return err;
+
+			err = brcmf_parse_configure_sae_pwe(ifp, settings);
+			if (err < 0)
+				return err;
 		}
 	} else {
 		brcmf_dbg(TRACE, "No WPA(2) IEs found\n");
-- 
2.55.0

