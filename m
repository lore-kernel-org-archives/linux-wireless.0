Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1854 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3K2Ksf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:35 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 5/7] brcmfmac: remove empty brcmf_proto_stop
Date: Fri, 29 Nov 2013 11:48:17 +0100
Message-ID: <1385722099-5102-6-git-send-email-arend@broadcom.com> (sfid-20131129_114901_078682_451ABC58)
In-Reply-To: <1385722099-5102-1-git-send-email-arend@broadcom.com>
References: <1385722099-5102-1-git-send-email-arend@broadcom.com>
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
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c   |    5 -----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    3 ---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h |    3 ---
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
index 53c6e71..d633362 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -27,9 +27,6 @@ int brcmf_proto_attach(struct brcmf_pub *drvr);
 /* Unlink, frees allocated protocol memory (including brcmf_proto) */
 void brcmf_proto_detach(struct brcmf_pub *drvr);
 
-/* Stop protocol: sync w/dongle state. */
-void brcmf_proto_stop(struct brcmf_pub *drvr);
-
 /* Add any protocol-specific data header.
  * Caller must reserve prot_hdrlen prepend space.
  */
-- 
1.7.10.4


