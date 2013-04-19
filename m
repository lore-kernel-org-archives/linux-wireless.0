Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47287 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967698Ab3DSCOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 22:14:32 -0400
Received: by mail-bk0-f51.google.com with SMTP id y8so1550208bkt.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 19:14:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Apr 2013 10:14:31 +0800
Message-ID: <CAPgLHd8KiH+BGZJ704yk2ZsiVQC8GH4FUZhC-_rstdoaA4BOaA@mail.gmail.com> (sfid-20130419_041437_259219_3B4E3CC7)
Subject: [PATCH -next] brcmfmac: fix potential NULL pointer dereference in brcmf_fws_flow_control_check()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linville@tuxdriver.com,
	pieterpg@broadcom.com, phaber@broadcom.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'ifp' in debug code should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1bcd58c..69d5ad2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -821,11 +821,12 @@ brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 {
 	struct brcmf_if *ifp = fws->drvr->iflist[if_id];
 
-	brcmf_dbg(TRACE,
-		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
 	if (WARN_ON(!ifp))
 		return;
 
+	brcmf_dbg(TRACE,
+		  "enter: bssidx=%d, ifidx=%d\n", ifp->bssidx, ifp->ifidx);
+
 	if ((ifp->netif_stop & BRCMF_NETIF_STOP_REASON_FWS_FC) &&
 	    pq->len <= BRCMF_FWS_FLOWCONTROL_LOWATER)
 		brcmf_txflowblock_if(ifp,

