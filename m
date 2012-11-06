Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1152 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab2KFAWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:50 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 22/24] brcmfmac: on halting driver check before release
 or free.
Date: Mon, 5 Nov 2012 16:22:30 -0800
Message-ID: <1352161352-30405-23-git-send-email-frankyl@broadcom.com> (sfid-20121106_013118_542202_BBB79389)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_netdev_stop shall first check bus_if status before bringing
down cfg80211. brcmf_detach shall first check if driver is
allocated.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a0d8950..2bb1207 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -600,10 +600,12 @@ static int brcmf_netdev_stop(struct net_device *ndev)
 	struct brcmf_pub *drvr = ifp->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_cfg80211_down(drvr->config);
+
 	if (drvr->bus_if->drvr_up == 0)
 		return 0;
 
+	brcmf_cfg80211_down(drvr->config);
+
 	/* Set state and stop OS transmissions */
 	drvr->bus_if->drvr_up = false;
 	netif_stop_queue(ndev);
@@ -905,6 +907,8 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
+	if (drvr == NULL)
+		return;
 
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-- 
1.7.9.5


