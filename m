Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34184 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbcI0MLQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:11:16 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 4.9] brcmfmac: use correct skb freeing helper when deleting flowring
Date: Tue, 27 Sep 2016 14:11:04 +0200
Message-Id: <20160927121104.5771-1-zajec5@gmail.com> (sfid-20160927_141121_744858_8648FD4E)
In-Reply-To: <20160927091428.19223-1-zajec5@gmail.com>
References: <20160927091428.19223-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Flowrings contain skbs waiting for transmission that were passed to us
by netif. It means we checked every one of them looking for 802.1x
Ethernet type. When deleting flowring we have to use freeing function
that will check for 802.1x type as well.

Freeing skbs without a proper check was leading to counter not being
properly decreased. This was triggering a WARNING every time
brcmf_netdev_wait_pend8021x was called.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org # 4.5+
---
V2: Add Cc for stable 4.5+. It doesn't apply cleanly to 4.4 and is not
    possible for 4.3- due to missing brcmf_get_ifp.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index b16b367..d0b738d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -234,13 +234,20 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
 
 void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 {
+	struct brcmf_bus *bus_if = dev_get_drvdata(flow->dev);
 	struct brcmf_flowring_ring *ring;
+	struct brcmf_if *ifp;
 	u16 hash_idx;
+	u8 ifidx;
 	struct sk_buff *skb;
 
 	ring = flow->rings[flowid];
 	if (!ring)
 		return;
+
+	ifidx = brcmf_flowring_ifidx_get(flow, flowid);
+	ifp = brcmf_get_ifp(bus_if->drvr, ifidx);
+
 	brcmf_flowring_block(flow, flowid, false);
 	hash_idx = ring->hash_id;
 	flow->hash[hash_idx].ifidx = BRCMF_FLOWRING_INVALID_IFIDX;
@@ -249,7 +256,7 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 
 	skb = skb_dequeue(&ring->skblist);
 	while (skb) {
-		brcmu_pkt_buf_free_skb(skb);
+		brcmf_txfinalize(ifp, skb, false);
 		skb = skb_dequeue(&ring->skblist);
 	}
 
-- 
2.9.3
