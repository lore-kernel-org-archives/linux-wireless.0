Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87C33B71BE
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788156765; cv=none; b=IJ74FmQ9bP+pfxrTNydudUTIkl0XkQrw00gQoTLfkx1sfDU9zbfWoKMcViP7fsaon/YbzJ7SCYhvnbKcBFj5fIL5yDSVBknMEwvAWuYJlYsISrsPbuut27GLpCBWOk/scGHn0flg+buSPJIM/8ndqjqbYzqExmBYgh2uYrEIXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788156765; c=relaxed/simple;
	bh=uzM5n4W6540Hau1uLgcXyAyd8k+gRB0nI7M45zCAyU8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uyXn0/46qJQICRtZLkvt4HXO1LDqwAw3qLFLg0UaPYk+fJv9Fs8m9gdxft2tG3zhp4odJpF6iEtodZWW/zmUkCpR6JWPw1U9ybB9SInAvXw+xLFf4kC2ZZDXxYOUanQc4GEtSqNbQQn8x9mVReH8ujV+P2BX18YRmGyUGVQ5bQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=CZHd8Kkj; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="CZHd8Kkj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788156762; x=1819692762;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uzM5n4W6540Hau1uLgcXyAyd8k+gRB0nI7M45zCAyU8=;
  b=CZHd8Kkj52YPyBBUFeBWf7UhPsIwmOZ8gxG8us+8XdvTg0s5Mv+r3FGk
   W5urFJud8ribe/VYfboh1SqAUjaNm3M2+Qg4PesIfSYFCIX3qhnOigsvp
   +WNAriGFaJBYW4M9KhA2pWxhB63mkD83eQIvOCY4izQvD+fpqYGYI/Xvf
   Y=;
X-CSE-ConnectionGUID: lD+jiukhQXGEhXL9qCnEHQ==
X-CSE-MsgGUID: 9+HKW299RjCsCYaDtltSqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="175824537"
X-IronPort-AV: E=Sophos;i="6.25,252,1779141600"; 
   d="scan'208";a="175824537"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 08:12:33 +0200
Received: from MUCSE829.infineon.com (172.23.29.22) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 31 Aug
 2026 08:12:32 +0200
Received: from ISCN5CG6022HSR.infineon.com (10.161.6.196) by
 MUCSE829.infineon.com (172.23.29.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 31 Aug 2026 08:12:31 +0200
From: GirishBukkasagara.Rudrappa <girishbukkasagara.rudrappa@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <arend.vanspriel@broadcom.com>, <johannes.berg@intel.com>,
	<brcm80211@lists.linux.dev>, <wlan-kernel-dev-list@infineon.com>,
	<bogdan.nicolae@gmail.com>, Girish Rudrappa
	<girishbukkasagara.rudrappa@infineon.com>
Subject: [PATCH] wifi: brcmfmac: Set extsae_pwe parameter to Infineon firmware in SAP mode
Date: Mon, 31 Aug 2026 06:12:13 +0000
Message-ID: <20260831061213.240270-1-girishbukkasagara.rudrappa@infineon.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE802.infineon.com (172.23.29.28) To
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
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 77 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/cyw/core.c    |  6 ++
 .../broadcom/brcm80211/brcmfmac/fwvid.h       | 11 +++
 3 files changed, 94 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 872c48806d09..192ea19b216b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5099,6 +5099,79 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
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
@@ -5132,6 +5205,10 @@ brcmf_parse_configure_security(struct brcmf_if *ifp,
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
-- 
2.53.0

