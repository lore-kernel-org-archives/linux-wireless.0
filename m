Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14961 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbaDNWbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:31:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.15] mwifiex: process event before command response
Date: Mon, 14 Apr 2014 15:31:05 -0700
Message-ID: <1397514666-4656-1-git-send-email-bzhao@marvell.com> (sfid-20140415_003121_799353_D3BBE6A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

During extended scan, SCAN report event is always followed by
command response. Sometimes It is observed that command response
is processed before SCAN report which leads to a crash, because
current command node is cleared while handling the response.
This patch makes sure that driver's main thread gives priority
to events over command responses.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 77db088..9c771b3 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -292,6 +292,12 @@ process_start:
 			while ((skb = skb_dequeue(&adapter->usb_rx_data_q)))
 				mwifiex_handle_rx_packet(adapter, skb);
 
+		/* Check for event */
+		if (adapter->event_received) {
+			adapter->event_received = false;
+			mwifiex_process_event(adapter);
+		}
+
 		/* Check for Cmd Resp */
 		if (adapter->cmd_resp_received) {
 			adapter->cmd_resp_received = false;
@@ -304,12 +310,6 @@ process_start:
 			}
 		}
 
-		/* Check for event */
-		if (adapter->event_received) {
-			adapter->event_received = false;
-			mwifiex_process_event(adapter);
-		}
-
 		/* Check if we need to confirm Sleep Request
 		   received previously */
 		if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
-- 
1.8.2.3

