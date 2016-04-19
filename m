Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbcDSObH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 10:31:07 -0400
MIME-Version: 1.0
Message-ID: <20160419142543.GC4876@mwanda> (sfid-20160419_163112_549298_CCB5012E)
Date: Tue, 19 Apr 2016 07:25:43 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmfmac: testing the wrong variable in brcmf_rx_hdrpull()
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains about this code:

    drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:335 brcmf_rx_hdrpull()
    error: we previously assumed '*ifp' could be null (see line 333)

The problem is that we recently changed these from "ifp" to "*ifp" but
there was one that we didn't update.

-       if (ret || !ifp || !ifp->ndev) {
+       if (ret || !(*ifp) || !(*ifp)->ndev) {
                if (ret != -ENODATA && ifp)
                                       ^^^
-                       ifp->stats.rx_errors++;
+                       (*ifp)->stats.rx_errors++;

I have updated it to *ifp as well.  We always call this function is a
non-NULL "ifp" pointer, btw.

Fixes: c462ebcdfe42 ('brcmfmac: create common function for handling brcmf_proto_hdrpull()')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 1b476d1..b590499 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -331,7 +331,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	ret = brcmf_proto_hdrpull(drvr, true, skb, ifp);
 
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
-		if (ret != -ENODATA && ifp)
+		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
 		return -ENODATA;
