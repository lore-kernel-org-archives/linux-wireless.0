Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25215 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbcBCGKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1369UdB011932
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:12 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 20svyv7n1f-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:12 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/8] mwifiex: keep original structure in decl header file
Date: Tue, 2 Feb 2016 22:05:05 -0800
Message-ID: <1454479509-27129-5-git-send-email-akarwar@marvell.com> (sfid-20160203_071027_436258_D0F6E550)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

memory_type_mapping strucuture did not refer to other mwifiex
specific strture. A better software design method would keep
it in decl header file, which does not include other mwifiex
header file.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/decl.h | 21 +++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h | 20 --------------------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  1 +
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index d9c15cd..c744a70 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -270,4 +270,25 @@ struct mwifiex_11h_intf_state {
 	bool is_11h_enabled;
 	bool is_11h_active;
 } __packed;
+
+#define MWIFIEX_FW_DUMP_IDX		0xff
+#define MWIFIEX_DRV_INFO_IDX		20
+#define FW_DUMP_MAX_NAME_LEN		8
+#define FW_DUMP_HOST_READY      0xEE
+#define FW_DUMP_DONE			0xFF
+#define FW_DUMP_READ_DONE		0xFE
+
+struct memory_type_mapping {
+	u8 mem_name[FW_DUMP_MAX_NAME_LEN];
+	u8 *mem_ptr;
+	u32 mem_size;
+	u8 done_flag;
+};
+
+enum rdwr_status {
+	RDWR_STATUS_SUCCESS = 0,
+	RDWR_STATUS_FAILURE = 1,
+	RDWR_STATUS_DONE = 2
+};
+
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 0433977..aea7aee 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -489,26 +489,6 @@ struct mwifiex_roc_cfg {
 	struct ieee80211_channel chan;
 };
 
-#define MWIFIEX_FW_DUMP_IDX		0xff
-#define MWIFIEX_DRV_INFO_IDX		20
-#define FW_DUMP_MAX_NAME_LEN		8
-#define FW_DUMP_HOST_READY		0xEE
-#define FW_DUMP_DONE			0xFF
-#define FW_DUMP_READ_DONE		0xFE
-
-struct memory_type_mapping {
-	u8 mem_name[FW_DUMP_MAX_NAME_LEN];
-	u8 *mem_ptr;
-	u32 mem_size;
-	u8 done_flag;
-};
-
-enum rdwr_status {
-	RDWR_STATUS_SUCCESS = 0,
-	RDWR_STATUS_FAILURE = 1,
-	RDWR_STATUS_DONE = 2
-};
-
 enum mwifiex_iface_work_flags {
 	MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 	MWIFIEX_IFACE_WORK_CARD_RESET,
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 9700ac3..8f190c4 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -26,6 +26,7 @@
 #include    <linux/pcieport_if.h>
 #include    <linux/interrupt.h>
 
+#include    "decl.h"
 #include    "main.h"
 
 #define PCIE8766_DEFAULT_FW_NAME "mrvl/pcie8766_uapsta.bin"
-- 
1.8.1.4

