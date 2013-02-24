Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53975 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab3BXBHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:07:01 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 09/13] brcmsmac: write beacon period to hardware
Date: Sun, 24 Feb 2013 02:06:07 +0100
Message-Id: <1361667972-22909-10-git-send-email-hauke@hauke-m.de> (sfid-20130224_020710_832564_E0D0C5A6)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make brcms_c_set_beacon_period() write the beacon period to the
hardware if a new one is set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 44dc7ac..b993ddc 100644
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

