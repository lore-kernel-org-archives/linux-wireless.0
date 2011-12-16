Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558Ab1LPIyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 03:54:45 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Avoid taking struct as argument in ath6kl_wmi_set_ip_cmd
Date: Fri, 16 Dec 2011 14:24:23 +0530
Message-ID: <1324025664-4896-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111216_095451_260174_49AA3202)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this way, caller is free to pass only the value of IP addr
to configure.

In addition to this,
  * 'ips' variable data type in struct wmi_set_ip_cmd is changed
     from __le32 to __be32 in order to match network byte order.
  *  ipv4_is_multicast() is used to validate multicast ip addr.
  *  New argument if_idx is added to supply correct vif index
     to ath6kl_wmi_cmd_send().

This will be used in the next patch.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   12 +++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.h |    5 +++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f6f2aa2..1e31c38 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2479,15 +2479,16 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
 	return ret;
 }
 
-int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
+int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, u8 if_idx,
+			  __be32 ips0, __be32 ips1)
 {
 	struct sk_buff *skb;
 	struct wmi_set_ip_cmd *cmd;
 	int ret;
 
 	/* Multicast address are not valid */
-	if ((*((u8 *) &ip_cmd->ips[0]) >= 0xE0) ||
-	    (*((u8 *) &ip_cmd->ips[1]) >= 0xE0))
+	if (ipv4_is_multicast(ips0) ||
+	    ipv4_is_multicast(ips1))
 		return -EINVAL;
 
 	skb = ath6kl_wmi_get_new_buf(sizeof(struct wmi_set_ip_cmd));
@@ -2495,9 +2496,10 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
 		return -ENOMEM;
 
 	cmd = (struct wmi_set_ip_cmd *) skb->data;
-	memcpy(cmd, ip_cmd, sizeof(struct wmi_set_ip_cmd));
+	cmd->ips[0] = ips0;
+	cmd->ips[1] = ips1;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_IP_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_IP_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 42ac311..96e3cc1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1903,7 +1903,7 @@ struct wow_filter {
 
 struct wmi_set_ip_cmd {
 	/* IP in network byte order */
-	__le32 ips[MAX_IP_ADDRS];
+	__be32 ips[MAX_IP_ADDRS];
 } __packed;
 
 enum ath6kl_wow_filters {
@@ -2417,7 +2417,8 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
-int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, u8 if_idx,
+			  __be32 ips0, __be32 ips1);
 int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 				       enum ath6kl_host_mode host_mode);
 int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
-- 
1.7.1

