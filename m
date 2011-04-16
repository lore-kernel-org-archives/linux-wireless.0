Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39678 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DPDq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 23:46:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: optimize driver initialization code
Date: Fri, 15 Apr 2011 20:50:42 -0700
Message-Id: <1302925842-27718-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302925842-27718-1-git-send-email-bzhao@marvell.com>
References: <1302925842-27718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) removal of unnecessary mwifiex_device structure
2) avoid passing adapter pointer to mwifiex_init_sw()
3) remove local variable drv_mode_info in mwifiex_add_card()
4) type change in mwifiex_bss_attr to match mwifiex_private
5) removal of more wordy comments

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h |   14 ++----
 drivers/net/wireless/mwifiex/main.c |   81 ++++++++++++-----------------------
 drivers/net/wireless/mwifiex/main.h |    2 +-
 3 files changed, 33 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 8364b62..0e90b09 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -113,11 +113,11 @@ struct mwifiex_txinfo {
 };
 
 struct mwifiex_bss_attr {
-	u32 bss_type;
-	u32 frame_type;
-	u32 active;
-	u32 bss_priority;
-	u32 bss_num;
+	u8 bss_type;
+	u8 frame_type;
+	u8 active;
+	u8 bss_priority;
+	u8 bss_num;
 };
 
 enum mwifiex_wmm_ac_e {
@@ -126,8 +126,4 @@ enum mwifiex_wmm_ac_e {
 	WMM_AC_VI,
 	WMM_AC_VO
 } __packed;
-
-struct mwifiex_device {
-	struct mwifiex_bss_attr bss_attr[MWIFIEX_MAX_BSS_NUM];
-};
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2c376dd..c597188 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -40,14 +40,10 @@ static char fw_name[32] = DEFAULT_FW_NAME;
 /* Supported drv_mode table */
 static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
 	{
-	 /* drv_mode */
-	 .drv_mode = DRV_MODE_STA,
-	 /* intf number */
-	 .intf_num = ARRAY_SIZE(mwifiex_bss_sta),
-	 /* bss_attr */
-	 .bss_attr = mwifiex_bss_sta,
-	 }
-	,
+		.drv_mode = DRV_MODE_STA,
+		.intf_num = ARRAY_SIZE(mwifiex_bss_sta),
+		.bss_attr = mwifiex_bss_sta,
+	},
 };
 
 /*
@@ -66,13 +62,12 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
  * proper cleanup before exiting.
  */
 static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
-			    struct mwifiex_device *mdevice, void **padapter)
+			    struct mwifiex_drv_mode *drv_mode_ptr)
 {
-	struct mwifiex_adapter *adapter = NULL;
-	u8 i = 0;
+	struct mwifiex_adapter *adapter;
+	int i;
 
 	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
-	/* Allocate memory for adapter structure */
 	if (!adapter)
 		return -1;
 
@@ -87,14 +82,13 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 		goto error;
 
 	adapter->priv_num = 0;
-	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
+	for (i = 0; i < drv_mode_ptr->intf_num; i++) {
 		adapter->priv[i] = NULL;
 
-		if (!mdevice->bss_attr[i].active)
+		if (!drv_mode_ptr->bss_attr[i].active)
 			continue;
 
-		/* For valid bss_attr,
-		   allocate memory for private structure */
+		/* Allocate memory for private structure */
 		adapter->priv[i] = kzalloc(sizeof(struct mwifiex_private),
 				GFP_KERNEL);
 		if (!adapter->priv[i]) {
@@ -104,26 +98,26 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 		}
 
 		adapter->priv_num++;
-		memset(adapter->priv[i], 0,
-		       sizeof(struct mwifiex_private));
 		adapter->priv[i]->adapter = adapter;
 		/* Save bss_type, frame_type & bss_priority */
-		adapter->priv[i]->bss_type = (u8) mdevice->bss_attr[i].bss_type;
+		adapter->priv[i]->bss_type = drv_mode_ptr->bss_attr[i].bss_type;
 		adapter->priv[i]->frame_type =
-			(u8) mdevice->bss_attr[i].frame_type;
+					drv_mode_ptr->bss_attr[i].frame_type;
 		adapter->priv[i]->bss_priority =
-			(u8) mdevice->bss_attr[i].bss_priority;
-		if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_STA)
+					drv_mode_ptr->bss_attr[i].bss_priority;
+
+		if (drv_mode_ptr->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_STA)
 			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_STA;
-		else if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_UAP)
+		else if (drv_mode_ptr->bss_attr[i].bss_type ==
+							MWIFIEX_BSS_TYPE_UAP)
 			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_UAP;
 
 		/* Save bss_index & bss_num */
 		adapter->priv[i]->bss_index = i;
