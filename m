Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out21.biz.mail.alibaba.com ([205.204.114.132]:56991 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbaLXOrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 09:47:14 -0500
Message-ID: <549ACDD8.2090506@sunrus.com.cn> (sfid-20141224_154734_192352_0817382B)
Date: Wed, 24 Dec 2014 22:29:44 +0800
From: Chen Gang <gang.chen@sunrus.com.cn>
MIME-Version: 1.0
To: qca_vkondrat@qca.qualcomm.com, kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH next] drivers: net: wireless: ath: wil6210: debugfs: Use 'uint64_t'
 instead of 'cycles_t' to avoid warnings
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

do_div() checks the type strictly. 'cycles_t' may be 32-bit under quite
a few architectures (parisc, arm, avr32 ...). So use 'uint64_t' instead
of, the related warning (with allmodconfig undr parisc):

    CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
  In file included from arch/parisc/include/generated/asm/div64.h:1:0,
                   from include/linux/kernel.h:124,
                   from include/linux/list.h:8,
                   from include/linux/module.h:9,
                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
  drivers/net/wireless/ath/wil6210/debugfs.c: In function
‘wil_vring_debugfs_show’:
  include/asm-generic/div64.h:43:28: warning: comparison of distinct
pointer types lacks a cast
    (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
                              ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion
of macro ‘do_div’
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
  include/asm-generic/div64.h:44:18: warning: right shift count >= width
of type [-Wshift-count-overflow]
    if (likely(((n) >> 32) == 0)) {   \
                    ^
  include/linux/compiler.h:159:40: note: in definition of macro ‘likely’
   # define likely(x) __builtin_expect(!!(x), 1)
                                          ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion
of macro ‘do_div’
      do_div(idle, total);
      ^
  In file included from arch/parisc/include/generated/asm/div64.h:1:0,
                   from include/linux/kernel.h:124,
                   from include/linux/list.h:8,
                   from include/linux/module.h:9,
                   from drivers/net/wireless/ath/wil6210/debugfs.c:17:
  include/asm-generic/div64.h:48:22: warning: passing argument 1 of
‘__div64_32’ from incompatible pointer type [-Wincompatible-pointer-types]
     __rem = __div64_32(&(n), __base); \
                        ^
  drivers/net/wireless/ath/wil6210/debugfs.c:107:4: note: in expansion
of macro ‘do_div’
      do_div(idle, total);
      ^
  include/asm-generic/div64.h:35:17: note: expected ‘uint64_t * {aka
long long unsigned int *}’ but argument is of type ‘cycles_t * {aka long
unsigned int *}’
   extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
                   ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c
b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4e6e145..cd991fa 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -101,8 +101,8 @@ static int wil_vring_debugfs_show(struct seq_file
*s, void *data)
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
