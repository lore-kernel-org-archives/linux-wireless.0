Return-Path: <SRS0=Fguo=A3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEB1C433E5
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jul 2020 08:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDB02074B
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jul 2020 08:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgGPIyB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:54:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7862 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbgGPIyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jul 2020 04:54:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98C79304D547A792A00C;
        Thu, 16 Jul 2020 16:53:56 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 16:53:56 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kubakici@wp.pl>
CC:     <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] mt7601u: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 16:57:49 +0800
Message-ID: <20200716085749.11105-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 .../net/wireless/mediatek/mt7601u/debugfs.c   | 34 ++++---------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index eaabba20d..20669eacb 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -30,7 +30,7 @@ mt76_reg_get(void *data, u64 *val)
 DEFINE_DEBUGFS_ATTRIBUTE(fops_regval, mt76_reg_get, mt76_reg_set, "0x%08llx\n");
 
 static int
-mt7601u_ampdu_stat_read(struct seq_file *file, void *data)
+mt7601u_ampdu_stat_show(struct seq_file *file, void *data)
 {
 	struct mt7601u_dev *dev = file->private;
 	int i, j;
@@ -73,21 +73,10 @@ mt7601u_ampdu_stat_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt7601u_ampdu_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7601u_ampdu_stat_read, inode->i_private);
-}
-
-static const struct file_operations fops_ampdu_stat = {
-	.open = mt7601u_ampdu_stat_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7601u_ampdu_stat);
 
 static int
-mt7601u_eeprom_param_read(struct seq_file *file, void *data)
+mt7601u_eeprom_param_show(struct seq_file *file, void *data)
 {
 	struct mt7601u_dev *dev = file->private;
 	struct mt7601u_rate_power *rp = &dev->ee->power_rate_table;
@@ -131,18 +120,7 @@ mt7601u_eeprom_param_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt7601u_eeprom_param_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7601u_eeprom_param_read, inode->i_private);
-}
-
-static const struct file_operations fops_eeprom_param = {
-	.open = mt7601u_eeprom_param_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7601u_eeprom_param);
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 {
@@ -157,6 +135,6 @@ void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 
 	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
 	debugfs_create_file("regval", 0600, dir, dev, &fops_regval);
-	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
-	debugfs_create_file("eeprom_param", 0400, dir, dev, &fops_eeprom_param);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7601u_ampdu_stat_fops);
+	debugfs_create_file("eeprom_param", 0400, dir, dev, &mt7601u_eeprom_param_fops);
 }
-- 
2.17.1

