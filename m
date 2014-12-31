Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19530 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbaLaKiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:06 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/9] mwifiex: remove redundant flag MWIFIEX_HW_STATUS_FW_READY
Date: Wed, 31 Dec 2014 02:36:38 -0800
Message-ID: <1420022206-11435-2-git-send-email-akarwar@marvell.com> (sfid-20141231_113810_818263_74A431A3)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag is never set but checked at two places. We will get rid of
this code.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 6 ++----
 drivers/net/wireless/mwifiex/main.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 6125d1c..2568395 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -511,8 +511,7 @@ err_dnld_fw:
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
 
-	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
-	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		pr_debug("info: %s: shutdown mwifiex\n", __func__);
 		adapter->init_wait_q_woken = false;
 
@@ -1116,8 +1115,7 @@ err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
 	if (adapter->if_ops.unregister_dev)
 		adapter->if_ops.unregister_dev(adapter);
-	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
-	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY) {
 		pr_debug("info: %s: shutdown mwifiex\n", __func__);
 		adapter->init_wait_q_woken = false;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index dd55bc1..f927939 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -165,7 +165,6 @@ struct mwifiex_dbg {
 enum MWIFIEX_HARDWARE_STATUS {
 	MWIFIEX_HW_STATUS_READY,
 	MWIFIEX_HW_STATUS_INITIALIZING,
-	MWIFIEX_HW_STATUS_FW_READY,
 	MWIFIEX_HW_STATUS_INIT_DONE,
 	MWIFIEX_HW_STATUS_RESET,
 	MWIFIEX_HW_STATUS_CLOSING,
-- 
1.8.1.4

