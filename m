Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38413 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbeECSjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 14:39:15 -0400
Received: by mail-pg0-f67.google.com with SMTP id n9-v6so13735547pgq.5
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2018 11:39:15 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH v3 4/4] NFC: fdp: Remove __func__ from dev_dbg()
Date: Fri,  4 May 2018 00:08:56 +0530
Message-Id: <1525372736-25094-4-git-send-email-amit.pundir@linaro.org> (sfid-20180503_203924_295335_524B0A4E)
In-Reply-To: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
References: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redundant __func__ parameter from dev_dgb() calls and
delete empty dev_dbg() trace calls, which are redundant if
function tracer is enabled.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v3:
Updated commit message.

v2:
Deleted empty dev_dbg() trace calls, which are redundant if
function tracer is enabled.

 drivers/nfc/fdp/fdp.c | 18 +++---------------
 drivers/nfc/fdp/i2c.c | 17 ++++-------------
 2 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index d5784a47fc13..f64a6fd65c41 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -249,8 +249,6 @@ static int fdp_nci_open(struct nci_dev *ndev)
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	r = info->phy_ops->enable(info->phy);
 
 	return r;
@@ -261,7 +259,6 @@ static int fdp_nci_close(struct nci_dev *ndev)
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	return 0;
 }
 
@@ -270,8 +267,6 @@ static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
 
@@ -283,7 +278,6 @@ int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	return nci_recv_frame(ndev, skb);
 }
 EXPORT_SYMBOL(fdp_nci_recv_frame);
@@ -498,8 +492,6 @@ static int fdp_nci_setup(struct nci_dev *ndev)
 	int r;
 	u8 patched = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	r = nci_core_init(ndev);
 	if (r)
 		goto error;
@@ -609,7 +601,6 @@ static int fdp_nci_core_reset_ntf_packet(struct nci_dev *ndev,
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_reset_ntf = 1;
 	wake_up(&info->setup_wq);
 
@@ -622,7 +613,6 @@ static int fdp_nci_prop_patch_ntf_packet(struct nci_dev *ndev,
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_patch_ntf = 1;
 	info->setup_patch_status = skb->data[0];
 	wake_up(&info->setup_wq);
@@ -637,7 +627,7 @@ static int fdp_nci_prop_patch_rsp_packet(struct nci_dev *ndev,
 	struct device *dev = &info->phy->i2c_dev->dev;
 	u8 status = skb->data[0];
 
-	dev_dbg(dev, "%s: status 0x%x\n", __func__, status);
+	dev_dbg(dev, "status 0x%x\n", status);
 	nci_req_complete(ndev, status);
 
 	return 0;
@@ -650,7 +640,7 @@ static int fdp_nci_prop_set_production_data_rsp_packet(struct nci_dev *ndev,
 	struct device *dev = &info->phy->i2c_dev->dev;
 	u8 status = skb->data[0];
 
-	dev_dbg(dev, "%s: status 0x%x\n", __func__, status);
+	dev_dbg(dev, "status 0x%x\n", status);
 	nci_req_complete(ndev, status);
 
 	return 0;
@@ -695,7 +685,7 @@ static int fdp_nci_core_get_config_rsp_packet(struct nci_dev *ndev,
 	dev_dbg(dev, "OTP version %d\n", info->otp_version);
 	dev_dbg(dev, "RAM version %d\n", info->ram_version);
 	dev_dbg(dev, "key index %d\n", info->key_index);
-	dev_dbg(dev, "%s: status 0x%x\n", __func__, rsp->status);
+	dev_dbg(dev, "status 0x%x\n", rsp->status);
 
 	nci_req_complete(ndev, rsp->status);
 
@@ -798,8 +788,6 @@ void fdp_nci_remove(struct nci_dev *ndev)
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 }
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 2c5ed2224c5e..bb14d30c568c 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -57,7 +57,6 @@ static int fdp_nci_i2c_enable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 
 	return 0;
@@ -67,7 +66,6 @@ static void fdp_nci_i2c_disable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 }
 
@@ -113,8 +111,8 @@ static int fdp_nci_i2c_write(void *phy_id, struct sk_buff *skb)
 	}
 
 	if (r < 0 || r != skb->len)
-		dev_dbg(&client->dev, "%s: error err=%d len=%d\n",
-			__func__, r, skb->len);
+		dev_dbg(&client->dev, "error err=%d len=%d\n",
+			r, skb->len);
 
 	if (r >= 0) {
 		if (r != skb->len) {
@@ -152,8 +150,7 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 
 		r = i2c_master_recv(client, tmp, len);
 		if (r != len) {
-			dev_dbg(&client->dev, "%s: i2c recv err: %d\n",
-				__func__, r);
+			dev_dbg(&client->dev, "i2c recv err: %d\n", r);
 			goto flush;
 		}
 
@@ -167,8 +164,7 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 		 * and force resynchronization
 		 */
 		if (lrc) {
-			dev_dbg(&client->dev, "%s: corrupted packet\n",
-				__func__);
+			dev_dbg(&client->dev, "corrupted packet\n");
 			phy->next_read_size = 5;
 			goto flush;
 		}
@@ -224,7 +220,6 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 	}
 
 	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "%s\n", __func__);
 
 	r = fdp_nci_i2c_read(phy, &skb);
 
@@ -305,8 +300,6 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 	u32 clock_freq;
 	int r = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(dev, "No I2C_FUNC_I2C support\n");
 		return -ENODEV;
@@ -368,8 +361,6 @@ static int fdp_nci_i2c_remove(struct i2c_client *client)
 {
 	struct fdp_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	fdp_nci_remove(phy->ndev);
 	fdp_nci_i2c_disable(phy);
 
-- 
2.7.4
