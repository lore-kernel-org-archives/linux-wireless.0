Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F241BA83;
	Fri, 21 Aug 2026 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299031; cv=none; b=O9xXMSwJ1GkAJO1eboFzAM+2eepd/I7dOt8TCfVVCNs4HFrA/nErJz+xHgNXc7+loZQUbTjMJpk6UMUCWUsMnSTa3+VRMUYXuJE4KSDIYW7b/xznSn4Nvten8fYdPPvg6G3VtuoQYVqCjuS3WWPXNtvW4I4siKgTPsObJv3RlhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299031; c=relaxed/simple;
	bh=K8vTRJbbTzSsQyUUJQiGT9OhfCWKl65Qlx+r6j1+VhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzB5YDZmdtCxGRoRm2Tf2IjKrGJW1s32e/xjDvcucpLjH6KJj01xkLVBlzPi4grq1nGrzz6n1hTUauAc7nahrufHfWpAiYZljiDKVQhpjz9nGfeyko2MZx2GDNjy0/EHim4kYsUbSjQAXNL+vGUGSoNabRphvzkuHhIfB51zUDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=eAFeU0Z3; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="eAFeU0Z3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787299029; x=1818835029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K8vTRJbbTzSsQyUUJQiGT9OhfCWKl65Qlx+r6j1+VhY=;
  b=eAFeU0Z3tINiPdmgMtDZigyxHrzczHsNgDARHnm8pKUmIHCFLXFDxUsY
   YfHIAuJvveuP2yXy4a3PvUFA9EEjycPvhWtufeJRFNOEulRH5W3pFheDt
   669mHw3DUSKA0cTx258MS785+Bw12Uqna8Hw3ns+mV3ZTEAue2dHk8hRE
   Q=;
X-CSE-ConnectionGUID: eadkak4XS2KFDZxyAOUx4w==
X-CSE-MsgGUID: kiPBsjPKQLC02+nNtfiIKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="105579507"
X-IronPort-AV: E=Sophos;i="6.25,234,1779141600"; 
   d="scan'208";a="105579507"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:57:07 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 09:57:06 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:57:01 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes.berg@intel.com>, <johannes@sipsolutions.net>,
	<arend.vanspriel@broadcom.com>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Chung-Hsien Hsu
	<Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Carella Chen <carella.chen@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>
Subject: [PATCH v5 4/5] wifi: brcmfmac: report port authorization after offloaded roaming
Date: Fri, 21 Aug 2026 15:56:16 +0800
Message-ID: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-4-eeab4fda0f31@infineon.com>
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

Firmware can complete FT or OKC roaming before the driver reports the
connect or roam event to cfg80211. Detect those successful offloaded
cases when the profile uses firmware 1X or roaming offload and the
association request carries PMK cache state, FT is in use, or OKC is
enabled.

After reporting the connect or roam event, call cfg80211_port_authorized()
so nl80211 emits the dedicated NL80211_CMD_PORT_AUTHORIZED event instead
of reusing the reserved NL80211_ATTR_PORT_AUTHORIZED flag in CONNECT/ROAM
notifications.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
Signed-off-by: Darren Li <hsin-hung.li@cypress.com>
Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 65 ++++++++++++++++++++--
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f2916cc9e5fc..c11b3eac9d47 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6466,6 +6466,47 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	return err;
 }
 
+static bool brcmf_has_pmkid(const u8 *parse, u32 len)
+{
+	const struct brcmf_tlv *rsn_ie;
+	const u8 *ie;
+	u32 ie_len;
+	u32 offset;
+	u16 count;
+
+	if (!parse)
+		return false;
+
+	rsn_ie = brcmf_parse_tlvs(parse, len, WLAN_EID_RSN);
+	if (!rsn_ie)
+		return false;
+
+	ie = (const u8 *)rsn_ie;
+	ie_len = rsn_ie->len + TLV_HDR_LEN;
+
+	offset = TLV_HDR_LEN + WPA_IE_VERSION_LEN + WPA_IE_MIN_OUI_LEN;
+	if (offset + WPA_IE_SUITE_COUNT_LEN >= ie_len)
+		return false;
+
+	count = ie[offset] + (ie[offset + 1] << 8);
+	offset += WPA_IE_SUITE_COUNT_LEN + count * WPA_IE_MIN_OUI_LEN;
+	if (offset + WPA_IE_SUITE_COUNT_LEN >= ie_len)
+		return false;
+
+	count = ie[offset] + (ie[offset + 1] << 8);
+	offset += WPA_IE_SUITE_COUNT_LEN + count * WPA_IE_MIN_OUI_LEN;
+	if (offset + RSN_CAP_LEN >= ie_len)
+		return false;
+
+	offset += RSN_CAP_LEN;
+	if (offset + RSN_PMKID_COUNT_LEN > ie_len)
+		return false;
+
+	count = ie[offset] + (ie[offset + 1] << 8);
+
+	return count > 0;
+}
+
 static s32
 brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev,
@@ -6480,6 +6521,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_bss_info_le *bi;
 	struct brcmu_chan ch;
 	struct cfg80211_roam_info roam_info = {};
+	bool authorized = false;
 	u32 freq;
 	s32 err = 0;
 	u8 *buf;
@@ -6526,14 +6568,18 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	roam_info.resp_ie = conn_info->resp_ie;
 	roam_info.resp_ie_len = conn_info->resp_ie_len;
 
+	if ((profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X ||
+	     profile->use_fwsup == BRCMF_PROFILE_FWSUP_ROAM) &&
+	    (brcmf_has_pmkid(roam_info.req_ie, roam_info.req_ie_len) ||
+	     profile->is_ft || profile->is_okc))
+		authorized = true;
+
 	cfg80211_roamed(ndev, &roam_info, GFP_KERNEL);
+	if (authorized)
+		cfg80211_port_authorized(ndev, profile->bssid, NULL, 0,
+					 GFP_KERNEL);
 	brcmf_dbg(CONN, "Report roaming result\n");
 
-	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X && profile->is_ft) {
-		cfg80211_port_authorized(ndev, profile->bssid, NULL, 0, GFP_KERNEL);
-		brcmf_dbg(CONN, "Report port authorized\n");
-	}
-
 	set_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state);
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -6548,6 +6594,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct cfg80211_connect_resp_params conn_params;
+	bool authorized;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -6572,7 +6619,15 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		conn_params.req_ie_len = conn_info->req_ie_len;
 		conn_params.resp_ie = conn_info->resp_ie;
 		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		authorized = completed &&
+			     (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X ||
+			      profile->use_fwsup == BRCMF_PROFILE_FWSUP_ROAM) &&
+			     brcmf_has_pmkid(conn_params.req_ie,
+					     conn_params.req_ie_len);
 		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
+		if (authorized)
+			cfg80211_port_authorized(ndev, profile->bssid, NULL, 0,
+						 GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}

-- 
2.25.1
