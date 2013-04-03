Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4448 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760475Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 24/25] brcmfmac: no flow-control tlv signals when fcmode
 is NONE
Date: Wed, 3 Apr 2013 12:40:49 +0200
Message-ID: <1364985650-11719-25-git-send-email-arend@broadcom.com> (sfid-20130403_124305_000167_CD0C6E25)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fcmode provided by module parameter defaults to NONE, which
means no flow-control is required. In this case flow-control
signals should not be enabled.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 430baa2..22a6eb2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1221,16 +1221,12 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
-	u32 tlv = 0;
+	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
 	int rc;
 
 	if (!drvr->fw_signals)
 		return 0;
 
-	tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
-	      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
-	      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
-
 	spin_lock_init(&drvr->fws_spinlock);
 
 	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
@@ -1243,7 +1239,11 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	drvr->fws->drvr = drvr;
 	drvr->fws->fcmode = fcmode;
 
-	/* enable proptxtstatus signaling by default */
+	/* enable firmware signalling if fcmode active */
+	if (drvr->fws->fcmode != BRCMF_FWS_FCMODE_NONE)
+		tlv |= BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
+		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
+
 	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
 	if (rc < 0) {
 		brcmf_err("failed to set bdcv2 tlv signaling\n");
-- 
1.7.10.4


