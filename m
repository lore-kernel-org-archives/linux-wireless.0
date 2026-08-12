Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763591922F5
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786506433; cv=none; b=HfoGKSsieORQaxrSpJhexwugSY5IWIsCg4HS0mhT7Xvo8IHV2hmEBdv25bL+34HxCAw0wZu1jKHpkN06vw4icO0Ywe0IoTPymBot4/rKEn4LVUYHCse4AN34g+0ACpRFSK1l2mV9LgfGQvDKvovHJG1nG9LqtMTuNyzNcxztNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786506433; c=relaxed/simple;
	bh=ENZRZh6U6qmgQu+WzhqkmDn/Bh7aN/I+5oUJn5PUDkI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0uqwv2gGw4sleQKfk+T5JZbmjSqeA6zjJOZysS6BRARL3ca5Q4Q0enemC9FRRcKLNVyAKCTxtNpNe1uZecF9IBx8R9e79qJjSenTOgjqvWdXY6yQ68J2cj9XnjrMVXAlYQQhm8YzYo6P7kxDJTDaMVbxcOhSFEiUDc/I9jsOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=IcWuzyrZ; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="IcWuzyrZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786506431; x=1818042431;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ENZRZh6U6qmgQu+WzhqkmDn/Bh7aN/I+5oUJn5PUDkI=;
  b=IcWuzyrZkwdKprshJjZO9Im589kk+a2913OEcPCJcbDEYaxykztJW5+W
   CSNFY65hbuwIyH3mP0VVTlqIyPNbg5ruTgR4210UbVSK5vg7MdJtNaYzQ
   hqJ+JtbGyEieiB/+efRUb3yVlrA/AIvA9CJm8sogDWaISg41Y1bjgHyO9
   8=;
X-CSE-ConnectionGUID: OlQfDcGDR96w/G8R6aI6fg==
X-CSE-MsgGUID: 1c1kJs2MQ8u9LAgWWd4EwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="141616260"
X-IronPort-AV: E=Sophos;i="6.25,218,1779141600"; 
   d="scan'208";a="141616260"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 05:47:09 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 05:47:09 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 05:47:07 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: Jason Huang <Jason.Huang2@infineon.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 3/5] wifi: brcmfmac: add PMK programming for firmware roaming offload
Date: Wed, 12 Aug 2026 11:44:54 +0800
Message-ID: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-3-b1843e1f6de4@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
References: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786505858; l=7383; i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id; bh=Da7kCCpMdDUcYXmzKnXe80r7p60k0ZRO//WetmJgFjA=; b=uQDOYv9o4pUIbQxzB5OL7RVZjPqvsG1fFL+6Khr2rU+1TZUEFn37SQR0MzV9rS21Fhcm59pDP kynkr9B8mSsCFrTpyLblwvKmMSkzvnNpsM1jJOD2lOA4a6vr7Aqb302
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519; pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE809.infineon.com (172.23.29.35)

From: Darren Li <hsin-hung.li@cypress.com>

FT and OKC roaming offload need PMK material in firmware even when
the initial 802.1X exchange is handled by userspace. Add a roaming
firmware-supplicant profile state for those connections and allow PMK
configuration while firmware FT or OKC state is active.

Program the OKC PMK through the okc_info_pmk iovar before setting the
regular PMK when firmware reports OKC state. Only select the roaming
firmware-supplicant state when firmware advertises FBT or OKC support;
devices without those capabilities keep the profile in the userspace
supplicant state and do not issue roaming-offload specific iovars on
every connect.

For FT-PSK with firmware supplicant support, keep the profile in the
PSK firmware-supplicant state.

Assisted-by: GitHub Copilot CLI:gpt-5.5
Signed-off-by: Darren Li <hsin-hung.li@cypress.com>
Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Co-developed-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Co-developed-by: Shelley Yang <shelley.yang@infineon.com>
Signed-off-by: Shelley Yang <shelley.yang@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 56 +++++++++++++++++++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  4 +-
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 872c48806d09..f2916cc9e5fc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2112,9 +2112,11 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 val;
 	s32 err;
+	s32 okc_enable;
 	const struct brcmf_tlv *rsn_ie;
 	const u8 *ie;
 	u32 ie_len;
+	bool fwsup_roam;
 	u32 offset;
 	u16 rsn_cap;
 	u32 mfp;
@@ -2122,6 +2124,9 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 
 	profile->use_fwsup = BRCMF_PROFILE_FWSUP_NONE;
 	profile->is_ft = false;
+	profile->is_okc = false;
+	fwsup_roam = brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FBT) ||
+		     brcmf_feat_is_enabled(ifp, BRCMF_FEAT_OKC);
 
 	if (!sme->crypto.n_akm_suites)
 		return 0;
@@ -2138,6 +2143,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA_AUTH_UNSPECIFIED;
 			if (sme->want_1x)
 				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
+			else if (fwsup_roam)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_ROAM;
 			break;
 		case WLAN_AKM_SUITE_PSK:
 			val = WPA_AUTH_PSK;
