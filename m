Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41457 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1KoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:44:21 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: no need for d11inf instance in brcmf_pno_start_sched_scan()
Date: Tue, 28 Mar 2017 11:43:28 +0100
Message-Id: <1490697808-5538-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124745_883678_AC40E948)
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_pno_start_sched_scan() a local variable is declared and
assigned for struct brcmu_d11inf. However, there is no other reference
to it so it is unnecessary.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 9a25e79..6c3bde8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -182,7 +182,6 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req)
 {
-	struct brcmu_d11inf *d11inf;
 	struct brcmf_pno_config_le pno_cfg;
 	struct cfg80211_ssid *ssid;
 	u16 chan;
@@ -209,7 +208,6 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	}
 
 	/* configure channels to use */
-	d11inf = &ifp->drvr->config->d11inf;
 	for (i = 0; i < req->n_channels; i++) {
 		chan = req->channels[i]->hw_value;
 		pno_cfg.channel_list[i] = cpu_to_le16(chan);
-- 
1.9.1
