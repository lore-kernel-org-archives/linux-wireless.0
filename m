Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36465 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdGJJwH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 05:52:07 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: iwlegacy: Constify attribute_group structures.
Date: Mon, 10 Jul 2017 15:21:42 +0530
Message-Id: <ec85da590a1239a98e24b696eb11e3cf1739fd4d.1499680248.git.arvind.yadav.cs@gmail.com> (sfid-20170710_115249_621334_ECCC61B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 5b51fba..de9b652 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4654,7 +4654,7 @@ static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, il4965_show_tx_power,
 	NULL
 };
 
-static struct attribute_group il_attribute_group = {
+static const struct attribute_group il_attribute_group = {
 	.name = NULL,		/* put in device directory */
 	.attrs = il_sysfs_entries,
 };
-- 
1.9.1
