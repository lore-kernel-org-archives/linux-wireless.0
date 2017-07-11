Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34646 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755389AbdGKHd1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 03:33:27 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sgruszka@redhat.com, kvalo@codeaurora.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/10] wireless: iwlegacy: Constify attribute_group structures.
Date: Tue, 11 Jul 2017 13:02:50 +0530
Message-Id: <1499758370-24871-3-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170711_093529_914677_3CC291F9)
In-Reply-To: <1499758370-24871-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1499758370-24871-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_groups are not supposed to change at runtime. All functions
working with attribute_groups provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
Changes in v2:
              Added cover later.

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
