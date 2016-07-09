Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 51.23-broadband.acttv.in ([106.51.23.179]:21157 "EHLO
	arvind-ThinkPad-Edge-E431" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933094AbcGIRBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 13:01:43 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: zajec5@gmail.com
Cc: viresh.kumar@linaro.org, akpm@linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com, Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [v2] ErrHandling:Make IS_ERR_VALUE_U32 as generic API to avoid IS_ERR_VALUE abuses.
Date: Sat,  9 Jul 2016 22:31:36 +0530
Message-Id: <1468083696-15283-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20160709_190204_507237_4D541CF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IS_ERR_VALUE() assumes that its parameter is an unsigned long.
It can not be used to check if an 'unsigned int' reflects an error.
As they pass an 'unsigned int' into a function that takes an
'unsigned long' argument. This happens to work because the type
is sign-extended on 64-bit architectures before it gets converted
into an unsigned type.

However, anything that passes an 'unsigned short' or 'unsigned int'
argument into IS_ERR_VALUE() is guaranteed to be broken, as are
8-bit integers and types that are wider than 'unsigned long'.

It would be nice to any users that are not passing 'unsigned int'
arguments.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/bcma/scan.c | 1 -
 include/linux/err.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 4a2d1b2..3bc77eb 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -272,7 +272,6 @@ static struct bcma_device *bcma_find_core_reverse(struct bcma_bus *bus, u16 core
 	return NULL;
 }
 
-#define IS_ERR_VALUE_U32(x) ((x) >= (u32)-MAX_ERRNO)
 
 static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device_id *match, int core_num,
diff --git a/include/linux/err.h b/include/linux/err.h
index 1e35588..e05a63d 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -20,6 +20,8 @@
 
 #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
 
+#define IS_ERR_VALUE_U32(x) unlikely((unsigned int)(x) >= (unsigned int)-MAX_ERRNO)
+
 static inline void * __must_check ERR_PTR(long error)
 {
 	return (void *) error;
-- 
1.9.1

