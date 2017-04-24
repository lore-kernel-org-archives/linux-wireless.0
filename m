Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:39904 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1171141AbdDXN0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 09:26:35 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3OD2p4L010465
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 14:03:34 +0100
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
        by mx08-00252a01.pphosted.com with ESMTP id 29yunf934j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 14:03:34 +0100
Received: by mail-wm0-f72.google.com with SMTP id d79so4682449wmi.8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 06:03:34 -0700 (PDT)
From: James Hughes <james.hughes@raspberrypi.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Cc: James Hughes <james.hughes@raspberrypi.org>
Subject: [PATCH v2] brcmfmac: Make skb header writable before use
Date: Mon, 24 Apr 2017 14:03:22 +0100
Message-Id: <20170424130322.476-1-james.hughes@raspberrypi.org> (sfid-20170424_152720_622085_F0B97E0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver was making changes to the skb_header without
ensuring it was writable (i.e. uncloned).
This patch also removes some boiler plate header size
checking/adjustment code as that is also handled by the
skb_cow_header function used to make header writable.

This patch depends on
brcmfmac: Ensure pointer correctly set if skb data location changes

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
---
Changes in v2
  Makes the _cow_ call at the entry point of the skb in to the
  stack, means only needs to be done once, and error handling
  is easier.
  Split a separate minor bug fix off to a separate patch (which
  this patch depends on)



 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c   | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9b7c19a508ac..88f8675a94c2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -211,22 +211,11 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	/* Make sure there's enough room for any header */
-	if (skb_headroom(skb) < drvr->hdrlen) {
-		struct sk_buff *skb2;
-
-		brcmf_dbg(INFO, "%s: insufficient headroom\n",
-			  brcmf_ifname(ifp));
-		drvr->bus_if->tx_realloc++;
-		skb2 = skb_realloc_headroom(skb, drvr->hdrlen);
+	/* Make sure there's enough room for any header, and make it writable */
+	if (skb_cow_head(skb, drvr->hdrlen)) {
 		dev_kfree_skb(skb);
-		skb = skb2;
-		if (skb == NULL) {
-			brcmf_err("%s: skb_realloc_headroom failed\n",
-				  brcmf_ifname(ifp));
-			ret = -ENOMEM;
-			goto done;
-		}
+		ret = -ENOMEM;
+		goto done;
 	}
 
 	/* validate length for ether packet */
-- 
2.11.0
