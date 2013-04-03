Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4452 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 23/25] brcmfmac: only allocate firmware-signalling
 resources if required
Date: Wed, 3 Apr 2013 12:40:48 +0200
Message-ID: <1364985650-11719-24-git-send-email-arend@broadcom.com> (sfid-20130403_124307_568359_766FB4D4)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bail out of brcmf_fws_init() when no firmware-signalling is asked
for. Need to take this into account in brcmf_fws_deinit() as well.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    3 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c  |   14 +++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index d37620e..c82f3e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -982,8 +982,7 @@ void brcmf_detach(struct device *dev)
 	if (drvr->prot)
 		brcmf_proto_detach(drvr);
 
-	if (drvr->fws)
-		brcmf_fws_deinit(drvr);
+	brcmf_fws_deinit(drvr);
 
 	brcmf_debugfs_detach(drvr);
 	bus_if->drvr = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 8b09973..430baa2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1224,11 +1224,12 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	u32 tlv = 0;
 	int rc;
 
-	/* enable rssi signals */
-	if (drvr->fw_signals)
-		tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
-		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
-		      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
+	if (!drvr->fw_signals)
+		return 0;
+
+	tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
+	      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
+	      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
 
 	spin_lock_init(&drvr->fws_spinlock);
 
@@ -1277,6 +1278,9 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr)
 	struct brcmf_fws_info *fws = drvr->fws;
 	ulong flags;
 
+	if (!fws)
+		return;
+
 	/* cleanup */
 	brcmf_fws_lock(drvr, flags);
 	brcmf_fws_cleanup(fws, -1);
-- 
1.7.10.4


