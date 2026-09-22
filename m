Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02BA3815F0
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058391; cv=none; b=tDEPkEiBcWlHyPOBST3Dr8lCug5IxndtI6LLnaIenobp/3Bvt/Y469gvolpbFt8aCaI/PMwFyWZfPODFnvO9PdmoqlD/q2U+yoMmsNEWFPcqABlWHZf5tieGLkAUQ23ZmgLj5d6/NkH4WjVIGUrchjNtCTcwilcmdl+MORyM+FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058391; c=relaxed/simple;
	bh=+62T9jmNqk2KD4MV3zERXImcCCd0Joj/18PLd167CqQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwrzNBtmyIJP+PxF7SYbc8EiEkDJTTWObUn23+9mld9HKomNtPrBkeywP9tM26QuLIBxFcIGTFtQVXuz0Fc9yGHTbS4VqZ7Jio5tcLkGrfJqkGG0kN0+CqDgwwtFskEmzFoiWSNDdFzs+RzQb4uJBr/2AItRytkolTf35sekli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=UpHAhp9F; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="UpHAhp9F"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1790058387; x=1821594387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+62T9jmNqk2KD4MV3zERXImcCCd0Joj/18PLd167CqQ=;
  b=UpHAhp9FYwof3/yujS7rMSSQQx4ehcIEpGPjpTpDSDRi+WZ8bkhwStI8
   ikktYTkYZ/p6lrk77fBlrIVWsuzaOOXYIC8ps3x4wOFrNGaXg4rlzUUie
   3qihJ4GOuaiQ0tcXskJhXIhv+i8E5vpmkbCn8Sha8YCnS9jhAXh2sW32v
   s=;
X-CSE-ConnectionGUID: uXBTIKZOSoaWEEl+flOAiQ==
X-CSE-MsgGUID: gQS0L9FIQeuokVrZwFwH+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="162168679"
X-IronPort-AV: E=Sophos;i="6.27,115,1787004000"; 
   d="scan'208";a="162168679"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 08:25:15 +0200
Received: from MUCSE829.infineon.com (172.23.29.22) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 08:25:14 +0200
Received: from ISCN5CG6022HSR.infineon.com (10.161.6.196) by
 MUCSE829.infineon.com (172.23.29.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 08:25:12 +0200
From: GirishBukkasagara.Rudrappa <girishbukkasagara.rudrappa@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <arend.vanspriel@broadcom.com>, <johannes.berg@intel.com>,
	<brcm80211@lists.linux.dev>, <wlan-kernel-dev-list@infineon.com>,
	<bogdan.nicolae@gmail.com>, Girish Rudrappa
	<girishbukkasagara.rudrappa@infineon.com>
Subject: [PATCH RESEND wireless-next v2] wifi: brcmfmac: Set extsae_pwe parameter to Infineon firmware in SAP mode
Date: Tue, 22 Sep 2026 06:24:58 +0000
Message-ID: <20260922062458.3550-1-girishbukkasagara.rudrappa@infineon.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917173704.6356-1-girishbukkasagara.rudrappa@infineon.com>
References: <20260917173704.6356-1-girishbukkasagara.rudrappa@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE829.infineon.com (172.23.29.22)

From: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>

Parse and configure the extsae_pwe according to the information from the
supported rate/extended support rate and RSNX IE

Parse the beacon IEs on start_ap() and set the extsae_pwe iovar.
Set sae_pwe to 2 when the RSNX IE advertises H2E, 1 when an H2E-only
membership selector is present, 0 otherwise.

The changes are tested with FW Version 7.45.286

Signed-off-by: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>
---
Resending v2 after updating subject prefix with target tree name

Changes in v2:
Rebased the code. No functionality changes

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 77 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    |  6 ++
 .../broadcom/brcm80211/brcmfmac/fwvid.h       | 11 +++
 3 files changed, 94 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 9d8ce7bb046e..a9e5ab5ea292 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5131,6 +5131,79 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 	return err;
 }
 
