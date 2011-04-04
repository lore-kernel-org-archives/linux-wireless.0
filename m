Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39054 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1DDHSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 03:18:54 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p347IsUw001115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Apr 2011 02:18:54 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Set End-of-transaction Flag at Wl127x AP Mode
Date: Mon,  4 Apr 2011 10:20:39 +0300
Message-Id: <1301901639-19457-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

End-of-transaction flag should be set when working with
wl127x chip on AP mode.

Thanks Ido Yariv <ido@wizery.com> for the guidance with that.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..13f3442 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1006,6 +1006,10 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
+		/* end-of-transaction flag should be set in wl127x AP mode */
+		if (wl->bss_type == BSS_TYPE_AP_BSS)
+			wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
+
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
-- 
1.7.0.4

