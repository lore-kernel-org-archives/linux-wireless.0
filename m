Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34211 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2ADJlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 04:41:51 -0500
Subject: [PATCH] ath6kl: force building as a module
To: linville@tuxdriver.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2012 11:41:34 +0200
Message-ID: <20120104094134.28754.39652.stgit@x201> (sfid-20120104_104155_420277_80A23692)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen reported that ath6kl fails if both sdio and usb are built
into the kernel:

ath6kl/cfg80211.c:27:1: error: expected ')' before 'KBUILD_MODNAME'
ath6kl/cfg80211.c:27:1: error: 'KBUILD_MODNAME' undeclared here (not in a function)
ath6kl/cfg80211.c:27:1: error: expected ',' or ';' before string constant

As a temporary fix make ath6kl build only as a module. This will be reverted
once a separate ath6kl core module is implemented which will fix this
properly.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index d755a5e..d290ec7 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -6,6 +6,7 @@ config ATH6KL_SDIO
 	depends on ATH6KL
 	depends on MMC
 	depends on CFG80211
+	depends on m
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6003 and AR6004 chipsets running over SDIO. If you
@@ -19,6 +20,7 @@ config ATH6KL_USB
 	depends on USB
 	depends on CFG80211
 	depends on EXPERIMENTAL
+	depends on m
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6004 chipset running over USB. This is still under

