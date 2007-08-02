Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:13849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXHBPk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:40:58 -0400
Received: by fk-out-0910.google.com with SMTP id z23so457297fkz
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 08:40:56 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Thu, 2 Aug 2007 17:45:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708021745.12452.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is rt2x00 version 2.0.6,
unfortunately 2.0.5 was broken and unusable.

Problem has been found and fixed, so together with
some other small changes here is 2.0.6 :)

This one should be safe to be merged with FC kernels. ;)

Ivo

---

The following changes since commit 515c4dbee8271ff66fde61304309b1992e430502:
  John W. Linville (1):
        Merge branch 'upstream' of git://git.kernel.org/.../ivd/rt2x00

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (7):
      Merge branch 'wireless-dev'
      rt2x00: Add new USB ID for Buffalo rt73usb
      rt2x00: Update rssi before signal calculation
      rt2x00: Return 0 when the offset != 0
      rt2x00: rt2x00lib_config_mac_addr should call config_mac
      rt2x00: Release rt2x00 2.0.6
      Merge branch 'wireless-dev'

 drivers/net/wireless/rt2x00.h       |    2 +-
 drivers/net/wireless/rt2x00config.c |    4 ++--
 drivers/net/wireless/rt2x00debug.c  |    6 ++++++
 drivers/net/wireless/rt2x00dev.c    |    2 +-
 drivers/net/wireless/rt73usb.c      |    2 ++
 5 files changed, 12 insertions(+), 4 deletions(-)
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index c5c1773..77556fe 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -41,7 +41,7 @@
  * Module information.
  * DRV_NAME should be set within the individual module source files.
  */
-#define DRV_VERSION	"2.0.5"
+#define DRV_VERSION	"2.0.6"
 #define DRV_PROJECT	"http://rt2x00.serialmonkey.com"
 
 /*
diff --git a/drivers/net/wireless/rt2x00config.c b/drivers/net/wireless/rt2x00config.c
index 3733a84..11d5646 100644
--- a/drivers/net/wireless/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00config.c
@@ -37,13 +37,13 @@
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac)
 {
 	if (mac)
-		rt2x00dev->ops->lib->config_bssid(rt2x00dev, mac);
+		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, mac);
 }
 
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 {
 	if (bssid)
-		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev, bssid);
+		rt2x00dev->ops->lib->config_bssid(rt2x00dev, bssid);
 }
 
 void rt2x00lib_config_packet_filter(struct rt2x00_dev *rt2x00dev, int filter)
diff --git a/drivers/net/wireless/rt2x00debug.c b/drivers/net/wireless/rt2x00debug.c
index ffc95bb..d6c4cfe 100644
--- a/drivers/net/wireless/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00debug.c
@@ -124,6 +124,9 @@ static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 	size_t size;						\
 	__type value;						\
 								\
+	if (*offset)						\
+		return 0;					\
+								\
 	if (intf->offset_##__name > debug->__name.word_count)	\
 		return -EINVAL;					\
 								\
@@ -151,6 +154,9 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	size_t size;						\
 	__type value;						\
 								\
+	if (*offset)						\
+		return 0;					\
+								\
 	if (!capable(CAP_NET_ADMIN))				\
 		return -EPERM;					\
 								\
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index a584fbe..28ddbe0 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -349,11 +349,11 @@ void rt2x00lib_rxdone(struct data_entry *entry, char *data,
 		}
 	}
 
+	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
 	rt2x00dev->link.rx_success++;
 	rx_status->rate = val;
 	rx_status->signal = rt2x00lib_calculate_link_signal(rt2x00dev);
 	rx_status->ssi = rssi;
-	rt2x00_update_link_rssi(&rt2x00dev->link, rssi);
 
 	/*
 	 * Let's allocate a sk_buff where we can store the received data in,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 48fb38e..2f0bf29 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1884,6 +1884,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Billionton */
 	{ USB_DEVICE(0x1631, 0xc019), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Buffalo */
+	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
