Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2504 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3KFWHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:33 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: remove empty brcmf_proto_stop
Date: Wed, 6 Nov 2013 23:07:20 +0100
Message-ID: <1383775642-647-6-git-send-email-arend@broadcom.com> (sfid-20131106_230744_469971_5DABB4E7)
In-Reply-To: <1383775642-647-1-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

remove empty brcmf_proto_stop from protocol layer

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c   | 5 -----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c | 3 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h | 3 ---
 3 files changed, 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index dd85401..42aaf10 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -385,8 +385,3 @@ void brcmf_proto_detach(struct brcmf_pub *drvr)
 	kfree(drvr->prot);
 	drvr->prot = NULL;
 }
-
-void brcmf_proto_stop(struct brcmf_pub *drvr)
-{
-	/* Nothing to do for CDC */
-}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f4eeaa1..c34ca70 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1150,9 +1150,6 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr) {
-		/* Stop the protocol module */
-		brcmf_proto_stop(drvr);
-
 		/* Stop the bus module */
 		brcmf_bus_stop(drvr->bus_if);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index ef91798..0780fb7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -27,9 +27,6 @@ extern int brcmf_proto_attach(struct brcmf_pub *drvr);
 /* Unlink, frees allocated protocol memory (including brcmf_proto) */
 extern void brcmf_proto_detach(struct brcmf_pub *drvr);
 
-/* Stop protocol: sync w/dongle state. */
-extern void brcmf_proto_stop(struct brcmf_pub *drvr);
-
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
  */
-- 
1.8.1.3


