Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.2.166]:44313 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab2ICT5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 15:57:44 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com, dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] libertas sdio: fix suspend when interface is down
Message-Id: <20120903194909.A878DFAA0A@dev.laptop.org> (sfid-20120903_215748_320081_56B5157C)
Date: Mon,  3 Sep 2012 15:49:09 -0400 (EDT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the interface is down, the hardware is powered off.
However, the suspend handler currently tries to send host sleep commands
(when wakeup params are set) in this configuration, causing a system hang
when going into suspend (the commands will never complete).

Avoid this by detecting this situation and simply returning from
the suspend handler without doing anything special.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index e970897..4cb2343 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1326,6 +1326,11 @@ static int if_sdio_suspend(struct device *dev)
 
 	mmc_pm_flag_t flags = sdio_get_host_pm_caps(func);
 
+	/* If we're powered off anyway, just let the mmc layer remove the
+	 * card. */
+	if (!lbs_iface_active(card->priv))
+		return -ENOSYS;
+
 	dev_info(dev, "%s: suspend: PM flags = 0x%x\n",
 		 sdio_func_id(func), flags);
 
-- 
1.7.11.4

