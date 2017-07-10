Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34579 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbdGJJnT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 05:43:19 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: iwlegacy: constify attribute_group structures.
Date: Mon, 10 Jul 2017 15:12:53 +0530
Message-Id: <4333d7c1a2e0c5def85b1d0a42672499890f9f4c.1499679699.git.arvind.yadav.cs@gmail.com> (sfid-20170710_114417_442467_A2CC4C62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 38bf403..329f3a6 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3464,7 +3464,7 @@ static DEVICE_ATTR(antenna, S_IWUSR | S_IRUGO, il3945_show_antenna,
 	NULL
 };
 
-static struct attribute_group il3945_attribute_group = {
+static const struct attribute_group il3945_attribute_group = {
 	.name = NULL,		/* put in device directory */
 	.attrs = il3945_sysfs_entries,
 };
-- 
1.9.1
