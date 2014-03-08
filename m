Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [67.231.156.173] ([67.231.156.173]:60183 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752238AbaCHDmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:14 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/6] mwifiex: extract firmware API version number
Date: Fri, 7 Mar 2014 19:41:26 -0800
Message-ID: <1394250091-18477-1-git-send-email-bzhao@marvell.com> (sfid-20140308_044220_190117_451599C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The firmware API version number will be used for future patches
to support different firmware API specs.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 1 +
 drivers/net/wireless/mwifiex/fw.h     | 2 ++
 drivers/net/wireless/mwifiex/main.h   | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 14e05c9..b411558 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1502,6 +1502,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	}
 
 	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
+	adapter->fw_api_ver = (adapter->fw_release_number >> 16) & 0xff;
 	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
 
 	if (le32_to_cpu(hw_spec->dot_11ac_dev_cap)) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 39cb354..5b30834 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -515,6 +515,8 @@ enum P2P_MODES {
 #define ACT_TDLS_CREATE            0x01
 #define ACT_TDLS_CONFIG            0x02
 
+#define MWIFIEX_FW_V15		   15
+
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f0289c1..5f9bfb0 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -802,6 +802,7 @@ struct mwifiex_adapter {
 	atomic_t pending_bridged_pkts;
 	struct semaphore *card_sem;
 	bool ext_scan;
+	u8 fw_api_ver;
 	u8 fw_key_api_major_ver, fw_key_api_minor_ver;
 };
 
-- 
1.8.2.3

