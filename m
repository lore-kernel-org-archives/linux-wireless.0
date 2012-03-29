Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44801 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2C2KUW (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Thu, 29 Mar 2012 06:20:22 -0400
From: "Chen, Chien-Chia" <machen@suse.com>
To: IvDoorn@gmail.com, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Fix rfkill_polling register function.
Date: Thu, 29 Mar 2012 18:21:47 +0800
Message-Id: <1333016507-15241-1-git-send-email-machen@suse.com> (sfid-20120329_122026_710065_300C49B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Move rt2x00rfkill_register(rt2x00dev) to rt2x00lib_probe_dev
  function. It fixes of starting rfkill_poll function at the
  right time if sets hard rfkill block and reboot. rt2x00mac_rfkill_poll
  should be starting before bringing up the wireless interface.

Signed-off-by: Chen, Chien-Chia <machen@suse.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Kevin Chou <kevin.chou@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fc9901e..90cc5e7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1062,11 +1062,6 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 
 	set_bit(DEVICE_STATE_INITIALIZED, &rt2x00dev->flags);
 
-	/*
-	 * Register the extra components.
-	 */
-	rt2x00rfkill_register(rt2x00dev);
-
 	return 0;
 }
 
@@ -1210,6 +1205,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00link_register(rt2x00dev);
 	rt2x00leds_register(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
+	rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
 
-- 
1.7.3.4

