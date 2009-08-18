Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2563 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZHRDeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:34:18 -0400
Date: Mon, 17 Aug 2009 23:33:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1251: halt the embedded CPU before loading firmware
Message-ID: <20090818033356.GB524@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After initial power-up, the embedded cpu is usually halted.  However,
if we down the interface and only do a soft reset before bringing
the interface back up, it will still be running and the firmware
loading code will bail out.  This change halts the CPU before loading
the firmware, enabling a second call to wl1251_boot() to succeed
without a hard reset.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Hi Kalle,

Thoughts on this?  It fixes my remaining issue with warm card reset.
I think Android code does this in the firmware loader:

http://android.git.kernel.org/?p=platform/system/wlan/ti.git;a=blob;f=sta_dk_4_0_4_32/common/src/TNETW_Driver/FW_Transfer/HwInit/HwInit.c;h=e5cc2becdd2b9010903598fc56574776f6aeec8d;hb=HEAD#l291

 drivers/net/wireless/wl12xx/wl1251_boot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 592c3b5..452d748 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -465,6 +465,9 @@ int wl1251_boot(struct wl1251 *wl)
 	int ret = 0, minor_minor_e2_ver;
 	u32 tmp, boot_data;
 
+	/* halt embedded ARM CPU while loading firmware */
+	wl1251_reg_write32(wl, ACX_REG_ECPU_CONTROL, ECPU_CONTROL_HALT);
+
 	ret = wl1251_boot_soft_reset(wl);
 	if (ret < 0)
 		goto out;
-- 
1.6.2.5

-- 
Bob Copeland %% www.bobcopeland.com

