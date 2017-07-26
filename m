Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35587 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdGZIt2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 04:49:28 -0400
From: Daniel Stone <daniels@collabora.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: [PATCH v2] brcmfmac: Don't grow SKB by negative size
Date: Wed, 26 Jul 2017 09:49:24 +0100
Message-Id: <20170726084924.27546-1-daniels@collabora.com> (sfid-20170726_104935_027087_ACFCE7DB)
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
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

Really sorry, I forgot to re-run format-patch after fixing the initial
patch. I've run out of coffee. :(

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 2153e8062b4c..42dbd5a8c220 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -215,6 +215,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	/* Make sure there's enough writeable headroom */
 	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
 		head_delta = drvr->hdrlen - skb_headroom(skb);
+		head_delta = max(head_delta, 0);
 
 		brcmf_dbg(INFO, "%s: insufficient headroom (%d)\n",
 			  brcmf_ifname(ifp), head_delta);
-- 
2.13.2
