Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:15980 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758899AbYBOKsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 05:48:21 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] add macro for printing mac addresses
To: netdev@vger.kernel.org
Cc: jgarzik@pobox.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Fri, 15 Feb 2008 19:48:05 +0900
Message-ID: <20080215104804.9870.15722.stgit@one> (sfid-20080215_104829_866984_5F977706)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

is there any chance to include a macro like this for printing mac addresses?

its advantage is that it can be used without the need to declare buffers for
print_mac(), for example:

printk("mac address: " MAC_FMT, MAC_ADDR(addr));

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 include/linux/if_ether.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)


diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 5f92977..b9a6fb2 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -127,6 +127,15 @@ extern struct ctl_table ether_table[];
  *	Display a 6 byte device address (MAC) in a readable format.
  */
 #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
+
+#define MAC_ADDR(addr) \
+    ((unsigned char *)(addr))[0], \
+    ((unsigned char *)(addr))[1], \
+    ((unsigned char *)(addr))[2], \
+    ((unsigned char *)(addr))[3], \
+    ((unsigned char *)(addr))[4], \
+    ((unsigned char *)(addr))[5]
+
 extern char *print_mac(char *buf, const u8 *addr);
 #define DECLARE_MAC_BUF(var) char var[18] __maybe_unused
 

