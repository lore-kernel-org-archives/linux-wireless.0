Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcDYOR7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 10:17:59 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl818x: Deinline indexed IO functions, save 21568 bytes
Date: Mon, 25 Apr 2016 16:17:52 +0200
Message-Id: <1461593872-6296-1-git-send-email-dvlasenk@redhat.com> (sfid-20160425_161818_782429_2FE16D9F)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl818x_ioread8_idx: 151 bytes, 29 calls
rtl818x_ioread16_idx: 151 bytes, 11 calls
rtl818x_ioread32_idx: 151 bytes, 5 calls
rtl818x_iowrite8_idx: 157 bytes, 117 calls
rtl818x_iowrite16_idx: 158 bytes, 74 calls
rtl818x_iowrite32_idx: 157 bytes, 22 calls

Each of these functions has a pair of mutex lock/unlock ops,
both of these ops perform atomic updates of memory (on x86, it boils down to
"lock cmpxchg %reg,mem" insn), which are 4-8 times more expensive than call+return.

    text     data      bss       dec     hex filename
95894242 20860288 35991552 152746082 91ab862 vmlinux_before
95872674 20860320 35991552 152724546 91a6442 vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>
CC: Chaoming Li <chaoming_li@realsil.com.cn>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8187.h | 99 +++-------------------
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c | 93 ++++++++++++++++++++
 2 files changed, 105 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h
index a6ad79f..324451d 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h
@@ -160,104 +160,40 @@ struct rtl8187_priv {
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
 
-static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
-				     u8 *addr, u8 idx)
-{
-	u8 val;
-
-	mutex_lock(&priv->io_mutex);
-	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
-			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
-
-	val = priv->io_dmabuf->bits8;
-	mutex_unlock(&priv->io_mutex);
-
-	return val;
-}
+u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
+				u8 *addr, u8 idx);
 
 static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
 {
 	return rtl818x_ioread8_idx(priv, addr, 0);
 }
 
-static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
-				       __le16 *addr, u8 idx)
-{
-	__le16 val;
-
-	mutex_lock(&priv->io_mutex);
-	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
-			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
-
-	val = priv->io_dmabuf->bits16;
-	mutex_unlock(&priv->io_mutex);
-
-	return le16_to_cpu(val);
-}
+u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
+				__le16 *addr, u8 idx);
 
 static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
 {
 	return rtl818x_ioread16_idx(priv, addr, 0);
 }
 
-static inline u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
-				       __le32 *addr, u8 idx)
-{
-	__le32 val;
-
-	mutex_lock(&priv->io_mutex);
-	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
-			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
-
-	val = priv->io_dmabuf->bits32;
-	mutex_unlock(&priv->io_mutex);
-
-	return le32_to_cpu(val);
-}
+u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
+				__le32 *addr, u8 idx);
 
 static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
 {
 	return rtl818x_ioread32_idx(priv, addr, 0);
 }
 
-static inline void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
-					u8 *addr, u8 val, u8 idx)
-{
-	mutex_lock(&priv->io_mutex);
-
-	priv->io_dmabuf->bits8 = val;
-	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
-			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
-
-	mutex_unlock(&priv->io_mutex);
-}
+void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
+				u8 *addr, u8 val, u8 idx);
 
 static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
 {
 	rtl818x_iowrite8_idx(priv, addr, val, 0);
 }
 
-static inline void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
-					 __le16 *addr, u16 val, u8 idx)
-{
-	mutex_lock(&priv->io_mutex);
-
-	priv->io_dmabuf->bits16 = cpu_to_le16(val);
-	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
-			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
-
-	mutex_unlock(&priv->io_mutex);
-}
+void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
+				__le16 *addr, u16 val, u8 idx);
 
 static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
 				     u16 val)
@@ -265,19 +201,8 @@ static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
 	rtl818x_iowrite16_idx(priv, addr, val, 0);
 }
 
-static inline void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
-					 __le32 *addr, u32 val, u8 idx)
-{
-	mutex_lock(&priv->io_mutex);
-
-	priv->io_dmabuf->bits32 = cpu_to_le32(val);
-	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
-			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
-
-	mutex_unlock(&priv->io_mutex);
-}
+void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
+				__le32 *addr, u32 val, u8 idx);
 
 static inline void rtl818x_iowrite32(struct rtl8187_priv *priv, __le32 *addr,
 				     u32 val)
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
index 5ecf18e..e6668ff 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
@@ -22,6 +22,99 @@
 #include "rtl8187.h"
 #include "rtl8225.h"
 
+u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
+				u8 *addr, u8 idx)
+{
+	u8 val;
+
+	mutex_lock(&priv->io_mutex);
+	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
+			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits8;
+	mutex_unlock(&priv->io_mutex);
+
+	return val;
+}
+
+u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
+				__le16 *addr, u8 idx)
+{
+	__le16 val;
+
+	mutex_lock(&priv->io_mutex);
+	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
+			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits16;
+	mutex_unlock(&priv->io_mutex);
+
+	return le16_to_cpu(val);
+}
+
+u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
+				__le32 *addr, u8 idx)
+{
+	__le32 val;
+
+	mutex_lock(&priv->io_mutex);
+	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
+			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits32;
+	mutex_unlock(&priv->io_mutex);
+
+	return le32_to_cpu(val);
+}
+
+void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
+				u8 *addr, u8 val, u8 idx)
+{
+	mutex_lock(&priv->io_mutex);
+
+	priv->io_dmabuf->bits8 = val;
+	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
+			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
+}
+
+void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
+				__le16 *addr, u16 val, u8 idx)
+{
+	mutex_lock(&priv->io_mutex);
+
+	priv->io_dmabuf->bits16 = cpu_to_le16(val);
+	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
+			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
+}
+
+void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
+				__le32 *addr, u32 val, u8 idx)
+{
+	mutex_lock(&priv->io_mutex);
+
+	priv->io_dmabuf->bits32 = cpu_to_le32(val);
+	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
+			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
+}
+
 static void rtl8225_write_bitbang(struct ieee80211_hw *dev, u8 addr, u16 data)
 {
 	struct rtl8187_priv *priv = dev->priv;
-- 
1.8.1.4

