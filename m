Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35543 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdGZIhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 04:37:47 -0400
From: Daniel Stone <daniels@collabora.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: [PATCH] brcmfmac: Don't grow SKB by negative size
Date: Wed, 26 Jul 2017 09:37:42 +0100
Message-Id: <20170726083742.5420-1-daniels@collabora.com> (sfid-20170726_103750_962655_60E8F001)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit to rework the headroom check in start_xmit() now calls
pxskb_expand_head() unconditionally if the header is CoW. Unfortunately,
it does so with the delta between the extant headroom and the header
length, which may be negative if there is already sufficient headroom.

pskb_expand_head() does allow for size being 0, in which case it just
copies, so clamp the header delta to zero.

Opening Chrome (and all my tabs) on a PCIE device was enough to reliably
hit this.

Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
Signed-off-by: Daniel Stone <daniels@collabora.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: James Hughes <james.hughes@raspberrypi.org>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Hi,
It would be great to get this in to 4.13. Otherwise, just opening
Chrome is enough to take my machine down in ~5 seconds.

Cheers,
Daniel

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 2153e8062b4c..ee91a411918c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -214,7 +214,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 
 	/* Make sure there's enough writeable headroom */
 	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
-		head_delta = drvr->hdrlen - skb_headroom(skb);
+		head_delta = min(drvr->hdrlen - skb_headroom(skb), 0);
 
 		brcmf_dbg(INFO, "%s: insufficient headroom (%d)\n",
 			  brcmf_ifname(ifp), head_delta);
-- 
2.13.2