@@ -2153,11 +2160,15 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA2_AUTH_UNSPECIFIED;
 			if (sme->want_1x)
 				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
+			else if (fwsup_roam)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_ROAM;
 			break;
 		case WLAN_AKM_SUITE_8021X_SHA256:
 			val = WPA2_AUTH_1X_SHA256;
 			if (sme->want_1x)
 				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
+			else if (fwsup_roam)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_ROAM;
 			break;
 		case WLAN_AKM_SUITE_PSK_SHA256:
 			val = WPA2_AUTH_PSK_SHA256;
@@ -2170,10 +2181,16 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			profile->is_ft = true;
 			if (sme->want_1x)
 				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
+			else if (fwsup_roam)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_ROAM;
 			break;
 		case WLAN_AKM_SUITE_FT_PSK:
 			val = WPA2_AUTH_PSK | WPA2_AUTH_FT;
 			profile->is_ft = true;
+			if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FWSUP))
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_PSK;
+			else if (fwsup_roam)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_ROAM;
 			break;
 		case WLAN_AKM_SUITE_WFA_DPP:
 			val = WFA_AUTH_DPP;
@@ -2204,8 +2221,22 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 
 	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X)
 		brcmf_dbg(INFO, "using 1X offload\n");
+
+	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X ||
+	    profile->use_fwsup == BRCMF_PROFILE_FWSUP_ROAM) {
+		err = brcmf_fil_bsscfg_int_get(ifp, "okc_enable",
+					       &okc_enable);
+		if (err) {
+			bphy_err(drvr, "get okc_enable failed (%d)\n", err);
+		} else {
+			brcmf_dbg(INFO, "okc_enable (%d)\n", okc_enable);
+			profile->is_okc = okc_enable;
+		}
+	}
 	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE)
 		brcmf_dbg(INFO, "using SAE offload\n");
+	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_ROAM)
+		brcmf_dbg(INFO, "using roaming offload\n");
 
 	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MFP))
 		goto skip_mfp_config;
@@ -2494,13 +2525,14 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 		if (sme->crypto.psk && !is_sae_akm &&
 		    profile->use_fwsup != BRCMF_PROFILE_FWSUP_SAE) {
-			if (WARN_ON(profile->use_fwsup !=
-				    BRCMF_PROFILE_FWSUP_NONE)) {
+			if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_NONE) {
+				brcmf_dbg(INFO, "using PSK offload\n");
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_PSK;
+			} else if (WARN_ON(profile->use_fwsup !=
+					   BRCMF_PROFILE_FWSUP_PSK)) {
 				err = -EINVAL;
 				goto done;
 			}
-			brcmf_dbg(INFO, "using PSK offload\n");
-			profile->use_fwsup = BRCMF_PROFILE_FWSUP_PSK;
 		}
 		if (profile->use_fwsup != BRCMF_PROFILE_FWSUP_NONE) {
 			/* enable firmware supplicant for this interface */
@@ -5953,17 +5985,29 @@ static int brcmf_cfg80211_set_pmk(struct wiphy *wiphy, struct net_device *dev,
 				  const struct cfg80211_pmk_conf *conf)
 {
 	struct brcmf_if *ifp;
+	struct brcmf_pub *drvr;
+	int ret;
 
 	brcmf_dbg(TRACE, "enter\n");
 
-	/* expect using firmware supplicant for 1X */
 	ifp = netdev_priv(dev);
-	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
+	drvr = ifp->drvr;
+	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X &&
+		    !ifp->vif->profile.is_ft &&
+		    !ifp->vif->profile.is_okc))
 		return -EINVAL;
 
 	if (conf->pmk_len > BRCMF_WSEC_MAX_PSK_LEN)
 		return -ERANGE;
 
+	if (ifp->vif->profile.is_okc) {
+		ret = brcmf_fil_iovar_data_set(ifp, "okc_info_pmk",
+					       conf->pmk, conf->pmk_len);
+		if (ret < 0)
+			bphy_err(drvr, "okc_info_pmk iovar failed: ret=%d\n",
+				 ret);
+	}
+
 	return brcmf_set_pmk(ifp, conf->pmk, conf->pmk_len);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 63e534523f51..58f229489836 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -127,7 +127,8 @@ enum brcmf_profile_fwsup {
 	BRCMF_PROFILE_FWSUP_NONE,
 	BRCMF_PROFILE_FWSUP_PSK,
 	BRCMF_PROFILE_FWSUP_1X,
-	BRCMF_PROFILE_FWSUP_SAE
+	BRCMF_PROFILE_FWSUP_SAE,
+	BRCMF_PROFILE_FWSUP_ROAM
 };
 
 /**
@@ -172,6 +173,7 @@ struct brcmf_cfg80211_profile {
 	enum brcmf_profile_fwsup use_fwsup;
 	u16 use_fwauth;
 	bool is_ft;
+	bool is_okc;
 };
 
 /**

-- 
2.25.1

