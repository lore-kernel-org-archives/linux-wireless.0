Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35491 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbcHMDAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 23:00:13 -0400
Received: by mail-pf0-f180.google.com with SMTP id x72so1407707pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 20:00:13 -0700 (PDT)
From: Petri Gynther <pgynther@google.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, davem@davemloft.net, joe@perches.com,
	akarwar@marvell.com, Petri Gynther <pgynther@google.com>
Subject: [PATCH 1/2] etherdevice: add is_zero_ether_addr_unaligned()
Date: Fri, 12 Aug 2016 19:59:59 -0700
Message-Id: <1471057200-58166-1-git-send-email-pgynther@google.com> (sfid-20160813_050050_355197_C6FDDE9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a generic routine to test if possibly unaligned to u16
Ethernet address is a zero address.

If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set, use
slightly faster generic routine is_zero_ether_addr(),
otherwise use byte accesses.

This is v2 of the original patch:
[PATCH] Modify is_zero_ether_addr() to handle byte-aligned addresses

Per Joe's suggestion -- instead of modifying is_zero_ether_addr() --
add is_zero_ether_addr_unaligned() and use it where needed.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Petri Gynther <pgynther@google.com>
---
 include/linux/etherdevice.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 37ff4a6..f609691 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -105,6 +105,21 @@ static inline bool is_zero_ether_addr(const u8 *addr)
 }
 
 /**
+ * is_zero_ether_addr_unaligned - Determine if given Ethernet address is all zeros.
+ * @addr: Pointer to a six-byte array containing the Ethernet address
+ *
+ * Return true if the address is all zeroes.
+ */
+static inline bool is_zero_ether_addr_unaligned(const u8 *addr)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return is_zero_ether_addr(addr);
+#else
+	return (addr[0] | addr[1] | addr[2] | addr[3] | addr[4] | addr[5]) == 0;
+#endif
+}
+
+/**
  * is_multicast_ether_addr - Determine if the Ethernet address is a multicast.
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
-- 
2.8.0.rc3.226.g39d4020

