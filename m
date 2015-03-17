Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:48336 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbbCQMLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:11:19 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Daniel Kim <dekim@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] brcmfmac: cfg80211: use msecs_to_jiffies for time conversion
Date: Tue, 17 Mar 2015 08:06:12 -0400
Message-Id: <1426593972-17652-1-git-send-email-hofrat@osadl.org> (sfid-20150317_131138_455970_95E07ACB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Converting milliseconds to jiffies by "val * HZ / 1000" is technically
OK but msecs_to_jiffies(val) is the cleaner solution and handles all
corner cases correctly. This is a minor API consolidation only and
should make things more readable.

Patch was compile tested with x86_64_defconfig + CONFIG_BRCMFMAC=m

Patch is agianst 4.0-rc4 (localversion-next is -next-20150317)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 9b805c9..1996dc2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -1110,7 +1110,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 
 	/* Arm scan timeout timer */
 	mod_timer(&cfg->escan_timeout, jiffies +
-			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+		  msecs_to_jiffies(WL_ESCAN_TIMER_INTERVAL_MS));
 
 	return 0;
 
-- 
1.7.10.4

