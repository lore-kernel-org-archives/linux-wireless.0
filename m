Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:46534 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0KZX5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 18:57:48 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>,
	<linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] omap: zoom: wl1271 slot is MMC_CAP_POWER_OFF_CARD
Date: Sat, 27 Nov 2010 01:59:24 +0200
Message-Id: <1290815964-30088-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch complements ed919b0 "mmc: sdio: fix runtime PM anomalies by
introducing MMC_CAP_POWER_OFF_CARD" by declaring MMC_CAP_POWER_OFF_CARD
on the ZOOM's wl1271 mmc slot.

This is required in order not to break runtime PM support for the wl1271
sdio driver.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
Quick summary:

After adding SDIO runtime PM support, we realized there are some
board/host/card setups that are incapable of powering off the card
after boot. For details, see:
http://thread.gmane.org/gmane.linux.kernel.mmc/4342/focus=4579

As a result, we added MMC_CAP_POWER_OFF_CARD which should be explicitly set
by setups that _do_ support powering off the card.

This ensures we don't break existing functionality: SDIO core will enable
runtime PM for cards only if that cap is set.
As a result, the card will be powered down after boot, and will only
be powered up again when a driver is loaded (and then it's up to the
driver whether power will be kept or not).

To complement that fix (which was just merged upstream), we need this
patch too in 2.6.37, otherwise wl1271_sdio will break.

Pandora/Beagle wl12xx users: you need a similar patch as well, as this one
only takes care of ZOOM (I don't have those other setups and preferred not to
send a patch without testing).

 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 86c9b21..9db9203 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -216,7 +216,7 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 	{
 		.name		= "wl1271",
 		.mmc		= 3,
-		.caps		= MMC_CAP_4_BIT_DATA,
+		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
 		.gpio_wp	= -EINVAL,
 		.gpio_cd	= -EINVAL,
 		.nonremovable	= true,
-- 
1.7.0.4

