Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759426Ab1LPN7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 08:59:06 -0500
Date: Fri, 16 Dec 2011 15:03:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Subject: [PATCH] NFC: Fix LLCP related build failure
Message-ID: <20111216140336.GC11800@sortiz-mobl> (sfid-20111216_145911_523504_83CDB596)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


llcp_mac routines should be static and inlined or build will fail with NFC
selected without LLCP.

This patch fixes:

LD [M]  net/nfc/nfc.o
net/nfc/netlink.o: In function `nfc_llcp_mac_is_down':
netlink.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
net/nfc/core.o:(.text+0x0): first defined here
net/nfc/netlink.o: In function `nfc_llcp_mac_is_up':
netlink.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
net/nfc/core.o:(.text+0x10): first defined here
net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_down':
(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
net/nfc/core.o:(.text+0x0): first defined here
net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_up':
(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
net/nfc/core.o:(.text+0x10): first defined here
net/nfc/rawsock.o: In function `nfc_llcp_mac_is_down':
rawsock.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
net/nfc/core.o:(.text+0x0): first defined here
net/nfc/rawsock.o: In function `nfc_llcp_mac_is_up':
rawsock.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
net/nfc/core.o:(.text+0x10): first defined here

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
John, if you want to revert d646960f7986fefb460a2b062d5ccc8ccfeacc3a, I can
send you an updated one with that fix included. Let me know what you'd prefer.

---
 net/nfc/nfc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 2c2c401..6d28d75 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -60,11 +60,11 @@ void nfc_llcp_exit(void);
 
 #else
 
-void nfc_llcp_mac_is_down(struct nfc_dev *dev)
+static inline void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 {
 }
 
-void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
+static inline void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 			u8 comm_mode, u8 rf_mode)
 {
 }
-- 
1.7.7.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
