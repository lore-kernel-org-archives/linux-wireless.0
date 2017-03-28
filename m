Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41341 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1KoC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:44:02 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: wrap brcmf_fws_init into bcdc layer
Date: Tue, 28 Mar 2017 11:43:24 +0100
Message-Id: <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124744_160193_DEF2D286)
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Create a new protocol layer interface brcmf_proto_init_cb for protocol
layer to finish initialzation after core module components(fweh and
etc.) are initialized.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Change-Id: I560d2478a7c09766cf07b20d74b31dff5ca6ac7b
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8156
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 7 +++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 9 +++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 92eafcc..bc24b00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -417,6 +417,12 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 	brcmf_fws_reset_interface(ifp);
 }
 
+static int
+brcmf_proto_bcdc_init_done(struct brcmf_pub *drvr)
+{
+	return brcmf_fws_init(drvr);
+}
+
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_bcdc *bcdc;
@@ -443,6 +449,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 	drvr->proto->add_if = brcmf_proto_bcdc_add_if;
 	drvr->proto->del_if = brcmf_proto_bcdc_del_if;
 	drvr->proto->reset_if = brcmf_proto_bcdc_reset_if;
+	drvr->proto->init_done = brcmf_proto_bcdc_init_done;
 	drvr->proto->pd = bcdc;
 
 	drvr->hdrlen += BCDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 60c6c78..9886280 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -986,7 +986,7 @@ int brcmf_bus_started(struct device *dev)
 	}
 	brcmf_feat_attach(drvr);
 
-	ret = brcmf_fws_init(drvr);
+	ret = brcmf_proto_init_done(drvr);
 	if (ret < 0)
 		goto fail;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 3048ed5..600fd33 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -47,6 +47,7 @@ struct brcmf_proto {
 	void (*add_if)(struct brcmf_if *ifp);
 	void (*del_if)(struct brcmf_if *ifp);
 	void (*reset_if)(struct brcmf_if *ifp);
+	int (*init_done)(struct brcmf_pub *drvr);
 	void *pd;
 };
 
@@ -145,4 +146,12 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk_buff *skb)
 	drvr->proto->reset_if(ifp);
 }
 
+static inline int
+brcmf_proto_init_done(struct brcmf_pub *drvr)
+{
+	if (!drvr->proto->init_done)
+		return 0;
+	return drvr->proto->init_done(drvr);
+}
+
 #endif /* BRCMFMAC_PROTO_H */
-- 
1.9.1
