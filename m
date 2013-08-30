Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:55490 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab3H3QKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 12:10:22 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: netdev@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH v2 net-next 7/9] net: hostap: inherit addr_assign_type along with dev_addr
Date: Fri, 30 Aug 2013 18:08:50 +0200
Message-Id: <1377878932-26881-8-git-send-email-bjorn@mork.no> (sfid-20130830_181033_603932_05B38505)
In-Reply-To: <1377878932-26881-1-git-send-email-bjorn@mork.no>
References: <1377878932-26881-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A device inheriting a random or set address should reflect this in
its addr_assign_type.

Cc: Jouni Malinen <j@w1.fi>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/wireless/hostap/hostap_hw.c   |    2 +-
 drivers/net/wireless/hostap/hostap_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 6307a4e..c275dc1 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -1425,7 +1425,7 @@ static int prism2_hw_init2(struct net_device *dev, int initial)
 		}
 		list_for_each(ptr, &local->hostap_interfaces) {
 			iface = list_entry(ptr, struct hostap_interface, list);
-			memcpy(iface->dev->dev_addr, dev->dev_addr, ETH_ALEN);
+			eth_hw_addr_inherit(iface->dev, dev);
 		}
 	} else if (local->fw_ap)
 		prism2_check_sta_fw_version(local);
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index e4f56ad..a1257c9 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -66,7 +66,7 @@ struct net_device * hostap_add_interface(struct local_info *local,
 	list_add(&iface->list, &local->hostap_interfaces);
 
 	mdev = local->dev;
-	memcpy(dev->dev_addr, mdev->dev_addr, ETH_ALEN);
+	eth_hw_addr_inherit(dev, mdev);
 	dev->base_addr = mdev->base_addr;
 	dev->irq = mdev->irq;
 	dev->mem_start = mdev->mem_start;
-- 
1.7.10.4

