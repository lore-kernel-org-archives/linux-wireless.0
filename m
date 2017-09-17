Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:56782 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdIQEIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 00:08:31 -0400
Received: by mail-pg0-f48.google.com with SMTP id 7so3412809pgd.13
        for <linux-wireless@vger.kernel.org>; Sat, 16 Sep 2017 21:08:31 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH V3 1/3] brcmfmac: Avoid possible out-of-bounds read
Date: Sat, 16 Sep 2017 21:08:22 -0700
Message-Id: <20170917040824.22237-1-cernekee@chromium.org> (sfid-20170917_060836_561432_5F3A3885)
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


V2->V3: No change


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
2.14.1.690.gbb1197296e-goog
