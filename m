Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34955 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1JCKoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:44:46 -0400
Subject: [PATCH] ath6kl: include vmalloc.h in debug.c
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Oct 2011 13:44:40 +0300
Message-ID: <20111003104440.27129.60479.stgit@localhost6.localdomain6> (sfid-20111003_124449_408758_08C95A93)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes compilation errors when compiling for ARM:

ath6kl/debug.c:312: error: implicit declaration of function 'vmalloc'
ath6kl/debug.c:312: warning: assignment makes pointer from integer without a cast
ath6kl/debug.c:342: error: implicit declaration of function 'vfree'
ath6kl/debug.c:696: warning: assignment makes pointer from integer without a cast
ath6kl/debug.c:871: warning: assignment makes pointer from integer without a cast

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 5237369..ba3f23d 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -18,6 +18,7 @@
 
 #include <linux/circ_buf.h>
 #include <linux/fs.h>
+#include <linux/vmalloc.h>
 
 #include "debug.h"
 #include "target.h"

