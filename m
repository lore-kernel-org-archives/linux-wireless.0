Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36483 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdGRJpp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 05:45:45 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: davem@davemloft.net, stas.yakovlev@gmail.com, kvalo@codeaurora.org,
        sgruszka@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 06/10] wireless: iwlegacy: constify attribute_group structures.
Date: Tue, 18 Jul 2017 15:15:01 +0530
Message-Id: <1500371102-14758-3-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170718_114735_934529_BD749350)
In-Reply-To: <1500371102-14758-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1500371102-14758-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_group are not supposed to change at runtime. All functions
working with attribute_group provided by <linux/sysfs.h> work
with const attribute_group. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
Changes in v2:
              Added cover later.
Changes in v3:
              net-next was closed. Now resubmitting it.

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
