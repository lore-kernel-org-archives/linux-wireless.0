Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55609 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 09/15] brcmsmac: write beacon period to hardware
Date: Sun, 24 Mar 2013 01:45:57 +0100
Message-Id: <1364085963-25940-10-git-send-email-hauke@hauke-m.de> (sfid-20130324_014823_762569_FD586531)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make brcms_c_set_beacon_period() write the beacon period to the
hardware if a new one is set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 7e19295..4ffb0c6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5551,10 +5551,20 @@ static void brcms_c_time_unlock(struct brcms_c_info *wlc)
 
 int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period)
 {
+	u32 bcnint_us;
+
 	if (period == 0)
 		return -EINVAL;
 
 	wlc->default_bss->beacon_period = period;
+
+	bcnint_us = period << 10;
+	brcms_c_time_lock(wlc);
+	bcma_write32(wlc->hw->d11core, D11REGOFFS(tsf_cfprep),
+		     (bcnint_us << CFPREP_CBI_SHIFT));
+	bcma_write32(wlc->hw->d11core, D11REGOFFS(tsf_cfpstart), bcnint_us);
+	brcms_c_time_unlock(wlc);
+
 	return 0;
 }
 
-- 
1.7.10.4

