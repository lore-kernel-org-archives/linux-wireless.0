Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3227 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3KFWHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:39 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: start netif queues only when setup is
 completed successful
Date: Wed, 6 Nov 2013 23:07:19 +0100
Message-ID: <1383775642-647-5-git-send-email-arend@broadcom.com> (sfid-20131106_230756_250076_5A071300)
In-Reply-To: <1383775642-647-1-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving the call to netif_start_queue() after brcmf_cfg80211_up() is
completed successful. If not return -EIO instead of -1 as that results
in 'Operation not permitted' which can put user on wrong track.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index ab207e2..f4eeaa1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -769,7 +769,6 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_bus *bus_if = drvr->bus_if;
 	u32 toe_ol;
-	s32 ret = 0;
 
 	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
@@ -788,14 +787,14 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	else
 		ndev->features &= ~NETIF_F_IP_CSUM;
 
-	/* Allow transmit calls */
-	netif_start_queue(ndev);
 	if (brcmf_cfg80211_up(ndev)) {
 		brcmf_err("failed to bring up cfg80211\n");
-		return -1;
+		return -EIO;
 	}
 
-	return ret;
+	/* Allow transmit calls */
+	netif_start_queue(ndev);
+	return 0;
 }
 
 static const struct net_device_ops brcmf_netdev_ops_pri = {
-- 
1.8.1.3


