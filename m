Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32963 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbcGRXYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 19:24:54 -0400
Received: by mail-pf0-f195.google.com with SMTP id i6so121762pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 16:24:54 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
	hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 3/4] brcmsmac: Fix invalid memcpy() size in brcms_c_d11hdrs_mac80211
Date: Mon, 18 Jul 2016 16:24:36 -0700
Message-Id: <1468884277-18606-4-git-send-email-f.fainelli@gmail.com> (sfid-20160719_012457_991634_40641D5F)
In-Reply-To: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ieee80211_rts::ra is only ETH_ALEN wide, yet we attempt to copy 2
* ETH_ALEN, which will potentially overrun the destination buffer.

Reported-by: coverity (CID 145657)
Fixes: 5b435de0d7868 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index c2a938b59044..59813a3666eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -6671,7 +6671,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
 							 IEEE80211_STYPE_RTS);
 
-			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
+			memcpy(&rts->ra, &h->addr1, ETH_ALEN);
 		}
 
 		/* mainrate
-- 
2.7.4

