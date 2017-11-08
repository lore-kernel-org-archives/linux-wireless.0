Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:36700 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752518AbdKHNgq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:36:46 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 4/7] brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
Date: Wed,  8 Nov 2017 14:36:34 +0100
Message-Id: <1510148197-17851-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171108_143705_978127_6C9D0345)
In-Reply-To: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend Van Spriel <arend.vanspriel@broadcom.com>

Minor cleanup using provided macro to convert milliseconds interval
to jiffies in brcmf_cfg80211_escan().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 1283798..afdf6bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1115,8 +1115,8 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 		goto scan_out;
 
 	/* Arm scan timeout timer */
-	mod_timer(&cfg->escan_timeout, jiffies +
-			BRCMF_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+	mod_timer(&cfg->escan_timeout,
+		  jiffies + msecs_to_jiffies(BRCMF_ESCAN_TIMER_INTERVAL_MS));
 
 	return 0;
 
-- 
1.9.1
