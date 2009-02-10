Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:36255 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZBJR0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 12:26:39 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n1AHTftf028556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 17:29:43 GMT
Date: Tue, 10 Feb 2009 09:24:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, gregkh@suse.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187se: depends on WIRELESS_EXT
Message-Id: <20090210092449.1075249d.randy.dunlap@oracle.com> (sfid-20090210_182651_395586_5D9F949A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

rtl8187se uses wireless extensions so it needs to depend on
WIRELESS_EXT (or select it).

drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Greg KH <gregkh@suse.de>
---
 drivers/staging/rtl8187se/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090210.orig/drivers/staging/rtl8187se/Kconfig
+++ linux-next-20090210/drivers/staging/rtl8187se/Kconfig
@@ -1,5 +1,6 @@
 config RTL8187SE
 	tristate "RealTek RTL8187SE Wireless LAN NIC driver"
 	depends on PCI
+	depends on WIRELESS_EXT
 	default N
 	---help---
