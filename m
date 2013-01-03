Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55924 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACIgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 03:36:37 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH] Re: (.text+0x114bfe): undefined reference to `ath_printk'
Date: Thu, 3 Jan 2013 10:36:33 +0200
Message-ID: <2738069.M9B5ZOSCVk@lx-vladimir> (sfid-20130103_093641_449000_65A215C6)
In-Reply-To: <50e4beed.U5yRtg02BE/adPiZ%fengguang.wu@intel.com>
References: <50e4beed.U5yRtg02BE/adPiZ%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 03, 2013 07:12:45 AM kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> head:   5439ca6b8ff8cf8d758c19eb28b617a5912904ee
> commit: 009b969632137f91534db91c19d62f1ae21ba8a0 wireless: fix Atheros drivers compilation
> date:   2 weeks ago
> config: i386-randconfig-b995 (attached as .config)
> 
> All error/warnings:
> 
> drivers/built-in.o: In function `ar9002_hw_rf_claim':
> (.text+0x114bfe): undefined reference to `ath_printk'
> 

Quick analysis shows I missed ATH9K_HTC. It is not sub-module for ATH9K as I assumed
by mistake, but independent module. Fix follows.


>From d4c750170d79952eaa9d46c8d1d35a79b31db012 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Thu, 3 Jan 2013 10:31:19 +0200
Subject: [PATCH] ath9k: Fix Kconfig for ATH9K_HTC

Ath9k consists of 2 different sub-modules: ATH9K and ATH9K_HTC.
Both uses common Atheros code from ath.ko and need ATH_COMMON.

However, while ATH9K selects ATH_COMMON, ATH9K_HTC does not.
As result, if ATH9K_HTC is the only Atheros card selected, compilation fails with
unresolved symbols.

This patch moves ATH_COMMON selection to the common part for both
ATH9K and ATH9K_HTC

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 5fc15bf..ef1c207 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -2,6 +2,7 @@ config ATH9K_HW
 	tristate
 config ATH9K_COMMON
 	tristate
+	select ATH_COMMON
 config ATH9K_DFS_DEBUGFS
 	def_bool y
 	depends on ATH9K_DEBUGFS && ATH9K_DFS_CERTIFIED
@@ -17,7 +18,6 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211
-	select ATH_COMMON
 	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
-- 
1.7.10.4


