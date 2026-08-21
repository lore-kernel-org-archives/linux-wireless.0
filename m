Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AFD419313;
	Fri, 21 Aug 2026 07:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299030; cv=none; b=IMadEGOA3G7fzQp9Z1AhViusfXichsqRsVVOAT1+roOaveXGqCIJjIJIsO0qdzmZt/j8BrqOGlaNlwJhLQ6Pvlr6SDjuC+HOLpH2nXUSEyZEDXUcnS+kAYdxAW0VDBeHJ4q1yukSlMnq5efNn9KGNxo1xA/usnEDjgoS8hZncx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299030; c=relaxed/simple;
	bh=StdLxsvUVXdzP8w7YEWqdH9NS2xn4P9VQr7TqXLuHQs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdgDtA4uvoPLHG7cVHo6PI9tra2kRwt+DJsDq3VRIX5RyuTMqrkZfkLO5CG+AlgqsQA+QRKD7RmjBxm+6E9I0cOma9IzDoRidoEZ/f/gOpYSw6wiq4XRpVmT2cy675cDj0ftRJOY7SGL8KJ+7k9N3q3rc8N6xHOuotpnKRFtLH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=f0vbMw3T; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="f0vbMw3T"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787299028; x=1818835028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StdLxsvUVXdzP8w7YEWqdH9NS2xn4P9VQr7TqXLuHQs=;
  b=f0vbMw3TSu92bLc3TLTzq1v0s5OoWg6fW5DyzEq++4PXOjwXlBMR3n52
   qmoGTpWXpOi0iRIWg0DlCno0WZnslwOqiwOtovqFPMx/FU27mbo6dW8nM
   /4w1ULcH+OsM26ZIQoltAjfKatGT5S+X1XqKCzzCqbVfi+9jDnMrhu9TT
   s=;
X-CSE-ConnectionGUID: Z/XUZRZCRZOIWl8ueMRzeg==
X-CSE-MsgGUID: U1alvkhpRl+zmXNbRxwjew==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="156882704"
X-IronPort-AV: E=Sophos;i="6.25,234,1779141600"; 
   d="scan'208";a="156882704"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:57:00 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 09:56:59 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:56:54 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes.berg@intel.com>, <johannes@sipsolutions.net>,
	<arend.vanspriel@broadcom.com>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Chung-Hsien Hsu
	<Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Carella Chen <carella.chen@infineon.com>, Shelley Yang
	<shelley.yang@infineon.com>, Jason Huang <jason.huang2@infineon.com>
Subject: [PATCH v5 3/5] wifi: brcmfmac: add PMK programming for firmware roaming offload
Date: Fri, 21 Aug 2026 15:56:15 +0800
Message-ID: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-3-eeab4fda0f31@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE812.infineon.com (172.23.29.38) To
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

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
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
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  5 +-
 2 files changed, 54 insertions(+), 7 deletions(-)

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
index 63e534523f51..1aa99390a951 100644
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
@@ -164,6 +165,7 @@ enum brcmf_mgmt_tx_status {
  * @bssid: bssid of joined/joining ibss.
  * @sec: security information.
  * @key: key information
+ * @is_okc: OKC is used for current connection.
  */
 struct brcmf_cfg80211_profile {
 	u8 bssid[ETH_ALEN];
@@ -172,6 +174,7 @@ struct brcmf_cfg80211_profile {
 	enum brcmf_profile_fwsup use_fwsup;
 	u16 use_fwauth;
 	bool is_ft;
+	bool is_okc;
 };
 
 /**

-- 
2.25.1
