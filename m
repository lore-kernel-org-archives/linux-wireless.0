Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3950 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/15] brcm80211: fmac: make sure cancel_work_sync only
 called after INIT_WORK
Date: Thu, 9 Feb 2012 21:09:01 +0100
Message-ID: <1328818149-4826-8-git-send-email-arend@broadcom.com> (sfid-20120209_210959_880588_A463D646)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

INIT_WORK only gets called after brcmf_proto_attach returns
success. This dependency should be annotated in brcmf_detach to
avoid any error.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index db2df1f..eff0073 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1109,13 +1109,13 @@ void brcmf_detach(struct device *dev)
 		if (drvr->iflist[i])
 			brcmf_del_if(drvr, i);
 
-	cancel_work_sync(&drvr->setmacaddr_work);
-	cancel_work_sync(&drvr->multicast_work);
-
 	brcmf_bus_detach(drvr);
 
-	if (drvr->prot)
+	if (drvr->prot) {
+		cancel_work_sync(&drvr->setmacaddr_work);
+		cancel_work_sync(&drvr->multicast_work);
 		brcmf_proto_detach(drvr);
+	}
 
 	bus_if->drvr = NULL;
 	kfree(drvr);
-- 
1.7.5.4


