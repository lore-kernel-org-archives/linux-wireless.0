Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55541 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab1LVUrx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/6] compat-wireless: use other workqueue
Date: Thu, 22 Dec 2011 21:47:29 +0100
Message-Id: <1324586850-5212-6-git-send-email-hauke@hauke-m.de> (sfid-20111222_214757_902116_0DF2F28D)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old kernel versions do not support WQ_HIGHPRI and WQ_MEM_RECLAIM so we
should use create_singlethread_workqueue() which was used at this
position before.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/46-use_other_workqueue.patch |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 patches/46-use_other_workqueue.patch

diff --git a/patches/46-use_other_workqueue.patch b/patches/46-use_other_workqueue.patch
new file mode 100644
index 0000000..4cfe4f6
--- /dev/null
+++ b/patches/46-use_other_workqueue.patch
@@ -0,0 +1,15 @@
+--- a/net/bluetooth/hci_core.c
++++ b/net/bluetooth/hci_core.c
+@@ -1534,8 +1534,12 @@ int hci_register_dev(struct hci_dev *hde
+ 
+ 	write_unlock_bh(&hci_dev_list_lock);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	hdev->workqueue = alloc_workqueue(hdev->name, WQ_HIGHPRI | WQ_UNBOUND |
+ 							WQ_MEM_RECLAIM, 1);
++#else
++	hdev->workqueue = create_singlethread_workqueue(hdev->name);
++#endif
+ 	if (!hdev->workqueue) {
+ 		error = -ENOMEM;
+ 		goto err;
-- 
1.7.5.4

