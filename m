Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:55525 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab3H3QLB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 12:11:01 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: netdev@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Jiri Pirko <jiri@resnulli.us>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	libertas-dev@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH v2 net-next 1/9] net: etherdevice: add address inherit helper
Date: Fri, 30 Aug 2013 18:08:44 +0200
Message-Id: <1377878932-26881-2-git-send-email-bjorn@mork.no> (sfid-20130830_181111_156550_A8F2BA1B)
In-Reply-To: <1377878932-26881-1-git-send-email-bjorn@mork.no>
References: <1377878932-26881-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some etherdevices inherit their address from a parent or
master device. The addr_assign_type should be updated along
with the address in these cases.  Adding a helper function
to simplify this.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 include/linux/etherdevice.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index c623861..d8b5124 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -199,6 +199,21 @@ static inline void eth_hw_addr_random(struct net_device *dev)
 }
 
 /**
+ * eth_hw_addr_inherit - Copy dev_addr from another net_device
+ * @dst: pointer to net_device to copy dev_addr to
+ * @src: pointer to net_device to copy dev_addr from
+ *
+ * Copy the Ethernet address from one net_device to another along with
+ * the address attributes (addr_assign_type).
+ */
+static inline void eth_hw_addr_inherit(struct net_device *dst,
+				       struct net_device *src)
+{
+	dst->addr_assign_type = src->addr_assign_type;
+	memcpy(dst->dev_addr, src->dev_addr, ETH_ALEN);
+}
+
+/**
  * compare_ether_addr - Compare two Ethernet addresses
  * @addr1: Pointer to a six-byte array containing the Ethernet address
  * @addr2: Pointer other six-byte array containing the Ethernet address
-- 
1.7.10.4

