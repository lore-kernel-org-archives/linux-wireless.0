Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:37912 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756928AbdIHTOL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 15:14:11 -0400
Received: by mail-pg0-f41.google.com with SMTP id v66so6247699pgb.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 12:14:10 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH 1/3] brcmfmac: Avoid possible out-of-bounds read
Date: Fri,  8 Sep 2017 12:13:40 -0700
Message-Id: <20170908191342.28053-2-cernekee@chromium.org> (sfid-20170908_211422_918841_C8B9FC02)
In-Reply-To: <20170908191342.28053-1-cernekee@chromium.org>
References: <20170908191342.28053-1-cernekee@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
the length of rxframe is validated.  This could lead to uninitialized
data being printed in a debug message.  Since we already have a
perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
and ch.chspec is not modified by decchspec(), avoid the extra
assignment and use ch.chspec in the debug print.

Suggested-by: Mattias Nissler <mnissler@chromium.org>
Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