+static s32
+brcmf_parse_configure_sae_pwe(struct brcmf_if *ifp,
+			      struct cfg80211_ap_settings *settings)
+{
+	const struct brcmf_tlv *rsnx_ie;
+	const struct brcmf_tlv *ext_rate_ie;
+	const struct brcmf_tlv *supp_rate_ie;
+	u8 ie_len, i;
+	u32 wpa_auth = 0;
+	u32 sae_pwe = 0; /* 0 = Hunting-and-Pecking only, 1 = H2E only, 2 = both */
+	s32 err = 0;
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
+
+	if (rsnx_ie && rsnx_ie->len &&
+	    (rsnx_ie->data[0] & WLAN_RSNX_CAPA_SAE_H2E))
+		sae_pwe = 2;
+
+	/* Found rsnx_ie with SAE_H2E, check the bss selector to know if it is
+	 * a H2E only.
+	 */
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
+				if ((ext_rate_ie->data[i] & 0x7f) ==
+				    BSS_MEMBERSHIP_SELECTOR_SAE_H2E) {
+					sae_pwe = 1;
+					break;
+				}
+			}
+		}
+
+		/* If we cannot found H2E only selector in ext_supp_rate IE,
+		 * traversal supp_rate IE to make sure it really doesn't exist
+		 */
+		if (sae_pwe == 2 && supp_rate_ie) {
+			ie_len = supp_rate_ie->len;
+			for (i = 0; i < ie_len; i++) {
+				if ((supp_rate_ie->data[i] & 0x7f) ==
+				    BSS_MEMBERSHIP_SELECTOR_SAE_H2E) {
+					sae_pwe = 1;
+					break;
+				}
+			}
+		}
+	}
+
+	err = brcmf_fwvid_configure_sae_pwe(ifp, sae_pwe);
+	if (err == -EOPNOTSUPP)
+		return 0;
+
+	brcmf_dbg(TRACE, "extsae_pwe=%u\n", sae_pwe);
+	return err;
+}
+
 static s32
 brcmf_parse_configure_security(struct brcmf_if *ifp,
 			       struct cfg80211_ap_settings *settings,
@@ -5164,6 +5237,10 @@ brcmf_parse_configure_security(struct brcmf_if *ifp,
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
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 545eb9aae966..0443207dfe00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -367,10 +367,16 @@ static void brcmf_cyw_register_event_handlers(struct brcmf_pub *drvr)
 			    brcmf_notify_mgmt_tx_status);
 }
 
+static int brcmf_cyw_configure_sae_pwe(struct brcmf_if *ifp, u32 sae_pwe)
+{
+	return brcmf_fil_iovar_int_set(ifp, "extsae_pwe", sae_pwe);
+}
+
 const struct brcmf_fwvid_ops brcmf_cyw_ops = {
 	.set_sae_password = brcmf_cyw_set_sae_pwd,
 	.alloc_fweh_info = brcmf_cyw_alloc_fweh_info,
 	.activate_events = brcmf_cyw_activate_events,
 	.get_cfg80211_ops = brcmf_cyw_get_cfg80211_ops,
 	.register_event_handlers = brcmf_cyw_register_event_handlers,
+	.configure_sae_pwe = brcmf_cyw_configure_sae_pwe,
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
index f3e011d090f2..56d341a75a53 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
@@ -18,6 +18,7 @@ struct brcmf_fwvid_ops {
 	int (*activate_events)(struct brcmf_if *ifp);
 	void (*get_cfg80211_ops)(struct brcmf_pub *drvr);
 	void (*register_event_handlers)(struct brcmf_pub *drvr);
+	int (*configure_sae_pwe)(struct brcmf_if *ifp, u32 sae_pwe);
 };
 
 /* exported functions */
@@ -40,6 +41,16 @@ static inline void brcmf_fwvid_feat_attach(struct brcmf_if *ifp)
 	vops->feat_attach(ifp);
 }
 
+static inline int brcmf_fwvid_configure_sae_pwe(struct brcmf_if *ifp, u32 sae_pwe)
+{
+	const struct brcmf_fwvid_ops *vops = ifp->drvr->vops;
+
+	if (!vops || !vops->configure_sae_pwe)
+		return -EOPNOTSUPP;
+
+	return vops->configure_sae_pwe(ifp, sae_pwe);
+}
+
 static inline int brcmf_fwvid_set_sae_password(struct brcmf_if *ifp,
 					       struct cfg80211_crypto_settings *crypto)
 {

base-commit: 6c0b7357e3c7f365ec51dd8d2b626130ee983ce1
-- 
2.53.0

