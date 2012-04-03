Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:39129 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2DCBlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 21:41:03 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 2/4] rt2800: add disabling of DMA before loading firmware
Date: Tue,  3 Apr 2012 03:40:48 +0200
Message-Id: <1333417250-24560-3-git-send-email-kubakici@wp.pl> (sfid-20120403_034108_042328_4E4C6AEA)
In-Reply-To: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy driver disables DMA before loading firmware.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
rtmp_init_inf.c:186
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 8aee6d4..cc6ca18 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -426,6 +426,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
 	}
 
+	rt2800_disable_wpdma(rt2x00dev);
+
 	/*
 	 * Write firmware to the device.
 	 */
-- 
1.7.7.6

