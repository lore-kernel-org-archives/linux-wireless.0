Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4440 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 07/24] brcmfmac: handle exceptions in brcmf_bus_start
 correct.
Date: Mon, 5 Nov 2012 16:22:15 -0800
Message-ID: <1352161352-30405-8-git-send-email-frankyl@broadcom.com> (sfid-20121106_012312_191881_795A0A15)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On exception during brcmf_bus_start the netdev should be freed,
if already allocated.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b130f20..9e2451f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -708,7 +708,6 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 
 fail:
 	ndev->netdev_ops = NULL;
-	free_netdev(ndev);
 	return -EBADE;
 }
 
@@ -858,15 +857,21 @@ int brcmf_bus_start(struct device *dev)
 	/* Bus is ready, do any initialization */
 	ret = brcmf_c_preinit_dcmds(ifp);
 	if (ret < 0)
-		return ret;
+		goto fail;
 
 	drvr->config = brcmf_cfg80211_attach(drvr);
-	if (drvr->config == NULL)
-		return -ENOMEM;
+	if (drvr->config == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	ret = brcmf_net_attach(ifp);
+fail:
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "brcmf_net_attach failed");
+		if (drvr->config)
+			brcmf_cfg80211_detach(drvr->config);
+		free_netdev(drvr->iflist[0]->ndev);
 		drvr->iflist[0] = NULL;
 		return ret;
 	}
-- 
1.7.9.5


