Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4366 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2CBV4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:12 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/7] brcm80211: fmac: remove firmware requests from
 init_module syscall
Date: Fri, 2 Mar 2012 22:55:49 +0100
Message-ID: <1330725351-3803-6-git-send-email-arend@broadcom.com> (sfid-20120302_225618_957286_7214300D)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As indicated in [1] on netdev mailing list drivers should not block
on the init_module() syscall. This patch defers the actual driver
registration to a workqueue so the init_module() syscall can complete
without delay.

[1] http://article.gmane.org/gmane.linux.network/217729/

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e734556..2a1e5ae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1181,7 +1181,7 @@ exit:
 }
 #endif				/* DEBUG */
 
-static int __init brcmfmac_init(void)
+static void brcmf_driver_init(struct work_struct *work)
 {
 #ifdef CONFIG_BRCMFMAC_SDIO
 	brcmf_sdio_init();
@@ -1189,11 +1189,21 @@ static int __init brcmfmac_init(void)
 #ifdef CONFIG_BRCMFMAC_USB
 	brcmf_usb_init();
 #endif
+}
+static DECLARE_WORK(brcmf_driver_work, brcmf_driver_init);
+
+static int __init brcmfmac_module_init(void)
+{
+	if (!schedule_work(&brcmf_driver_work))
+		return -EBUSY;
+
 	return 0;
 }
 
-static void __exit brcmfmac_exit(void)
+static void __exit brcmfmac_module_exit(void)
 {
+	cancel_work_sync(&brcmf_driver_work);
+
 #ifdef CONFIG_BRCMFMAC_SDIO
 	brcmf_sdio_exit();
 #endif
@@ -1202,5 +1212,5 @@ static void __exit brcmfmac_exit(void)
 #endif
 }
 
-module_init(brcmfmac_init);
-module_exit(brcmfmac_exit);
+module_init(brcmfmac_module_init);
+module_exit(brcmfmac_module_exit);
-- 
1.7.5.4


