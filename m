Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40574 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2BMThi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:37:38 -0500
Received: by iacb35 with SMTP id b35so4859866iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 11:37:37 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, chunkeey@web.de
Subject: [PATCH 4/5] p54pci: Load firmware from work queue and not from probe routine
Date: Mon, 13 Feb 2012 13:37:05 -0600
Message-Id: <1329161826-11135-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120213_203743_355590_8FA50411)
In-Reply-To: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that load firmware from their probe routine have problems with the
latest versions of udev as they get timeouts while waiting for user
space to start. The problem is fixed by loading the firmware and starting
mac80211 from a delayed_work queue. By using this method, most of the
original code is preserved.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

This patch is compile tested only.

Larry
---
 drivers/net/wireless/p54/p54pci.c |   66 ++++++++++++++++++++++--------------
 drivers/net/wireless/p54/p54pci.h |    1 +
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index b1f51a2..7e4188a 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -488,6 +488,43 @@ static int p54p_open(struct ieee80211_hw *dev)
 	return 0;
 }
 
+static void p54p_load_firmware(struct work_struct *work)
+{
+	struct p54p_priv *priv = container_of(to_delayed_work(work),
+				 struct p54p_priv, firmware_load);
+	struct ieee80211_hw *hw = pci_get_drvdata(priv->pdev);
+	struct device *dev = &priv->pdev->dev;
+	int err;
+
+	err = request_firmware(&priv->firmware, "isl3886pci",
+			       &priv->pdev->dev);
+	if (err) {
+		dev_err(dev, "Cannot find firmware (isl3886pci)\n");
+		err = request_firmware(&priv->firmware, "isl3886",
+				       &priv->pdev->dev);
+		if (err) {
+			dev_err(dev, "Cannot find firmware (isl3886pci)\n");
+			goto err_free_firmware;
+		}
+	}
+
+	err = p54p_open(hw);
+	if (err)
+		goto err_free_firmware;
+	err = p54_read_eeprom(hw);
+	p54p_stop(hw);
+	if (err)
+		goto err_free_firmware;
+
+	err = p54_register_common(hw, dev);
+	if (err)
+		goto err_free_firmware;
+	return;
+
+err_free_firmware:
+	release_firmware(priv->firmware);
+}
+
 static int __devinit p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -561,35 +598,12 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
 
-	err = request_firmware(&priv->firmware, "isl3886pci",
-			       &priv->pdev->dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot find firmware (isl3886pci)\n");
-		err = request_firmware(&priv->firmware, "isl3886",
-				       &priv->pdev->dev);
-		if (err)
-			goto err_free_common;
-	}
-
-	err = p54p_open(dev);
-	if (err)
-		goto err_free_common;
-	err = p54_read_eeprom(dev);
-	p54p_stop(dev);
-	if (err)
-		goto err_free_common;
-
-	err = p54_register_common(dev, &pdev->dev);
-	if (err)
-		goto err_free_common;
+	/* setup and start delayed work to load firmware */
+	INIT_DELAYED_WORK(&priv->firmware_load, p54p_load_firmware);
+	schedule_delayed_work(&priv->firmware_load, HZ);
 
 	return 0;
 
- err_free_common:
-	release_firmware(priv->firmware);
-	pci_free_consistent(pdev, sizeof(*priv->ring_control),
-			    priv->ring_control, priv->ring_control_dma);
-
  err_iounmap:
 	iounmap(priv->map);
 
diff --git a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
index 7aa509f..de8edff 100644
--- a/drivers/net/wireless/p54/p54pci.h
+++ b/drivers/net/wireless/p54/p54pci.h
@@ -105,6 +105,7 @@ struct p54p_priv {
 	struct sk_buff *tx_buf_data[32];
 	struct sk_buff *tx_buf_mgmt[4];
 	struct completion boot_comp;
+	struct delayed_work firmware_load;
 };
 
 #endif /* P54USB_H */
-- 
1.7.7

