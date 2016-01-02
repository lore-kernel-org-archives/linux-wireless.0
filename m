Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51403 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbcABIlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 7/7] brcmfmac: introduce module parameter to force successful probe
Date: Sat, 2 Jan 2016 09:41:42 +0100
Message-ID: <1451724102-21911-8-git-send-email-arend@broadcom.com> (sfid-20160102_094231_401539_CD4C7378)
In-Reply-To: <1451724102-21911-1-git-send-email-arend@broadcom.com>
References: <1451724102-21911-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module parameter can be used to ensure the probe succeeds thus
claiming the device and allowing post-mortem debugging in case of
firmware crash. It is only available when select CONFIG_BRCMDBG.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 11 ++++++++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h | 13 +++++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   |  2 ++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index bb9e2b3..4265b50 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -67,6 +67,13 @@ static int brcmf_roamoff;
 module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
 MODULE_PARM_DESC(roamoff, "Do not use internal roaming engine");
 
+#ifdef DEBUG
+/* always succeed brcmf_bus_start() */
+static int brcmf_ignore_probe_fail;
+module_param_named(ignore_probe_fail, brcmf_ignore_probe_fail, int, 0);
+MODULE_PARM_DESC(ignore_probe_fail, "always succeed probe for debugging");
+#endif
+
 struct brcmf_mp_global_t brcmf_mp_global;
 
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
@@ -232,7 +239,9 @@ int brcmf_mp_device_attach(struct brcmf_pub *drvr)
 	drvr->settings->feature_disable = brcmf_feature_disable;
 	drvr->settings->fcmode = brcmf_fcmode;
 	drvr->settings->roamoff = !!brcmf_roamoff;
-
+#ifdef DEBUG
+	drvr->settings->ignore_probe_fail = !!brcmf_ignore_probe_fail;
+#endif
 	return 0;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index abe3764..3b0a63b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -55,11 +55,24 @@ struct brcmf_mp_device {
 	int	feature_disable;
 	int	fcmode;
 	bool	roamoff;
+	bool	ignore_probe_fail;
 };
 
 void brcmf_mp_attach(void);
 int brcmf_mp_device_attach(struct brcmf_pub *drvr);
 void brcmf_mp_device_detach(struct brcmf_pub *drvr);
+#ifdef DEBUG
+static inline bool brcmf_ignoring_probe_fail(struct brcmf_pub *drvr)
+{
+	return drvr->settings->ignore_probe_fail;
+}
+#else
+static inline bool brcmf_ignoring_probe_fail(struct brcmf_pub *drvr)
+{
+	return false;
+}
+#endif
+
 /* Sets dongle media info (drv_version, mac address). */
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 3fa7bc5..7c75b1a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1183,6 +1183,8 @@ fail:
 			brcmf_net_detach(p2p_ifp->ndev);
 		drvr->iflist[0] = NULL;
 		drvr->iflist[1] = NULL;
+		if (brcmf_ignoring_probe_fail(drvr))
+			ret = 0;
 		return ret;
 	}
 	return 0;
-- 
1.9.1

