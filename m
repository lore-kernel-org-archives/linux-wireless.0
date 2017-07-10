Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34974 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753171AbdGJJXl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 05:23:41 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: ipw2200: constify attribute_group structures.
Date: Mon, 10 Jul 2017 14:53:15 +0530
Message-Id: <898c825b6cba0d86729678f7bb7e8d860e2f13e1.1499674387.git.arvind.yadav.cs@gmail.com> (sfid-20170710_112432_898336_4C1AC67B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 9368abd..c311b1a 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11500,7 +11500,7 @@ static int ipw_wdev_init(struct net_device *dev)
 	NULL
 };
 
-static struct attribute_group ipw_attribute_group = {
+static const struct attribute_group ipw_attribute_group = {
 	.name = NULL,		/* put in device directory */
 	.attrs = ipw_sysfs_entries,
 };
-- 
1.9.1
