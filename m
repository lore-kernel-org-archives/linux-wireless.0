Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37709 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/16] brcmfmac: Add module parameter to disable features.
Date: Fri, 18 Sep 2015 22:08:15 +0200
Message-ID: <1442606899-31872-13-git-send-email-arend@broadcom.com> (sfid-20150918_220841_166472_5984CB17)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

For debugging purpose it is very handy to be able to disable
features. It has happened a few times that new features turned
out not always being properly detected for all devices/firmwares.
Making it possible to disable the feature with a module parameter
will make testing/debugging easier.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/feature.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 7c2135f..44bb306 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/module.h>
 
 #include <brcm_hw_ids.h>
 #include "core.h"
@@ -23,6 +24,12 @@
 #include "fwil.h"
 #include "feature.h"
 
+
+/* Module param feature_disable (global for all devices) */
+static int brcmf_feature_disable;
+module_param_named(feature_disable, brcmf_feature_disable, int, 0);
+MODULE_PARM_DESC(feature_disable, "Disable features");
+
 /*
  * expand feature list to array of feature strings.
  */
@@ -131,6 +138,12 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		brcmf_feat_iovar_int_set(ifp, BRCMF_FEAT_MBSS, "mbss", 0);
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_P2P, "p2p");
 
+	if (brcmf_feature_disable) {
+		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
+			  ifp->drvr->feat_flags, brcmf_feature_disable);
+		ifp->drvr->feat_flags &= ~brcmf_feature_disable;
+	}
+
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_43236_CHIP_ID:
-- 
1.9.1

