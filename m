Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33986 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752703AbdHBR5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 13:57:39 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, harish.patil@cavium.com,
        manish.chopra@cavium.com, Dept-GELinuxNICDev@cavium.com
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/2] qlcnic: add const to bin_attribute structure
Date: Wed,  2 Aug 2017 23:27:14 +0530
Message-Id: <1501696634-15765-3-git-send-email-bhumirks@gmail.com> (sfid-20170802_195812_380402_A294850C)
In-Reply-To: <1501696634-15765-1-git-send-email-bhumirks@gmail.com>
References: <1501696634-15765-1-git-send-email-bhumirks@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add const to bin_attribute structure as it is only passed to the
functions sysfs_{remove/create}_bin_file. The corresponding
arguments are of type const, so declare the structure to be const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
index 73027a6..82fcb83 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
@@ -1248,7 +1248,7 @@ static ssize_t qlcnic_83xx_sysfs_flash_write_handler(struct file *filp,
 	.write = qlcnic_sysfs_write_pm_config,
 };
 
-static struct bin_attribute bin_attr_flash = {
+static const struct bin_attribute bin_attr_flash = {
 	.attr = {.name = "flash", .mode = (S_IRUGO | S_IWUSR)},
 	.size = 0,
 	.read = qlcnic_83xx_sysfs_flash_read_handler,
-- 
1.9.1
