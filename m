Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11285 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1IEOjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 10:39:18 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/4] ath6kl: Fix WMI message structure for AP_SET_PVB
Date: Mon, 5 Sep 2011 17:38:44 +0300
Message-ID: <1315233527-6234-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20110905_163920_994622_A904E47E)
In-Reply-To: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a 2-octet reserved field between the flag and aid fields. Fix
that to make the target actually behave as requested.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c9ec630..b2c5c40 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2740,6 +2740,7 @@ int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag)
 
 	cmd = (struct wmi_ap_set_pvb_cmd *) skb->data;
 	cmd->aid = cpu_to_le16(aid);
+	cmd->rsvd = cpu_to_le16(0);
 	cmd->flag = cpu_to_le32(flag);
 
 	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_AP_SET_PVB_CMDID,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index a78e21b..e86b81d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1922,6 +1922,7 @@ struct wmi_ap_set_mlme_cmd {
 
 struct wmi_ap_set_pvb_cmd {
 	__le32 flag;
+	__le16 rsvd;
 	__le16 aid;
 } __packed;
 
-- 
1.7.4.1

