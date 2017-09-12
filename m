Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44622 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751320AbdILJWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
Date: Tue, 12 Sep 2017 11:22:20 +0200
Message-Id: <1505208143-30166-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_112251_350378_5DBCEB6E)
In-Reply-To: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 217160e..8e7717a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1126,8 +1126,8 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 		goto scan_out;
 
 	/* Arm scan timeout timer */
-	mod_timer(&cfg->escan_timeout, jiffies +
-			BRCMF_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+	mod_timer(&cfg->escan_timeout,
+		  jiffies + msecs_to_jiffies(BRCMF_ESCAN_TIMER_INTERVAL_MS));
 
 	return 0;
 
-- 
1.9.1
