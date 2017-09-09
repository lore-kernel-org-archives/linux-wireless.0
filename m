Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36313 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdIITad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 15:30:33 -0400
Received: by mail-pf0-f181.google.com with SMTP id e199so8831118pfh.3
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 12:30:33 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
Date: Sat,  9 Sep 2017 12:30:18 -0700
Message-Id: <20170909193020.19061-1-cernekee@chromium.org> (sfid-20170909_213037_442232_FED34112)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
the length of rxframe is validated.  This could lead to uninitialized
data being accessed (but not printed).  Since we already have a
perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
and ch.chspec is not modified by decchspec(), avoid the extra
assignment and use ch.chspec in the debug print.

Suggested-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


V1->V2: Clarify changelog re: whether the uninitialized data is printed.


diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 2ce675ab40ef..1c450c0727cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1853,7 +1853,6 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
-	u16 chanspec = be16_to_cpu(rxframe->chanspec);
 	struct brcmu_chan ch;
 	u8 *mgmt_frame;
 	u32 mgmt_frame_len;
@@ -1906,7 +1905,7 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len, 0);
 
 	brcmf_dbg(INFO, "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
-		  mgmt_frame_len, e->datalen, chanspec, freq);
+		  mgmt_frame_len, e->datalen, ch.chspec, freq);
 
 	return 0;
 }
-- 
2.14.1.581.gf28d330327-goog
