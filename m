Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59422 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3DZR6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 13:58:40 -0400
Received: from aeonflux.amr.corp.intel.com (S010620c9d099deff.vc.shawcable.net [24.84.124.211])
	by mail.holtmann.org (Postfix) with ESMTPSA id BC0AF8B33C
	for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 19:58:38 +0200 (CEST)
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] NFC: Add missing RFKILL dependency for Kconfig
Date: Fri, 26 Apr 2013 10:58:34 -0700
Message-Id: <1366999114-26903-1-git-send-email-marcel@holtmann.org> (sfid-20130426_195847_673455_918A5BC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the NFC subsystem gained RFKILL support, it needs to be able
to build properly with whatever option for RFKILL has been selected.

on i386:

net/built-in.o: In function `nfc_unregister_device':
(.text+0x6a36d): undefined reference to `rfkill_unregister'
net/built-in.o: In function `nfc_unregister_device':
(.text+0x6a378): undefined reference to `rfkill_destroy'
net/built-in.o: In function `nfc_register_device':
(.text+0x6a493): undefined reference to `rfkill_alloc'
net/built-in.o: In function `nfc_register_device':
(.text+0x6a4a4): undefined reference to `rfkill_register'
net/built-in.o: In function `nfc_register_device':
(.text+0x6a4b3): undefined reference to `rfkill_destroy'
net/built-in.o: In function `nfc_dev_up':
(.text+0x6a8e8): undefined reference to `rfkill_blocked'

when CONFIG_RFKILL=m but NFC is builtin.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 net/nfc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 60c3bbb..28afdb1 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig NFC
 	depends on NET
+	depends on RFKILL || !RFKILL
 	tristate "NFC subsystem support"
 	default n
 	help
-- 
1.8.1.4

