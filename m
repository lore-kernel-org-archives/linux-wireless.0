Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35900 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbdGZLDH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 07:03:07 -0400
From: Daniel Stone <daniels@collabora.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: [PATCH for-4.13 V3] brcmfmac: Don't grow SKB by negative size
Date: Wed, 26 Jul 2017 12:03:04 +0100
Message-Id: <20170726110304.12716-1-daniels@collabora.com> (sfid-20170726_130312_122721_F5EB5ACA)
In-Reply-To: <20170726084924.27546-1-daniels@collabora.com>
References: <20170726084924.27546-1-daniels@collabora.com>
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

v2: Correct thinko.
v3: Bring assignment on to one line.

Thanks for the quick response Arend. It's not quite as simple as the
form you suggested, since both hdrlen and skb_headroom() are unsigned,
so it needs need an explicit cast to signed, which was previously
implicit from the head_delta lvalue.

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 2153e8062b4c..0b7db8798214 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -214,7 +214,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 
 	/* Make sure there's enough writeable headroom */
 	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
-		head_delta = drvr->hdrlen - skb_headroom(skb);
+		head_delta = max((int) (drvr->hdrlen - skb_headroom(skb)), 0);
 
 		brcmf_dbg(INFO, "%s: insufficient headroom (%d)\n",
 			  brcmf_ifname(ifp), head_delta);
-- 
2.13.2
