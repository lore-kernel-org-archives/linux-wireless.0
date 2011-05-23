Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34269 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1EWP73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 11:59:29 -0400
Subject: [PATCH] ath6kl: export firmware version to user space
To: gregkh@suse.de
From: Kalle Valo <kalle.valo@atheros.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 23 May 2011 18:52:37 +0300
Message-ID: <20110523155237.12512.49752.stgit@localhost6.localdomain6> (sfid-20110523_175932_822597_0D18DDD7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 exports wiphy->fw_version to user space via ethtool interface.

The obligatory screenshot:

$ sudo ethtool -i wlan0
driver: ath6kl_hifdev
version: 2.6.39-rc4+
firmware-version: 3:1:1:149
bus-info: mmc0:0001:1
$

Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 48dd9e3..30ae63b 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4114,6 +4114,13 @@ ar6000_ready_event(void *devt, u8 *datap, u8 phyCap, u32 sw_ver, u32 abi_ver)
     ar->arVersion.wlan_ver = sw_ver;
     ar->arVersion.abi_ver = abi_ver;
 
+    snprintf(ar->wdev->wiphy->fw_version, sizeof(ar->wdev->wiphy->fw_version),
+	     "%u:%u:%u:%u",
+	     (ar->arVersion.wlan_ver & 0xf0000000) >> 28,
+	     (ar->arVersion.wlan_ver & 0x0f000000) >> 24,
+	     (ar->arVersion.wlan_ver & 0x00ff0000) >> 16,
+	     (ar->arVersion.wlan_ver & 0x0000ffff));
+
     /* Indicate to the waiting thread that the ready event was received */
     ar->arWmiReady = true;
     wake_up(&arEvent);

