Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40689 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:51:27 -0500
Received: by mail-we0-f172.google.com with SMTP id r3so2714602wey.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:51:26 -0800 (PST)
Message-Id: <ec14d0f50d8789955235a950e3cf42824ff01467.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155132_387040_CBBFEDBA)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 15 Dec 2012 23:21:32 +0100
Subject: [PATCH 3/8] carl9170: import 1.9.7 firmware headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Import new headers from my firmware branch:
<https://github.com/chunkeey/carl9170fw>

visit our wiki at:
<http://wireless.kernel.org/en/users/Drivers/carl9170.fw>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h   |    8 ++++++++
 drivers/net/wireless/ath/carl9170/hw.h      |    2 +-
 drivers/net/wireless/ath/carl9170/version.h |    6 +++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 9443c80..9111d4f 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -156,6 +156,14 @@ struct carl9170_psm {
 } __packed;
 #define CARL9170_PSM_SIZE		4
 
+/*
+ * Note: If a bit in rx_filter is set, then it
+ * means that the particular frames which matches
+ * the condition are FILTERED/REMOVED/DISCARDED!
+ * (This is can be a bit confusing, especially
+ * because someone people think it's the exact
+ * opposite way, so watch out!)
+ */
 struct carl9170_rx_filter_cmd {
 	__le32		rx_filter;
 } __packed;
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index fa834c1..0db874a 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -384,7 +384,7 @@
 
 #define	AR9170_MAC_REG_BCN_ADDR			(AR9170_MAC_REG_BASE + 0xd84)
 #define	AR9170_MAC_REG_BCN_LENGTH		(AR9170_MAC_REG_BASE + 0xd88)
-#define		AR9170_MAC_BCN_LENGTH_MAX		256
+#define		AR9170_MAC_BCN_LENGTH_MAX		(512 - 32)
 
 #define AR9170_MAC_REG_BCN_STATUS		(AR9170_MAC_REG_BASE + 0xd8c)
 
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index 2ec3e91..2282847 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
 #define CARL9170FW_VERSION_YEAR 12
-#define CARL9170FW_VERSION_MONTH 7
-#define CARL9170FW_VERSION_DAY 7
-#define CARL9170FW_VERSION_GIT "1.9.6"
+#define CARL9170FW_VERSION_MONTH 12
+#define CARL9170FW_VERSION_DAY 15
+#define CARL9170FW_VERSION_GIT "1.9.7"
 #endif /* __CARL9170_SHARED_VERSION_H */
-- 
1.7.10.4

