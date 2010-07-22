Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54821 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0GVSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] atmel: silence sparse warnings
Date: Thu, 22 Jul 2010 14:24:01 -0400
Message-Id: <1279823041-21156-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/atmel.c
drivers/net/wireless/atmel.c:3694:30: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3695:31: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3696:30: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3697:32: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3698:30: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3699:31: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3700:30: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3701:32: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3702:32: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3703:30: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3704:32: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3705:32: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3706:28: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3707:29: warning: cast to restricted __le16

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is this any better than what we have now??

 drivers/net/wireless/atmel.c |   73 ++++++++++++++++++++++++++++++++----------
 1 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index c8f7090..008d712 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3617,6 +3617,7 @@ static void atmel_command_irq(struct atmel_private *priv)
 static int atmel_wakeup_firmware(struct atmel_private *priv)
 {
 	struct host_info_struct *iface = &priv->host_info;
+	u8 buf[sizeof(struct host_info_struct)];
 	u16 mr1, mr3;
 	int i;
 
@@ -3688,23 +3689,61 @@ static int atmel_wakeup_firmware(struct atmel_private *priv)
 		return -EIO;
 	}
 
-	atmel_copy_to_host(priv->dev, (unsigned char *)iface,
-			   priv->host_info_base, sizeof(*iface));
-
-	iface->tx_buff_pos = le16_to_cpu(iface->tx_buff_pos);
-	iface->tx_buff_size = le16_to_cpu(iface->tx_buff_size);
-	iface->tx_desc_pos = le16_to_cpu(iface->tx_desc_pos);
-	iface->tx_desc_count = le16_to_cpu(iface->tx_desc_count);
-	iface->rx_buff_pos = le16_to_cpu(iface->rx_buff_pos);
-	iface->rx_buff_size = le16_to_cpu(iface->rx_buff_size);
-	iface->rx_desc_pos = le16_to_cpu(iface->rx_desc_pos);
-	iface->rx_desc_count = le16_to_cpu(iface->rx_desc_count);
-	iface->build_version = le16_to_cpu(iface->build_version);
-	iface->command_pos = le16_to_cpu(iface->command_pos);
-	iface->major_version = le16_to_cpu(iface->major_version);
-	iface->minor_version = le16_to_cpu(iface->minor_version);
-	iface->func_ctrl = le16_to_cpu(iface->func_ctrl);
-	iface->mac_status = le16_to_cpu(iface->mac_status);
+	atmel_copy_to_host(priv->dev, (unsigned char *)&buf,
+			   priv->host_info_base, sizeof(buf));
+
+	iface->int_status = buf[offsetof(struct host_info_struct,
+						int_status)];
+	iface->int_mask = buf[offsetof(struct host_info_struct, int_mask)];
+	iface->lockout_host = buf[offsetof(struct host_info_struct,
+						lockout_host)];
+	iface->lockout_mac = buf[offsetof(struct host_info_struct,
+						lockout_mac)];
+	iface->tx_buff_pos =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						tx_buff_pos)]);
+	iface->tx_buff_size =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						tx_buff_size)]);
+	iface->tx_desc_pos =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						tx_desc_pos)]);
+	iface->tx_desc_count =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						tx_desc_count)]);
+	iface->rx_buff_pos =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						rx_buff_pos)]);
+	iface->rx_buff_size =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						rx_buff_size)]);
+	iface->rx_desc_pos =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						rx_desc_pos)]);
+	iface->rx_desc_count =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						rx_desc_count)]);
+	iface->build_version =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						build_version)]);
+	iface->command_pos =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						command_pos)]);
+	iface->major_version =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						major_version)]);
+	iface->minor_version =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						minor_version)]);
+	iface->func_ctrl =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						func_ctrl)]);
+	iface->mac_status =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						mac_status)]);
+	iface->generic_IRQ_type =
+		le16_to_cpu(*(__le16 *)&buf[offsetof(struct host_info_struct,
+						generic_IRQ_type)]);
 
 	return 0;
 }
-- 
1.7.1.1

