Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1031 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2KFAWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/24] brcmfmac: fix build regression
Date: Mon, 5 Nov 2012 16:22:27 -0800
Message-ID: <1352161352-30405-20-git-send-email-frankyl@broadcom.com> (sfid-20121106_012315_313164_D2AA9268)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This fixes a build regression for x86_64 target that showed up
in 3.7-rc1 due to:

commit 1a87334239757b69eb9885979c32bbf871b3ec88
Author: Hante Meuleman <meuleman@broadcom.com>
Date:   Thu Sep 27 14:17:54 2012 +0200

    brcmfmac: add hostap supoort.

Reported-by: Yuanhan Liu <yuanhan.liu@intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4b5b475..228fcae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3515,7 +3515,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
 		 settings->channel_type, settings->beacon_interval,
 		 settings->dtim_period);
-	WL_TRACE("ssid=%s(%d), auth_type=%d, inactivity_timeout=%d\n",
+	WL_TRACE("ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
 		 settings->ssid, settings->ssid_len, settings->auth_type,
 		 settings->inactivity_timeout);
 
-- 
1.7.9.5


