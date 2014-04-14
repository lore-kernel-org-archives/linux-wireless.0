Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16834 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007AbaDNWdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 7/7] mwifiex: remove redundant 'fw_load' completion structure
Date: Mon, 14 Apr 2014 15:32:55 -0700
Message-ID: <1397514775-4777-7-git-send-email-bzhao@marvell.com> (sfid-20140415_003408_075331_A24C59FC)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'add_remove_card_sem' semaphore already takes care of
synchronization for driver load and unload threads.
Hence there won't be a case when unload thread is waiting on
'wait_for_completion(fw_load)'.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 2 --
 drivers/net/wireless/mwifiex/main.h | 1 -
 drivers/net/wireless/mwifiex/pcie.c | 3 ---
 drivers/net/wireless/mwifiex/sdio.c | 3 ---
 drivers/net/wireless/mwifiex/usb.c  | 5 -----
 5 files changed, 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9c771b3..cbabc12 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -521,7 +521,6 @@ done:
 		release_firmware(adapter->firmware);
 		adapter->firmware = NULL;
 	}
-	complete(&adapter->fw_load);
 	if (init_failed)
 		mwifiex_free_adapter(adapter);
 	up(sem);
@@ -535,7 +534,6 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
-	init_completion(&adapter->fw_load);
 	ret = request_firmware_nowait(THIS_MODULE, 1, adapter->fw_name,
 				      adapter->dev, GFP_KERNEL, adapter,
 				      mwifiex_fw_dpc);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d53e1e8..ae8b042 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -787,7 +787,6 @@ struct mwifiex_adapter {
 	struct mwifiex_wait_queue cmd_wait_q;
 	u8 scan_wait_q_woken;
 	spinlock_t queue_lock;		/* lock for tx queues */
-	struct completion fw_load;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u16 max_mgmt_ie_index;
 	u8 scan_delay_cnt;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index a7e8b96..c2cfeec 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -221,9 +221,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	/* In case driver is removed when asynchronous FW load is in progress */
-	wait_for_completion(&adapter->fw_load);
-
 	if (user_rmmod) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index accceed..a1773d3 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -179,9 +179,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	/* In case driver is removed when asynchronous FW load is in progress */
-	wait_for_completion(&adapter->fw_load);
-
 	if (user_rmmod) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index db6377f..a8ce813 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -543,11 +543,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	if (!adapter->priv_num)
 		return;
 
-	/* In case driver is removed when asynchronous FW downloading is
-	 * in progress
-	 */
-	wait_for_completion(&adapter->fw_load);
-
 	if (user_rmmod) {
 #ifdef CONFIG_PM
 		if (adapter->is_suspended)
-- 
1.8.2.3

