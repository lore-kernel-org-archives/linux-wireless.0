Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4956 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/15] brcmfmac: pass ifp pointer in
 brcmf_fws_find_mac_desc()
Date: Thu, 11 Apr 2013 13:28:58 +0200
Message-ID: <1365679740-25679-14-git-send-email-arend@broadcom.com> (sfid-20130411_132935_560922_FFF59EF6)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of passing the ifidx and lookup the ifp inside the
function brcmf_fws_find_mac_desc() simply pass the ifp as
parameter.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index f8ee4dc..e26bbfd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -681,19 +681,16 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 }
 
 static struct brcmf_fws_mac_descriptor*
-brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
+brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
+			u8 *da)
 {
 	struct brcmf_fws_mac_descriptor *entry = &fws->desc.other;
-	struct brcmf_if *ifp;
 	bool multicast;
 	enum nl80211_iftype iftype;
-	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
 
-	multicast = is_multicast_ether_addr(da);
-	ifp = fws->drvr->iflist[ifidx ? ifidx + 1 : 0];
-	if (WARN_ON(!ifp))
-		goto done;
+	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
 
+	multicast = is_multicast_ether_addr(da);
 	iftype = brcmf_cfg80211_get_iftype(ifp);
 
 	/* Multicast destination and P2P clients get the interface entry.
@@ -1750,7 +1747,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	/* set control buffer information */
 	skcb->if_flags = 0;
-	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifidx, eh->h_dest);
+	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifp, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifidx);
 	if (!multicast)
-- 
1.7.10.4


