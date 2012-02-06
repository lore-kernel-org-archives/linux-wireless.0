Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1475 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437Ab2BFW7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 17:59:06 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/8] rt2x00: Introduce concept of driver data in struct rt2x00_dev.
Date: Mon,  6 Feb 2012 23:45:06 +0100
Message-Id: <1328568313-26267-2-git-send-email-gwingerde@gmail.com> (sfid-20120206_235918_716180_054DF437)
In-Reply-To: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are getting more and more fields in struct rt2x00_dev that are
specific to one or two of the low-level drivers. Instead of putting
these fields inside the main structure and thus clobbering all low-level
drivers with these fields, introduce the concept of driver data inside
struct rt2x00_dev, whose size is indicated by the low-level driver and
which can be populated by the low-level driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b03b22c..b4260bfb6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -647,6 +647,7 @@ struct rt2x00lib_ops {
  */
 struct rt2x00_ops {
 	const char *name;
+	const unsigned int drv_data_size;
 	const unsigned int max_sta_intf;
 	const unsigned int max_ap_intf;
 	const unsigned int eeprom_size;
@@ -742,6 +743,11 @@ struct rt2x00_dev {
 	const struct rt2x00_ops *ops;
 
 	/*
+	 * Driver data.
+	 */
+	void *drv_data;
+
+	/*
 	 * IEEE80211 control structure.
 	 */
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c3e1aa7..bae5b01 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1121,6 +1121,18 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 {
 	int retval = -ENOMEM;
 
+	/*
+	 * Allocate the driver data memory, if necessary.
+	 */
+	if (rt2x00dev->ops->drv_data_size > 0) {
+		rt2x00dev->drv_data = kzalloc(rt2x00dev->ops->drv_data_size,
+			                      GFP_KERNEL);
+		if (!rt2x00dev->drv_data) {
+			retval = -ENOMEM;
+			goto exit;
+		}
+	}
+
 	spin_lock_init(&rt2x00dev->irqmask_lock);
 	mutex_init(&rt2x00dev->csr_mutex);
 
@@ -1261,6 +1273,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free queue structures.
 	 */
 	rt2x00queue_free(rt2x00dev);
+
+	/*
+	 * Free the driver data.
+	 */
+	if (rt2x00dev->drv_data)
+		kfree(rt2x00dev->drv_data);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
 
-- 
1.7.9

