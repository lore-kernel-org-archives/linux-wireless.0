Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41682 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3GVJyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 05:54:03 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH] wil6210: drop -Werror compiler flag
Date: Mon, 22 Jul 2013 12:53:48 +0300
Message-ID: <1374486828-22350-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130722_115407_564840_4A798EC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In production code, don't use -Werror,
as it causes random compilation failures due to compiler version and options used.

With every new version of gcc, it becomes stricter and report more warnings.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index f891d51..990dd42a 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -11,9 +11,6 @@ wil6210-y += txrx.o
 wil6210-y += debug.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 
-ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
-	subdir-ccflags-y += -Werror
-endif
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
 
-- 
1.8.1.2

