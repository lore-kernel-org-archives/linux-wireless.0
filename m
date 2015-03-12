Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17239 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbbCLI2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 04:28:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2C8NUSA002707
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:46 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t20qjehk4-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:46 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: use del_timer variant in interrupt context
Date: Thu, 12 Mar 2015 00:38:40 -0700
Message-ID: <1426145920-5288-3-git-send-email-akarwar@marvell.com> (sfid-20150312_092818_609307_8166F7C6)
In-Reply-To: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
References: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We might be in interrupt context at few places. So replace
del_timer_sync() with del_timer(). This patch fixes a kernel
trace problem seen occasionally during our testing.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c      | 2 +-
 drivers/net/wireless/mwifiex/sta_event.c | 4 ++--
 drivers/net/wireless/mwifiex/usb.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 74488ab..42bf884 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -247,7 +247,7 @@ process_start:
 		if (IS_CARD_RX_RCVD(adapter)) {
 			adapter->data_received = false;
 			adapter->pm_wakeup_fw_try = false;
-			del_timer_sync(&adapter->wakeup_timer);
+			del_timer(&adapter->wakeup_timer);
 			if (adapter->ps_state == PS_STATE_SLEEP)
 				adapter->ps_state = PS_STATE_AWAKE;
 		} else {
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 64c4223..0dc7a1d 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -312,7 +312,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					adapter->ps_state = PS_STATE_AWAKE;
 					adapter->pm_wakeup_card_req = false;
 					adapter->pm_wakeup_fw_try = false;
-					del_timer_sync(&adapter->wakeup_timer);
+					del_timer(&adapter->wakeup_timer);
 					break;
 				}
 				if (!mwifiex_send_null_packet
@@ -327,7 +327,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->ps_state = PS_STATE_AWAKE;
 		adapter->pm_wakeup_card_req = false;
 		adapter->pm_wakeup_fw_try = false;
-		del_timer_sync(&adapter->wakeup_timer);
+		del_timer(&adapter->wakeup_timer);
 
 		break;
 
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 2238730..8beb38c 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -1006,7 +1006,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	/* Simulation of HS_AWAKE event */
 	adapter->pm_wakeup_fw_try = false;
-	del_timer_sync(&adapter->wakeup_timer);
+	del_timer(&adapter->wakeup_timer);
 	adapter->pm_wakeup_card_req = false;
 	adapter->ps_state = PS_STATE_AWAKE;
 
-- 
1.8.1.4

