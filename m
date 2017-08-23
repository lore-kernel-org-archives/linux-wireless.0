Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36839 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753634AbdHWKJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 06:09:02 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: davem@davemloft.net, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, kvalo@codeaurora.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 3/3 v2] net: netlink: constify genl_ops
Date: Wed, 23 Aug 2017 15:38:43 +0530
Message-Id: <1503482923-21640-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170823_120945_590739_07A18D84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

genl_ops are not supposed to change at runtime. All functions
working with genl_ops provided by <net/genetlink.h> work with
const genl_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
Changes in v2:
             Patch Subject was wrong.

 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 750949d..e48f0b2 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1217,7 +1217,7 @@ static int tipc_nl_compat_recv(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct genl_ops tipc_genl_compat_ops[] = {
+static const struct genl_ops tipc_genl_compat_ops[] = {
 	{
 		.cmd		= TIPC_GENL_CMD,
 		.doit		= tipc_nl_compat_recv,
-- 
1.9.1
