Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55184 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab3BXPlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 10:41:44 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: export firmware version to ethtool
Date: Sun, 24 Feb 2013 16:41:34 +0100
Message-Id: <1361720494-27131-1-git-send-email-hauke@hauke-m.de> (sfid-20130224_164148_710520_9B733551)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This exports the firmware version in use to userspace through ethtool.

root@OpenWrt:/# ethtool -i wlan0
firmware-version: 610.812

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d723e15..abd6eab 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7957,9 +7957,14 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
-		wlc->ucode_rev =
-		    brcms_b_read_shm(wlc->hw, M_BOM_REV_MAJOR) << NBITS(u16);
-		wlc->ucode_rev |= brcms_b_read_shm(wlc->hw, M_BOM_REV_MINOR);
+		u16 rev;
+		u16 patch;
+
+		rev = brcms_b_read_shm(wlc->hw, M_BOM_REV_MAJOR);
+		patch = brcms_b_read_shm(wlc->hw, M_BOM_REV_MINOR);
+		wlc->ucode_rev = (rev << NBITS(u16)) | patch;
+		snprintf(wlc->wiphy->fw_version,
+			 sizeof(wlc->wiphy->fw_version), "%u.%u", rev, patch);
 	}
 
 	/* ..now really unleash hell (allow the MAC out of suspend) */
-- 
1.7.10.4

