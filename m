Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31791 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600AbaFTHFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 03:05:44 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH] wil6210: fix for 64-bit integer division
Date: Fri, 20 Jun 2014 10:05:07 +0300
Message-ID: <1403247907-4026-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140620_090547_846275_A94090DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms, cycles_t is 64-bit, and gcc generates call to
__udivdi3 for straight division of cycles_t/cycles_t. This leads
to compilation failure, as this function is not exist in the kernel
runtime. do_div() to rescue

Original report:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   2e91606f5e1ec7329557dfc0e298c4c021acbb80
commit: 7c0acf868d2e470c9d6a40091acf8d6444c01b57 [81/103] wil6210: Tx performance monitoring
config: i386-randconfig-ha3-0620 (attached as .config)

All error/warnings:

   drivers/built-in.o: In function `wil_vring_debugfs_show':
>> debugfs.c:(.text+0x39b9be): undefined reference to `__udivdi3'

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 7d1ef4e..a868c5e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -83,9 +83,10 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 			char name[10];
 			/* performance monitoring */
 			cycles_t now = get_cycles();
-			cycles_t idle = txdata->idle;
+			cycles_t idle = txdata->idle * 100;
 			cycles_t total = now - txdata->begin;
 
+			do_div(idle, total);
 			txdata->begin = now;
 			txdata->idle = 0ULL;
 
@@ -93,7 +94,7 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 
 			seq_printf(s, "\n%pM CID %d TID %d [%3d|%3d] idle %3d%%\n",
 				   wil->sta[cid].addr, cid, tid, used, avail,
-				   (int)((idle*100)/total));
+				   (int)idle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
-- 
1.9.1

