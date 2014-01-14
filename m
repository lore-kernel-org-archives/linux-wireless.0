Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3729 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaANSbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 13:31:39 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH] wil6210: correct #include for prefetch()
Date: Tue, 14 Jan 2014 20:31:26 +0200
Message-ID: <1389724286-12175-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140114_193142_913794_2B2ABC8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes bug found by the kbuild test robot:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   1e2f9295f4c657500111514f92a3d3894d0e05b4
commit: 1cbbcb08c786964a16773c39f2536f1923c73c58 [135/140] wil6210: prefetch head of packet
config: make ARCH=microblaze allyesconfig

All error/warnings:

   drivers/net/wireless/ath/wil6210/txrx.c: In function 'wil_vring_reap_rx':
>> drivers/net/wireless/ath/wil6210/txrx.c:381:2: error: implicit declaration of function 'prefetch' [-Werror=implicit-function-declaration]
     prefetch(skb->data);
     ^
   cc1: some warnings being treated as errors

vim +/prefetch +381 drivers/net/wireless/ath/wil6210/txrx.c

   375                  wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
   376                  kfree_skb(skb);
   377                  return NULL;
   378          }
   379          skb_trim(skb, dmalen);
   380
 > 381          prefetch(skb->data);
   382
   383          wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
   384                            skb->data, skb_headlen(skb), false);

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9b88440..0b0975d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -21,7 +21,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
-#include <asm/processor.h>
+#include <linux/prefetch.h>
 
 #include "wil6210.h"
 #include "wmi.h"
-- 
1.8.3.2

