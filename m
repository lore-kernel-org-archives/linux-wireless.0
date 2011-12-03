Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50333 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1LCOrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:47:02 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/6] compat-wireless: fix brcm80211 driver-select
Date: Sat,  3 Dec 2011 15:46:24 +0100
Message-Id: <1322923585-13966-5-git-send-email-hauke@hauke-m.de> (sfid-20111203_154706_590419_542D9C55)
In-Reply-To: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
References: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/driver-select |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index e74dc81..f8ca02f 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -396,14 +396,14 @@ case $1 in
 	brcmsmac)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_drivers		CONFIG_BRCMUTIL CONFIG_BRCMFMAC
-		select_brcm80211_driver	CONFIG_BRCMSMAC
+		select_drivers		CONFIG_BRCMSMAC
+		select_brcm80211_driver	CONFIG_BRCMSMAC CONFIG_BRCMUTIL
 		;;
 	brcmfmac)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_drivers		CONFIG_BRCMUTIL CONFIG_BRCMFMAC
-		select_brcm80211_driver	CONFIG_BRCMFMAC
+		select_drivers		CONFIG_BRCMFMAC
+		select_brcm80211_driver	CONFIG_BRCMFMAC CONFIG_BRCMUTIL
 		;;
 	zd1211rw)
 		select_driver		CONFIG_COMPAT_ZD1211RW
-- 
1.7.5.4

