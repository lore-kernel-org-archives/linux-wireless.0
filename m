Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754345AbdDKJT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 05:19:56 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: force driver to be built as a module
Date: Tue, 11 Apr 2017 11:19:53 +0200
Message-Id: <20170411091953.25069-1-hdegoede@redhat.com> (sfid-20170411_112112_996517_B060ACB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8188eu driver defines a ton of global symbols which tend to
conflict with other realtek wifi drivers, force it to be built as
a module.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/rtl8188eu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/Kconfig b/drivers/staging/rtl8188eu/Kconfig
index 94f3879..cb836c5 100644
--- a/drivers/staging/rtl8188eu/Kconfig
+++ b/drivers/staging/rtl8188eu/Kconfig
@@ -1,6 +1,7 @@
 config R8188EU
 	tristate "Realtek RTL8188EU Wireless LAN NIC driver"
 	depends on WLAN && USB && CFG80211
+	depends on m
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	---help---
-- 
2.9.3
