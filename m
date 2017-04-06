Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46773 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753424AbdDFMPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: rename brcmf_fws_{de,}init to brcmf_fws{at,de}tach
Date: Thu,  6 Apr 2017 13:14:37 +0100
Message-Id: <1491480882-13877-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141504_790377_25699EBA)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a non-functional change to align the fwsignal module to
the naming pattern used throughout the driver.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c     | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 24da627..9628084 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -420,7 +420,7 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 static int
 brcmf_proto_bcdc_init_done(struct brcmf_pub *drvr)
 {
-	return brcmf_fws_init(drvr);
+	return brcmf_fws_attach(drvr);
 }
 
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
@@ -464,7 +464,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
 {
-	brcmf_fws_deinit(drvr);
+	brcmf_fws_detach(drvr);
 	kfree(drvr->proto->pd);
 	drvr->proto->pd = NULL;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 5f1a592..c27a225 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2308,7 +2308,7 @@ static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
 }
 #endif
 
-int brcmf_fws_init(struct brcmf_pub *drvr)
+int brcmf_fws_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws;
 	struct brcmf_if *ifp;
@@ -2408,11 +2408,11 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	return 0;
 
 fail:
-	brcmf_fws_deinit(drvr);
+	brcmf_fws_detach(drvr);
 	return rc;
 }
 
-void brcmf_fws_deinit(struct brcmf_pub *drvr)
+void brcmf_fws_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws = drvr->fws;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index 96df660..d725158 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -18,8 +18,8 @@
 #ifndef FWSIGNAL_H_
 #define FWSIGNAL_H_
 
-int brcmf_fws_init(struct brcmf_pub *drvr);
-void brcmf_fws_deinit(struct brcmf_pub *drvr);
+int brcmf_fws_attach(struct brcmf_pub *drvr);
+void brcmf_fws_detach(struct brcmf_pub *drvr);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
 void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb);
-- 
1.9.1
