Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n32.bullet.mail.ukl.yahoo.com ([87.248.110.149]:38567 "HELO
	n32.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751388AbYGHGa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 02:30:29 -0400
Message-ID: <48730B63.8050606@yahoo.co.uk> (sfid-20080708_083032_713195_807F4C57)
Date: Tue, 08 Jul 2008 07:38:27 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@redhat.com>, flamingice@sourmilk.net,
	Andrea Merello <andreamrl@tiscali.it>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 1/6] rtl8187: updating rtl8187.h to support RTL8187B
References: <4873088C.2090603@yahoo.co.uk>
In-Reply-To: <4873088C.2090603@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187: updating rtl8187.h to support RTL8187B

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index a0cfb66..3afb49f 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -44,17 +44,48 @@ struct rtl8187_rx_hdr {
  	__le64 mac_time;
  } __attribute__((packed));

-struct rtl8187_tx_hdr {
+struct rtl8187b_rx_hdr {
  	__le32 flags;
+	__le64 mac_time;
+	u8 noise;
+	u8 signal;
+	u8 agc;
+	u8 reserved;
+	__le32 unused;
+} __attribute__((packed));
+
+/* {rtl8187,rtl8187b}_tx_info is in skb */
+
+/* Tx flags are common between rtl8187 and rtl8187b */
  #define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
  #define RTL8187_TX_FLAG_MORE_FRAG	(1 << 17)
  #define RTL8187_TX_FLAG_CTS		(1 << 18)
  #define RTL8187_TX_FLAG_RTS		(1 << 23)
+
+struct rtl8187_tx_hdr {
+	__le32 flags;
  	__le16 rts_duration;
  	__le16 len;
  	__le32 retry;
  } __attribute__((packed));

+struct rtl8187b_tx_hdr {
+	__le32 flags;
+	__le16 rts_duration;
+	__le16 len;
+	__le32 unused_1;
+	__le16 unused_2;
+	__le16 tx_duration;
+	__le32 unused_3;
+	__le32 retry;
+	__le32 unused_4[2];
+} __attribute__((packed));
+
+enum {
+	DEVICE_RTL8187,
+	DEVICE_RTL8187B
+};
+
  struct rtl8187_priv {
  	/* common between rtl818x drivers */
  	struct rtl818x_csr *map;
@@ -70,70 +101,120 @@ struct rtl8187_priv {
  	u32 rx_conf;
  	u16 txpwr_base;
  	u8 asic_rev;
+	u8 is_rtl8187b;
+	enum {
+		RTL8187BvB,
+		RTL8187BvD,
+		RTL8187BvE
+	} hw_rev;
  	struct sk_buff_head rx_queue;
+	u8 signal;
+	u8 quality;
+	u8 noise;
  };

  void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);

-static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
+static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
+				     u8 *addr, u8 idx)
  {
  	u8 val;

  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);

  	return val;
  }

-static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
+static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
+{
+	return rtl818x_ioread8_idx(priv, addr, 0);
+}
+
+static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
+				       __le16 *addr, u8 idx)
  {
  	__le16 val;

  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);

  	return le16_to_cpu(val);
  }

-static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
+static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
+{
+	return rtl818x_ioread16_idx(priv, addr, 0);
+}
+
+static inline u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
+				       __le32 *addr, u8 idx)
  {
  	__le32 val;

  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);

  	return le32_to_cpu(val);
  }

-static inline void rtl818x_iowrite8(struct rtl8187_priv *priv,
-				    u8 *addr, u8 val)
+static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
+{
+	return rtl818x_ioread32_idx(priv, addr, 0);
+}
+
+static inline void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
+					u8 *addr, u8 val, u8 idx)
  {
  	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
  			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &val,
+			sizeof(val), HZ / 2);
+}
+
+static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
+{
+	rtl818x_iowrite8_idx(priv, addr, val, 0);
  }

-static inline void rtl818x_iowrite16(struct rtl8187_priv *priv,
-				     __le16 *addr, u16 val)
+static inline void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
+					 __le16 *addr, u16 val, u8 idx)
  {
  	__le16 buf = cpu_to_le16(val);

  	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
  			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
+			HZ / 2);
  }

-static inline void rtl818x_iowrite32(struct rtl8187_priv *priv,
-				     __le32 *addr, u32 val)
+static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
+				     u16 val)
+{
+	rtl818x_iowrite16_idx(priv, addr, val, 0);
+}
+
+static inline void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
+					 __le32 *addr, u32 val, u8 idx)
  {
  	__le32 buf = cpu_to_le32(val);

  	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
  			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, 0, &buf, sizeof(buf), HZ / 2);
+			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
+			HZ / 2);
+}
+
+static inline void rtl818x_iowrite32(struct rtl8187_priv *priv, __le32 *addr,
+				     u32 val)
+{
+	rtl818x_iowrite32_idx(priv, addr, val, 0);
  }

  #endif /* RTL8187_H */

