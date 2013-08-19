Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:47345 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab3HSXL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 19:11:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: do not create AP and P2P interfaces upon driver loading
Date: Mon, 19 Aug 2013 16:10:21 -0700
Message-ID: <1376953821-32188-1-git-send-email-bzhao@marvell.com> (sfid-20130820_011203_826050_581A0D96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bug 60747 - 1286:2044 [Microsoft Surface Pro]
    Marvell 88W8797 wifi show 3 interface under network
https://bugzilla.kernel.org/show_bug.cgi?id=60747

This issue was also reported previously by OLPC and some folks from
the community.

There are 3 network interfaces with different types being created
when mwifiex driver is loaded:

1. mlan0 (infra. STA)
2. uap0 (AP)
3. p2p0 (P2P_CLIENT)

The Network Manager attempts to use all 3 interfaces above without
filtering the managed interface type. As the result, 3 identical
interfaces are displayed under network manager. If user happens to
click on an entry under which its interface is uap0 or p2p0, the
association will fail.

Work around it by removing the creation of AP and P2P interfaces
at driver loading time. These interfaces can be added with 'iw' or
other applications manually when they are needed.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3402bff..fd77833 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -477,20 +477,6 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		dev_err(adapter->dev, "cannot create default STA interface\n");
 		goto err_add_intf;
 	}
-
-	/* Create AP interface by default */
-	if (!mwifiex_add_virtual_intf(adapter->wiphy, "uap%d",
-				      NL80211_IFTYPE_AP, NULL, NULL)) {
-		dev_err(adapter->dev, "cannot create default AP interface\n");
-		goto err_add_intf;
-	}
-
-	/* Create P2P interface by default */
-	if (!mwifiex_add_virtual_intf(adapter->wiphy, "p2p%d",
-				      NL80211_IFTYPE_P2P_CLIENT, NULL, NULL)) {
-		dev_err(adapter->dev, "cannot create default P2P interface\n");
-		goto err_add_intf;
-	}
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
-- 
1.8.2.3

