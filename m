Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4440 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3DYK3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 06:29:21 -0400
From: "Piotr Haber" <phaber@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org, "Piotr Haber" <phaber@broadcom.com>
Subject: [PATCH 3.9] brcmsmac: Fix merge issue
Date: Thu, 25 Apr 2013 12:27:09 +0200
Message-ID: <1366885629-11382-1-git-send-email-phaber@broadcom.com> (sfid-20130425_122927_694544_A2DE7D8C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7088f4835aa353f7226e57e73fd9e6564a4dfb75
"Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless"
ramoved call to brcms_led_unregister in mac80211_if.c

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 2346821..3a65447 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -336,6 +336,7 @@ static void brcms_remove(struct bcma_device *pdev)
 	struct brcms_info *wl = hw->priv;
 
 	if (wl->wlc) {
+		brcms_led_unregister(wl);
 		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
-- 
1.7.9.5


