Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4057 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/25] brcmfmac: move brcmf_fws_{de,}init() functions
Date: Wed, 3 Apr 2013 12:40:47 +0200
Message-ID: <1364985650-11719-23-git-send-email-arend@broadcom.com> (sfid-20130403_124308_461692_69E76443)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions are moved in preparation of later patches.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  136 ++++++++++----------
 1 file changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 6da9f82..8b09973 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -900,74 +900,6 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 	return 0;
 }
 
-int brcmf_fws_init(struct brcmf_pub *drvr)
-{
-	u32 tlv = 0;
-	int rc;
-
-	/* enable rssi signals */
-	if (drvr->fw_signals)
-		tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
-		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
-		      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
-
-	spin_lock_init(&drvr->fws_spinlock);
-
-	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
-	if (!drvr->fws) {
-		rc = -ENOMEM;
-		goto fail;
-	}
-
-	/* set linkage back */
-	drvr->fws->drvr = drvr;
-	drvr->fws->fcmode = fcmode;
-
-	/* enable proptxtstatus signaling by default */
-	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
-	if (rc < 0) {
-		brcmf_err("failed to set bdcv2 tlv signaling\n");
-		goto fail;
-	}
-
-	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
-				brcmf_fws_notify_credit_map)) {
-		brcmf_err("register credit map handler failed\n");
-		goto fail;
-	}
-
-	brcmf_fws_hanger_init(&drvr->fws->hanger);
-
-	/* create debugfs file for statistics */
-	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
-
-	/* TODO: remove upon feature delivery */
-	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
-		  drvr->fw_signals ? "enabled" : "disabled", tlv);
-	return 0;
-
-fail:
-	/* disable flow control entirely */
-	drvr->fw_signals = false;
-	brcmf_fws_deinit(drvr);
-	return rc;
-}
-
-void brcmf_fws_deinit(struct brcmf_pub *drvr)
-{
-	struct brcmf_fws_info *fws = drvr->fws;
-	ulong flags;
-
-	/* cleanup */
-	brcmf_fws_lock(drvr, flags);
-	brcmf_fws_cleanup(fws, -1);
-	drvr->fws = NULL;
-	brcmf_fws_unlock(drvr, flags);
-
-	/* free top structure */
-	kfree(fws);
-}
-
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb)
 {
@@ -1287,6 +1219,74 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	kfree(entry);
 }
 
+int brcmf_fws_init(struct brcmf_pub *drvr)
+{
+	u32 tlv = 0;
+	int rc;
+
+	/* enable rssi signals */
+	if (drvr->fw_signals)
+		tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
+		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
+		      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
+
+	spin_lock_init(&drvr->fws_spinlock);
+
+	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
+	if (!drvr->fws) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	/* set linkage back */
+	drvr->fws->drvr = drvr;
+	drvr->fws->fcmode = fcmode;
+
+	/* enable proptxtstatus signaling by default */
+	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
+	if (rc < 0) {
+		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		goto fail;
+	}
+
+	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
+				brcmf_fws_notify_credit_map)) {
+		brcmf_err("register credit map handler failed\n");
+		goto fail;
+	}
+
+	brcmf_fws_hanger_init(&drvr->fws->hanger);
+
+	/* create debugfs file for statistics */
+	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
+
+	/* TODO: remove upon feature delivery */
+	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
+		  drvr->fw_signals ? "enabled" : "disabled", tlv);
+	return 0;
+
+fail:
+	/* disable flow control entirely */
+	drvr->fw_signals = false;
+	brcmf_fws_deinit(drvr);
+	return rc;
+}
+
+void brcmf_fws_deinit(struct brcmf_pub *drvr)
+{
+	struct brcmf_fws_info *fws = drvr->fws;
+	ulong flags;
+
+	/* cleanup */
+	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_cleanup(fws, -1);
+	drvr->fws = NULL;
+	brcmf_fws_unlock(drvr, flags);
+
+	/* free top structure */
+	kfree(fws);
+}
+
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 {
 	if (!fws)
-- 
1.7.10.4


