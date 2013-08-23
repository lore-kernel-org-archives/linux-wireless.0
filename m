Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:40790 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3HWJgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:36:11 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: netdev@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH net-next 06/10] net: airo: inherit addr_assign_type along with dev_addr
Date: Fri, 23 Aug 2013 11:35:09 +0200
Message-Id: <1377250513-3662-7-git-send-email-bjorn@mork.no> (sfid-20130823_113621_814705_79B8FD80)
In-Reply-To: <1377250513-3662-1-git-send-email-bjorn@mork.no>
References: <1377250513-3662-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/wireless/airo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index d0adbaf..7fe1964 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2693,7 +2693,7 @@ static struct net_device *init_wifidev(struct airo_info *ai,
 	dev->base_addr = ethdev->base_addr;
 	dev->wireless_data = ethdev->wireless_data;
 	SET_NETDEV_DEV(dev, ethdev->dev.parent);
-	memcpy(dev->dev_addr, ethdev->dev_addr, dev->addr_len);
+	eth_hw_addr_inherit(dev, ethdev);
 	err = register_netdev(dev);
 	if (err<0) {
 		free_netdev(dev);
-- 
1.7.10.4

