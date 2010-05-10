Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62151 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab0EJQZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 12:25:03 -0400
Date: Mon, 10 May 2010 09:24:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH] wireless: depends on NET
Message-Id: <20100510092429.a8ddcc8d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_NET is disabled, the attempt to build wext-priv.c
fails with:

net/wireless/wext-priv.c: In function 'ioctl_private_call':
net/wireless/wext-priv.c:207: error: implicit declaration of function 'call_commit_handler'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
Has this been omitted on purpose??

 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2634-rc7.orig/drivers/net/wireless/Kconfig
+++ lnx-2634-rc7/drivers/net/wireless/Kconfig
@@ -5,6 +5,7 @@
 menuconfig WLAN
 	bool "Wireless LAN"
 	depends on !S390
+	depends on NET
 	select WIRELESS
 	default y
 	---help---
