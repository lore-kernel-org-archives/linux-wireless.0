Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:37709 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbYGHWuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 18:50:52 -0400
Date: Wed, 9 Jul 2008 01:11:59 +0300
From: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	andreamrl@tiscali.it
Subject: [PATCH] rtl8187: Fixed section mismatch in rtl8187_dev.c
Message-ID: <20080709011159.5b11550b@promwad.com> (sfid-20080709_005056_005012_4C73580A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_HOTPLUG=n the following error occures on vmlinux linkage:

`.exit.text' referenced in section `.data' of drivers/built-in.o:
defined in discarded section `.exit.text' of drivers/built-in.o

'rtl8187_disconnect' function marked as __devexit isn't compiled with no
hotplug support. Added __devexit_p macros to fix the problem.

Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>

---

 drivers/net/wireless/rtl8187_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c
b/drivers/net/wireless/rtl8187_dev.c index bec96d7..b70cc5d 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -836,7 +836,7 @@ static struct usb_driver rtl8187_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= rtl8187_table,
 	.probe		= rtl8187_probe,
-	.disconnect	= rtl8187_disconnect,
+	.disconnect	= __devexit_p(rtl8187_disconnect),
 };

 static int __init rtl8187_init(void)

--
Ihar Hrachyshka
Software Developer
Promwad Innovation Company
19, Sharangovicha Str.
220018, Minsk, Belarus
Phone/Fax: +375 (17) 211-5826
Web: www.promwad.com