-		adapter->priv[i]->bss_num = mdevice->bss_attr[i].bss_num;
+		adapter->priv[i]->bss_num = drv_mode_ptr->bss_attr[i].bss_num;
 	}
+	adapter->drv_mode = drv_mode_ptr;
 
-	/* Initialize lock variables */
 	if (mwifiex_init_lock_list(adapter))
 		goto error;
 
@@ -131,16 +125,13 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 	adapter->cmd_timer.function = mwifiex_cmd_timeout_func;
 	adapter->cmd_timer.data = (unsigned long) adapter;
 
-	/* Return pointer of struct mwifiex_adapter */
-	*padapter = adapter;
 	return 0;
 
 error:
 	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
 
-	/* Free lock variables */
 	mwifiex_free_lock_list(adapter);
-	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++)
+	for (i = 0; i < drv_mode_ptr->intf_num; i++)
 		kfree(adapter->priv[i]);
 	kfree(adapter);
 
@@ -335,10 +326,9 @@ exit_main_proc:
  * and initializing the private structures.
  */
 static int
-mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
+mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops)
 {
 	int i;
-	struct mwifiex_device device;
 	struct mwifiex_drv_mode *drv_mode_ptr;
 
 	/* find mwifiex_drv_mode entry from mwifiex_drv_mode_tbl */
@@ -355,20 +345,7 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 		return -1;
 	}
 
-	memset(&device, 0, sizeof(struct mwifiex_device));
-
-	for (i = 0; i < drv_mode_ptr->intf_num; i++) {
-		device.bss_attr[i].bss_type =
-			drv_mode_ptr->bss_attr[i].bss_type;
-		device.bss_attr[i].frame_type =
-			drv_mode_ptr->bss_attr[i].frame_type;
-		device.bss_attr[i].active = drv_mode_ptr->bss_attr[i].active;
-		device.bss_attr[i].bss_priority =
-			drv_mode_ptr->bss_attr[i].bss_priority;
-		device.bss_attr[i].bss_num = drv_mode_ptr->bss_attr[i].bss_num;
-	}
-
-	if (mwifiex_register(card, if_ops, &device, pmwifiex))
+	if (mwifiex_register(card, if_ops, drv_mode_ptr))
 		return -1;
 
 	return 0;
@@ -892,21 +869,19 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops)
 {
 	int i;
-	struct mwifiex_adapter *adapter = NULL;
-	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
+	struct mwifiex_adapter *adapter;
 
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
-	if (mwifiex_init_sw(card, if_ops, (void **) &adapter)) {
+	if (mwifiex_init_sw(card, if_ops)) {
 		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
 
-	adapter->drv_mode = drv_mode_info;
+	adapter = g_adapter;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
-	/* PnP and power profile */
 	adapter->surprise_removed = false;
 	init_waitqueue_head(&adapter->init_wait_q);
 	adapter->is_suspended = false;
@@ -917,7 +892,6 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->cmd_wait_q.condition = false;
 	adapter->cmd_wait_q.status = 0;
 
-	/* Create workqueue */
 	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
 	if (!adapter->workqueue)
 		goto err_kmalloc;
@@ -931,13 +905,13 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_registerdev;
 	}
 
-	/* Init FW and HW */
 	if (mwifiex_init_hw_fw(adapter)) {
 		pr_err("%s: firmware init failed\n", __func__);
 		goto err_init_fw;
 	}
+
 	/* Add interfaces */
-	for (i = 0; i < drv_mode_info->intf_num; i++) {
+	for (i = 0; i < adapter->drv_mode->intf_num; i++) {
 		if (!mwifiex_add_interface(adapter, i,
 				adapter->drv_mode->bss_attr[i].bss_type)) {
 			goto err_add_intf;
@@ -952,7 +926,6 @@ err_add_intf:
 	for (i = 0; i < adapter->priv_num; i++)
 		mwifiex_remove_interface(adapter, i);
 err_init_fw:
-	/* Unregister device */
 	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
 err_registerdev:
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2d296dc..1b50303 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -872,7 +872,7 @@ mwifiex_copy_rates(u8 *dest, u32 pos, u8 *src, int len)
  */
 static inline struct mwifiex_private *
 mwifiex_get_priv_by_id(struct mwifiex_adapter *adapter,
-		       u32 bss_num, u32 bss_type)
+		       u8 bss_num, u8 bss_type)
 {
 	int i;
 
-- 
1.7.0.2

