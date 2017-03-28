Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41336 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1KoU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:44:20 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/5] brcmfmac: move brcmf_fws_deinit to bcdc layer
Date: Tue, 28 Mar 2017 11:43:25 +0100
Message-Id: <1490697808-5538-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124745_312152_098F3E83)
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Move brcmf_fws_deinit into brcmf_proto_bcdc_detach since it is a bcdc
exclusive feature.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Change-Id: Iefa5db632b92185a49d538b1cd25b7d8be618ce0
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8157
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index bc24b00..67a132c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -464,6 +464,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
 {
+	brcmf_fws_deinit(drvr);
 	kfree(drvr->proto->pd);
 	drvr->proto->pd = NULL;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9886280..ba4da48 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -32,7 +32,6 @@
 #include "p2p.h"
 #include "cfg80211.h"
 #include "fwil.h"
-#include "fwsignal.h"
 #include "feature.h"
 #include "proto.h"
 #include "pcie.h"
@@ -1034,10 +1033,6 @@ int brcmf_bus_started(struct device *dev)
 		brcmf_cfg80211_detach(drvr->config);
 		drvr->config = NULL;
 	}
-	if (drvr->fws) {
-		brcmf_proto_del_if(ifp->drvr, ifp);
-		brcmf_fws_deinit(drvr);
-	}
 	brcmf_net_detach(ifp->ndev, false);
 	if (p2p_ifp)
 		brcmf_net_detach(p2p_ifp->ndev, false);
@@ -1103,8 +1098,6 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_cfg80211_detach(drvr->config);
 
-	brcmf_fws_deinit(drvr);
-
 	brcmf_bus_stop(drvr->bus_if);
 
 	brcmf_proto_detach(drvr);
-- 
1.9.1
