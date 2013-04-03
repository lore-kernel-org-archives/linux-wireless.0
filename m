Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4479 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760509Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/25] brcmfmac: add handler for credit map firmware
 events
Date: Wed, 3 Apr 2013 12:40:32 +0200
Message-ID: <1364985650-11719-8-git-send-email-arend@broadcom.com> (sfid-20130403_124309_424092_177FF976)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware signalling functionality needs the credit map firmware
events. This patch adds registration of a handler for this event.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 85fd0ec..542a971 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -197,6 +197,7 @@ struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
+	int fifo_credit[NL80211_NUM_ACS+1+1];
 };
 
 /**
@@ -346,6 +347,22 @@ do {								\
 #define brcmf_fws_unlock(drvr, flags) \
 	spin_unlock_irqrestore(&((drvr)->fws_spinlock), (flags))
 
+static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
+				       const struct brcmf_event_msg *e,
+				       void *data)
+{
+	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	int i;
+	ulong flags;
+	u8 *credits = data;
+
+	brcmf_fws_lock(ifp->drvr, flags);
+	for (i = 0; i < ARRAY_SIZE(fws->fifo_credit); i++)
+		fws->fifo_credit[i] = *credits++;
+	brcmf_fws_unlock(ifp->drvr, flags);
+	return 0;
+}
+
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
 	u32 tlv = 0;
@@ -370,6 +387,13 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		brcmf_err("failed to set bdcv2 tlv signaling\n");
 		goto fail;
 	}
+
+	if (brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
+				brcmf_fws_notify_credit_map)) {
+		brcmf_err("register credit map handler failed\n");
+		goto fail;
+	}
+
 	/* set linkage back */
 	drvr->fws->drvr = drvr;
 
-- 
1.7.10.4


