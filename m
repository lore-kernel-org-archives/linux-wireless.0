Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34242 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaLXPIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 10:08:50 -0500
Message-ID: <549AD6FC.8060706@gmail.com> (sfid-20141224_160855_182552_088FDD30)
Date: Wed, 24 Dec 2014 23:08:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
MIME-Version: 1.0
To: qca_vkondrat@qca.qualcomm.com, kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: [PATCH next v2] drivers/net/wireless/ath/wil6210/debugfs.c: Use 'uint64_t'
 instead of 'cycles_t' to avoid warnings
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

do_div() checks the type strictly. 'cycles_t' may be 32-bit under quite
a few architectures (parisc, arm, avr32 ...). So use 'uint64_t' instead
of, the related warning (with allmodconfig under parisc):

    CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
  In file included from arch/parisc/include/generated/asm/div64.h:1:0,
                   from include/linux/kernel.h:124,
                   from include/linux/list.h:8,
                   from include/linux/module.h:9,
                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
  drivers/net/wireless/ath/wil6210/debugfs.c: In function ‘wil_vring_debugfs_show’:
  include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast
    (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
                              ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion of macro ‘do_div’
      do_div(idle, total);
      ^
  In file included from include/uapi/linux/stddef.h:1:0,
                   from include/linux/stddef.h:4,
                   from ./include/uapi/linux/posix_types.h:4,
                   from include/uapi/linux/types.h:13,
                   from include/linux/types.h:5,
                   from include/linux/list.h:4,
                   from include/linux/module.h:9,
                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
  include/asm-generic/div64.h:44:18: warning: right shift count >= width of type [-Wshift-count-overflow]
    if (likely(((n) >> 32) == 0)) {   \
                    ^
  include/linux/compiler.h:159:40: note: in definition of macro ‘likely’
   # define likely(x) __builtin_expect(!!(x), 1)
                                          ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion of macro ‘do_div’
      do_div(idle, total);
      ^
  In file included from arch/parisc/include/generated/asm/div64.h:1:0,
                   from include/linux/kernel.h:124,
                   from include/linux/list.h:8,
                   from include/linux/module.h:9,
                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
  include/asm-generic/div64.h:48:22: warning: passing argument 1 of ‘__div64_32’ from incompatible pointer type [-Wincompatible-pointer-types]
     __rem = __div64_32(&(n), __base); \
                        ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion of macro ‘do_div’
      do_div(idle, total);
      ^
  include/asm-generic/div64.h:35:17: note: expected ‘uint64_t * {aka long long unsigned int *}’ but argument is of type ‘cycles_t * {aka long unsigned int *}’
   extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
                   ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4e6e145..cd991fa 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -101,8 +101,8 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 			char name[10];
 			/* performance monitoring */
 			cycles_t now = get_cycles();
-			cycles_t idle = txdata->idle * 100;
-			cycles_t total = now - txdata->begin;
+			uint64_t idle = txdata->idle * 100;
+			uint64_t total = now - txdata->begin;
 
 			do_div(idle, total);
 			txdata->begin = now;
-- 
1.7.9.5
