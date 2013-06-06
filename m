Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1438 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab3FFLUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:20:03 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/22] brcmfmac: use credit mechanism for BC/MC if
 support by firmware
Date: Thu, 6 Jun 2013 13:18:04 +0200
Message-ID: <1370517487-14395-20-git-send-email-arend@broadcom.com> (sfid-20130606_132015_418948_236FB933)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware can sent an event indicating it supports the credit
mechanism for BC/MC traffic. This patch takes that into account.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   31 +++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 6ec5db9..e679214 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -101,7 +101,8 @@ struct brcmf_event;
 	BRCMF_ENUM_DEF(P2P_PROBEREQ_MSG, 72) \
 	BRCMF_ENUM_DEF(DCS_REQUEST, 73) \
 	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
-	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75)
+	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75) \
+	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127)
 
 #define BRCMF_ENUM_DEF(id, val) \
 	BRCMF_E_##id = (val),
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 5d809c7..b173311 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -426,6 +426,7 @@ struct brcmf_fws_info {
 	struct brcmf_fws_stats stats;
 	struct brcmf_fws_hanger hanger;
 	enum brcmf_fws_fcmode fcmode;
+	bool bcmc_credit_check;
 	struct brcmf_fws_macdesc_table desc;
 	struct workqueue_struct *fws_wq;
 	struct work_struct fws_dequeue_work;
@@ -1435,6 +1436,20 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 	return 0;
 }
 
+static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
+						const struct brcmf_event_msg *e,
+						void *data)
+{
+	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	ulong flags;
+
+	brcmf_fws_lock(ifp->drvr, flags);
+	if (fws)
+		fws->bcmc_credit_check = true;
+	brcmf_fws_unlock(ifp->drvr, flags);
+	return 0;
+}
+
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb)
 {
@@ -1803,6 +1818,12 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		  eh->h_dest, multicast, fifo);
 
 	brcmf_fws_lock(drvr, flags);
+	/* multicast credit support is conditional, setting
+	 * flag to false to assure credit is consumed below.
+	 */
+	if (fws->bcmc_credit_check)
+		multicast = false;
+
 	if (skcb->mac->suppressed ||
 	    fws->bus_flow_blocked ||
 	    brcmf_fws_mac_desc_closed(fws, skcb->mac, fifo) ||
@@ -1875,7 +1896,8 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 	brcmf_fws_lock(fws->drvr, flags);
 	for (fifo = NL80211_NUM_ACS; fifo >= 0 && !fws->bus_flow_blocked;
 	     fifo--) {
-		while (fws->fifo_credit[fifo]) {
+		while ((fws->fifo_credit[fifo]) || ((!fws->bcmc_credit_check) &&
+		       (fifo == BRCMF_FWS_FIFO_BCMC))) {
 			skb = brcmf_fws_deq(fws, fifo);
 			if (!skb)
 				break;
@@ -1944,6 +1966,13 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		brcmf_err("register credit map handler failed\n");
 		goto fail;
 	}
+	rc = brcmf_fweh_register(drvr, BRCMF_E_BCMC_CREDIT_SUPPORT,
+				 brcmf_fws_notify_bcmc_credit_support);
+	if (rc < 0) {
+		brcmf_err("register bcmc credit handler failed\n");
+		brcmf_fweh_unregister(drvr, BRCMF_E_FIFO_CREDIT_MAP);
+		goto fail;
+	}
 
 	/* setting the iovar may fail if feature is unsupported
 	 * so leave the rc as is so driver initialization can
-- 
1.7.10.4


