Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:62235 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1168620AbdDXKw3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 06:52:29 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3OAnBAw011790
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 11:52:27 +0100
Received: from mail-wm0-f71.google.com (mail-wm0-f71.google.com [74.125.82.71])
        by mx07-00252a01.pphosted.com with ESMTP id 29yvjys19s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 11:52:27 +0100
Received: by mail-wm0-f71.google.com with SMTP id d79so4496112wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 03:52:27 -0700 (PDT)
From: James Hughes <james.hughes@raspberrypi.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Cc: James Hughes <james.hughes@raspberrypi.org>
Subject: [PATCH] brcmfmac: Ensure pointer correctly set if skb data location changes
Date: Mon, 24 Apr 2017 11:52:19 +0100
Message-Id: <20170424105219.18797-1-james.hughes@raspberrypi.org> (sfid-20170424_125238_993102_BA45BDB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The incoming skb header may be resized if header space is
insufficient, which might change the data adddress in the skb.
Ensure that a cached pointer to that data is correctly set by
moving assignment to after any possible changes.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 5eaac13e2317..934fe00e28a0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -198,7 +198,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
-	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	struct ethhdr *eh;
 
 	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -229,6 +229,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		}
 	}
 
+	eh = (struct ethhdr *)(skb->data);
+
 	/* validate length for ether packet */
 	if (skb->len < sizeof(*eh)) {
 		ret = -EINVAL;
-- 
2.11.0
