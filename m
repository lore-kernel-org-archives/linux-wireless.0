Received: from sirius.syn-flut.de (sirius.syn-flut.de [94.125.25.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E39403AF9;
	Mon, 10 Aug 2026 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.125.25.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786374727; cv=none; b=W9Bp2kMTpAxlG32CsGKUEtHidra3CBPlubrLDUk7jhkgZLTq5K974Ar+Q+8SPZ3Hkyp+bJ8qKhhOnHjhMLcNlIaB570gf5g3Bi/L58qS/jNuC4i4QPijb1TSz7vXnGKSTntHPrHgCydABs/6cHMWQp11hlDNJtOmPkjH4V+uKQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786374727; c=relaxed/simple;
	bh=pNitvX6sM/Opco/VrF8VCOV0XYlw7QRLLFo9vxq4i4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Py+LktsyqzgTlRdkJ0gFlmY5WGnDYLqaw2FPopKOAvqvpEukJjR69B+Efb1ENOLpOq8w2aSHrbmhaT39aq6q431XMaoWn6OdlGW2Bhk874lihRxCqBg4/RLKA7mffbhFEvcgbwaWEcdHw4G0cQ0WrH/Bxn9cGlPy9fVbW/qrHfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fischermail.me; spf=pass smtp.mailfrom=fischermail.me; dkim=pass (1024-bit key) header.d=fischermail.me header.i=@fischermail.me header.b=r9thHnBa; arc=none smtp.client-ip=94.125.25.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fischermail.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fischermail.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fischermail.me header.i=@fischermail.me header.b="r9thHnBa"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DF4A0140AAA;
	Mon, 10 Aug 2026 17:05:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fischermail.me;
	s=default; t=1786374356; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=7BsuONgPt7lll6yhj7fi/Li4gvxCG5ykrk5pSpjk4r4=;
	b=r9thHnBaEE2++zhPoHx2yHVRKndZN1Qp76izApNKMgWbLYVnXiAbU5NY302z9ukRPAPXge
	VOr0qEmDwRsNa6uUjmWGUMSQGxWBENakHjQ5rrYnDRt6mcyLFYidnM3B81AViMPozUGdDa
	X/M9iIb7Yy+r2SMvDMmDUd3c2eb81q8=
From: Alexander Fischer <alexander@fischermail.me>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>
Subject: [PATCH wireless-next] wifi: brcmfmac: allow opting into PM_MAX power management
Date: Mon, 10 Aug 2026 17:05:52 +0200
Message-ID: <20260810150552.25375-1-alexander@fischermail.me>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

While investigating high idle power consumption on a BCM4364, I found
that brcmfmac always selects PM_FAST when cfg80211 enables power saving.
This keeps the device responsive, but on this system it also kept the
platform latency-tolerance request low enough to prevent deeper package
idle states for most of the idle time.

PM_MAX is already part of the firmware interface, and brcmfmac uses it
while configuring WoWLAN. Using it during normal connected operation
changed the BCM4364 platform latency-tolerance request from 61,440 ns to
3,145,728 ns. In controlled 45-second idle samples, package C8 residency
increased from 6.48% to 20.36%. Several days of normal use also showed
lower battery drain. BCM4364 and BCM4377 have been tested without
observed connectivity or latency regressions.

PM_FAST has been selected since brcmfmac first entered staging in 2010,
and the commit history does not document why it was chosen. Cypress
carried an opt-in module parameter for PM_MAX downstream in 2018. Since
additional wake latency may still be undesirable on other devices or
workloads, changing the existing default would be risky.

A read-only max_pm module parameter makes PM_MAX available while leaving
PM_FAST as the default. PM_OFF remains in use when power saving is
disabled or the interface is a P2P client.

Link: https://github.com/RobertCNelson/linux-dev/blob/master/patches/cypress/brcmfmac/0029-brcmfmac-introduce-module-parameter-to-configure-def.patch
Reviewed-by: Andre Eikmeyer <dev@deq.rocks>
Tested-by: Andre Eikmeyer <dev@deq.rocks>
Signed-off-by: Alexander Fischer <alexander@fischermail.me>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c   | 6 ++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 872c48806d09..5e5b8bac53dc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3327,7 +3327,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	pm = enabled ? PM_FAST : PM_OFF;
+	pm = enabled ? ifp->drvr->settings->default_pm : PM_OFF;
 	/* Do not enable the power save after assoc if it is a p2p interface */
 	if (ifp->vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT) {
 		brcmf_dbg(INFO, "Do not enable power save for P2P clients\n");
@@ -7821,7 +7821,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 
 	brcmf_dongle_scantime(ifp);
 
-	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
+	power_mode = cfg->pwr_save ? ifp->drvr->settings->default_pm : PM_OFF;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, power_mode);
 	if (err)
 		goto default_conf_out;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index b6027d83e6ab..b2e06abc76f8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -20,6 +20,7 @@
 #include "of.h"
 #include "firmware.h"
 #include "chip.h"
+#include "defs.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
@@ -67,6 +68,10 @@ static int brcmf_iapp_enable;
 module_param_named(iapp, brcmf_iapp_enable, int, 0);
 MODULE_PARM_DESC(iapp, "Enable partial support for the obsoleted Inter-Access Point Protocol");
 
+static bool brcmf_max_pm;
+module_param_named(max_pm, brcmf_max_pm, bool, 0400);
+MODULE_PARM_DESC(max_pm, "Use PM_MAX instead of PM_FAST for power management");
+
 #ifdef DEBUG
 /* always succeed brcmf_bus_started() */
 static int brcmf_ignore_probe_fail;
@@ -530,6 +535,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 	settings->fcmode = brcmf_fcmode;
 	settings->roamoff = !!brcmf_roamoff;
 	settings->iapp = !!brcmf_iapp_enable;
+	settings->default_pm = brcmf_max_pm ? PM_MAX : PM_FAST;
 #ifdef DEBUG
 	settings->ignore_probe_fail = !!brcmf_ignore_probe_fail;
 #endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index 3bdb6984b2dd..d06c734ea82a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -37,6 +37,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
  * @feature_disable: Feature_disable bitmask.
  * @fcmode: FWS flow control.
  * @roamoff: Firmware roaming off?
+ * @default_pm: Default power-management mode.
  * @ignore_probe_fail: Ignore probe failure.
  * @trivial_ccode_map: Assume firmware uses ISO3166 country codes with rev 0
  * @country_codes: If available, pointer to struct for translating country codes
@@ -48,6 +49,7 @@ struct brcmf_mp_device {
 	int		fcmode;
 	bool		roamoff;
 	bool		iapp;
+	int		default_pm;
 	bool		ignore_probe_fail;
 	bool		trivial_ccode_map;
 	struct brcmfmac_pd_cc *country_codes;

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.55.0

