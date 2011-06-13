Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:46623 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab1FMJIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 05:08:35 -0400
Subject: [PATCH 1/2] ath6kl: export firmware version to user space
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 13 Jun 2011 12:08:28 +0300
Message-ID: <20110613090828.15210.72389.stgit@localhost6.localdomain6> (sfid-20110613_110838_166925_1B6BD4D6)
In-Reply-To: <20110613090350.15210.74545.stgit@localhost6.localdomain6>
References: <20110613090350.15210.74545.stgit@localhost6.localdomain6>
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

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index aa97efc..499b7a9 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4133,6 +4133,13 @@ ar6000_ready_event(void *devt, u8 *datap, u8 phyCap, u32 sw_ver, u32 abi_ver)
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

