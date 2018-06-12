Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41967 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933295AbeFLOOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 10:14:16 -0400
Received: by mail-pf0-f193.google.com with SMTP id a11-v6so12185552pff.8
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2018 07:14:16 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] NFC: fdp: Fix unused variable warnings
Date: Tue, 12 Jun 2018 19:44:10 +0530
Message-Id: <1528812850-16158-1-git-send-email-amit.pundir@linaro.org> (sfid-20180612_161419_819954_FF15FD52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix unused variable warnings reported on next-20180612.

Fixes: 7579d009c4a1 ("NFC: fdp: Remove __func__ from dev_dbg()")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 drivers/nfc/fdp/fdp.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 36d1091d288a..6b5aba8c8937 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -247,7 +247,6 @@ static int fdp_nci_open(struct nci_dev *ndev)
 {
 	int r;
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
 	r = info->phy_ops->enable(info->phy);
 
@@ -256,16 +255,12 @@ static int fdp_nci_open(struct nci_dev *ndev)
 
 static int fdp_nci_close(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
 	return 0;
 }
 
 static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
@@ -275,9 +270,6 @@ static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 
 int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
 	return nci_recv_frame(ndev, skb);
 }
 EXPORT_SYMBOL(fdp_nci_recv_frame);
@@ -599,7 +591,6 @@ static int fdp_nci_core_reset_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
 	info->setup_reset_ntf = 1;
 	wake_up(&info->setup_wq);
@@ -611,7 +602,6 @@ static int fdp_nci_prop_patch_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
 	info->setup_patch_ntf = 1;
 	info->setup_patch_status = skb->data[0];
@@ -785,9 +775,6 @@ EXPORT_SYMBOL(fdp_nci_probe);
 
 void fdp_nci_remove(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 }
-- 
2.7.4
