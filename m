Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:39742 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbbHZUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:19 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: change prototype for brcmf_fws_hdrpull()
Date: Wed, 26 Aug 2015 22:15:03 +0200
Message-ID: <1440620104-2715-12-git-send-email-arend@broadcom.com> (sfid-20150826_221528_828083_9CBDA870)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of passing ifidx and drvr just pass struct brcmf_if pointer
which holds both parameters.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  3 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 23 ++++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |  3 +--
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index aa5ed65..288c84e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -312,8 +312,7 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 
 	skb_pull(pktbuf, BCDC_HEADER_LEN);
 	if (do_fws)
-		brcmf_fws_hdrpull(drvr, tmp_if->ifidx, h->data_offset << 2,
-				  pktbuf);
+		brcmf_fws_hdrpull(tmp_if, h->data_offset << 2, pktbuf);
 	else
 		skb_pull(pktbuf, h->data_offset << 2);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index ed12486..086cac3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1616,11 +1616,10 @@ static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
 	return 0;
 }
 
-int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
-		      struct sk_buff *skb)
+void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb)
 {
 	struct brcmf_skb_reorder_data *rd;
-	struct brcmf_fws_info *fws = drvr->fws;
+	struct brcmf_fws_info *fws = ifp->drvr->fws;
 	u8 *signal_data;
 	s16 data_len;
 	u8 type;
@@ -1630,20 +1629,20 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	s32 err;
 
 	brcmf_dbg(HDRS, "enter: ifidx %d, skblen %u, sig %d\n",
-		  ifidx, skb->len, signal_len);
+		  ifp->ifidx, skb->len, siglen);
 
-	WARN_ON(signal_len > skb->len);
+	WARN_ON(siglen > skb->len);
 
-	if (!signal_len)
-		return 0;
+	if (!siglen)
+		return;
 	/* if flow control disabled, skip to packet data and leave */
 	if ((!fws) || (!fws->fw_signals)) {
-		skb_pull(skb, signal_len);
-		return 0;
+		skb_pull(skb, siglen);
+		return;
 	}
 
 	fws->stats.header_pulls++;
-	data_len = signal_len;
+	data_len = siglen;
 	signal_data = skb->data;
 
 	status = BRCMF_FWS_RET_OK_NOSCHEDULE;
@@ -1731,14 +1730,12 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	/* signalling processing result does
 	 * not affect the actual ethernet packet.
 	 */
-	skb_pull(skb, signal_len);
+	skb_pull(skb, siglen);
 
 	/* this may be a signal-only packet
 	 */
 	if (skb->len == 0)
 		fws->stats.header_only_pkt++;
-
-	return 0;
 }
 
 static u8 brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index 9fc8609..a36bac1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -21,8 +21,7 @@
 int brcmf_fws_init(struct brcmf_pub *drvr);
 void brcmf_fws_deinit(struct brcmf_pub *drvr);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
-int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
-		      struct sk_buff *skb);
+void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb);
 int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb);
 
 void brcmf_fws_reset_interface(struct brcmf_if *ifp);
-- 
1.9.1

