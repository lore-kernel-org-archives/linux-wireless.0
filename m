Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37267 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932174AbcLPHiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 02:38:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uBG7K65J003841
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 23:26:37 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 27bnjfdxh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 23:26:37 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: change width of MAC control variable
Date: Fri, 16 Dec 2016 12:55:44 +0530
Message-ID: <1481873145-5381-1-git-send-email-akarwar@marvell.com> (sfid-20161216_083812_144058_C4038C84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware has started making use of reserved field.
Accordingly change curr_pkt_filter from u16 to u32.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      | 18 ++++++++----------
 drivers/net/wireless/marvell/mwifiex/main.h    |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index ea45594..f48247c 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -434,14 +434,13 @@ enum mwifiex_channel_flags {
 #define HostCmd_ACT_BITWISE_SET               0x0002
 #define HostCmd_ACT_BITWISE_CLR               0x0003
 #define HostCmd_RESULT_OK                     0x0000
-
-#define HostCmd_ACT_MAC_RX_ON                 0x0001
-#define HostCmd_ACT_MAC_TX_ON                 0x0002
-#define HostCmd_ACT_MAC_WEP_ENABLE            0x0008
-#define HostCmd_ACT_MAC_ETHERNETII_ENABLE     0x0010
-#define HostCmd_ACT_MAC_PROMISCUOUS_ENABLE    0x0080
-#define HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE  0x0100
-#define HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON     0x2000
+#define HostCmd_ACT_MAC_RX_ON                 BIT(0)
+#define HostCmd_ACT_MAC_TX_ON                 BIT(1)
+#define HostCmd_ACT_MAC_WEP_ENABLE            BIT(3)
+#define HostCmd_ACT_MAC_ETHERNETII_ENABLE     BIT(4)
+#define HostCmd_ACT_MAC_PROMISCUOUS_ENABLE    BIT(7)
+#define HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE  BIT(8)
+#define HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON BIT(13)
 
 #define HostCmd_BSS_MODE_IBSS               0x0002
 #define HostCmd_BSS_MODE_ANY                0x0003
@@ -1084,8 +1083,7 @@ struct host_cmd_ds_802_11_mac_address {
 };
 
 struct host_cmd_ds_mac_control {
-	__le16 action;
-	__le16 reserved;
+	__le32 action;
 };
 
 struct host_cmd_ds_mac_multicast_adr {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5f7a010..5c82972 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -529,7 +529,7 @@ struct mwifiex_private {
 	u8 tx_timeout_cnt;
 	struct net_device *netdev;
 	struct net_device_stats stats;
-	u16 curr_pkt_filter;
+	u32 curr_pkt_filter;
 	u32 bss_mode;
 	u32 pkt_tx_ctrl;
 	u16 tx_power_level;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index ad2dfd8..2f1f4d1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -76,7 +76,7 @@
  */
 static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
-				   u16 cmd_action, u16 *action)
+				   u16 cmd_action, u32 *action)
 {
 	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
 
@@ -89,7 +89,7 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_CONTROL);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_mac_control) + S_DS_GEN);
-	mac_ctrl->action = cpu_to_le16(*action);
+	mac_ctrl->action = cpu_to_le32(*action);
 
 	return 0;
 }
-- 
1.9.1
