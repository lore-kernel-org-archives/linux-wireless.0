Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:60038 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757899Ab2FUC7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 22:59:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: improve error path handling in usb.c
Date: Wed, 20 Jun 2012 19:58:35 -0700
Message-Id: <1340247517-4593-4-git-send-email-bzhao@marvell.com> (sfid-20120621_045910_771119_76433C88)
In-Reply-To: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
References: <1340247517-4593-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

skb allocated during initialisation is reused for receiving
commands/events by USB interface. We miss to reset skb->data in
failure cases. This patch takes care of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index e6d796f..22a5916 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -49,6 +49,7 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 	struct device *dev = adapter->dev;
 	u32 recv_type;
 	__le32 tmp;
+	int ret;
 
 	if (adapter->hs_activated)
 		mwifiex_process_hs_config(adapter);
@@ -69,16 +70,19 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		case MWIFIEX_USB_TYPE_CMD:
 			if (skb->len > MWIFIEX_SIZE_OF_CMD_BUFFER) {
 				dev_err(dev, "CMD: skb->len too large\n");
-				return -1;
+				ret = -1;
+				goto exit_restore_skb;
 			} else if (!adapter->curr_cmd) {
 				dev_dbg(dev, "CMD: no curr_cmd\n");
 				if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 					mwifiex_process_sleep_confirm_resp(
 							adapter, skb->data,
 							skb->len);
-					return 0;
+					ret = 0;
+					goto exit_restore_skb;
 				}
-				return -1;
+				ret = -1;
+				goto exit_restore_skb;
 			}
 
 			adapter->curr_cmd->resp_skb = skb;
@@ -87,7 +91,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 		case MWIFIEX_USB_TYPE_EVENT:
 			if (skb->len < sizeof(u32)) {
 				dev_err(dev, "EVENT: skb->len too small\n");
-				return -1;
+				ret = -1;
+				goto exit_restore_skb;
 			}
 			skb_copy_from_linear_data(skb, &tmp, sizeof(u32));
 			adapter->event_cause = le32_to_cpu(tmp);
@@ -95,7 +100,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 
 			if (skb->len > MAX_EVENT_SIZE) {
 				dev_err(dev, "EVENT: event body too large\n");
-				return -1;
+				ret = -1;
+				goto exit_restore_skb;
 			}
 
 			memcpy(adapter->event_body, skb->data +
@@ -124,6 +130,12 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 	}
 
 	return -EINPROGRESS;
+
+exit_restore_skb:
+	/* The buffer will be reused for further cmds/events */
+	skb_push(skb, INTF_HEADER_LEN);
+
+	return ret;
 }
 
 static void mwifiex_usb_rx_complete(struct urb *urb)
-- 
1.7.0.2

