Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41540 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbbCDLOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 06:14:53 -0500
Received: by widex7 with SMTP id ex7so29631784wid.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2015 03:14:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH next] bcma: make bcma_host_pci_(up|down) calls safe for every config
Date: Wed,  4 Mar 2015 12:14:41 +0100
Message-Id: <1425467681-15988-1-git-send-email-zajec5@gmail.com> (sfid-20150304_121456_989721_2FC7FE3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were providing declarations but actual code was compiled only with
CONFIG_BCMA_HOST_PCI set. This could result in:
ERROR: "bcma_host_pci_down" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
ERROR: "bcma_host_pci_up" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
ERROR: "bcma_host_pci_down" [drivers/net/wireless/b43/b43.ko] undefined!
ERROR: "bcma_host_pci_up" [drivers/net/wireless/b43/b43.ko] undefined!

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 037620b..44057b4 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -434,8 +434,17 @@ static inline struct bcma_device *bcma_find_core(struct bcma_bus *bus,
 	return bcma_find_core_unit(bus, coreid, 0);
 }
 
+#ifdef CONFIG_BCMA_HOST_PCI
 extern void bcma_host_pci_up(struct bcma_bus *bus);
 extern void bcma_host_pci_down(struct bcma_bus *bus);
+#else
+static inline void bcma_host_pci_up(struct bcma_bus *bus)
+{
+}
+static inline void bcma_host_pci_down(struct bcma_bus *bus)
+{
+}
+#endif
 
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
-- 
1.8.4.5

