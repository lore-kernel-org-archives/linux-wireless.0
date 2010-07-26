Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38915
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab0GZUOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 16:14:49 -0400
Date: Mon, 26 Jul 2010 13:15:06 -0700 (PDT)
Message-Id: <20100726.131506.245381776.davem@davemloft.net>
To: netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: Make COMPAT_NETLINK_MESSAGES depend upon
 WEXT_CORE
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


WIRELESS_EXT is not the correct dependency.

Signed-off-by: David S. Miller <davem@davemloft.net>
---

Wireless folks, just FYI, I will commit this to net-next-2.6

 net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index b325094..e24fa08 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -32,7 +32,7 @@ config WANT_COMPAT_NETLINK_MESSAGES
 config COMPAT_NETLINK_MESSAGES
 	def_bool y
 	depends on COMPAT
-	depends on WIRELESS_EXT || WANT_COMPAT_NETLINK_MESSAGES
+	depends on WEXT_CORE || WANT_COMPAT_NETLINK_MESSAGES
 	help
 	  This option makes it possible to send different netlink messages
 	  to tasks depending on whether the task is a compat task or not. To
-- 
1.7.1.1

