Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42203 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbaLaKig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 05:38:36 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/9] mwifiex: add wakeup timer based recovery mechanism
Date: Wed, 31 Dec 2014 02:36:41 -0800
Message-ID: <1420022206-11435-5-git-send-email-akarwar@marvell.com> (sfid-20141231_113840_793277_B4B5C1ED)
In-Reply-To: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
References: <1420022206-11435-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If host fails to wakeup the firmware, we will trigger card reset
after 3 second timeout.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c      | 16 ++++++++++++++++
 drivers/net/wireless/mwifiex/main.c      |  2 ++
 drivers/net/wireless/mwifiex/main.h      |  1 +
 drivers/net/wireless/mwifiex/pcie.c      |  1 +
 drivers/net/wireless/mwifiex/sta_event.c |  3 +++
 drivers/net/wireless/mwifiex/usb.c       |  1 +
 6 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index a3dd601..524692a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -52,6 +52,18 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	return 0;
 }
 
+static void wakeup_timer_fn(unsigned long data)
+{
+	struct mwifiex_adapter *adapter = (struct mwifiex_adapter *)data;
+
+	dev_err(adapter->dev, "Firmware wakeup failed\n");
+	adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
+	mwifiex_cancel_all_pending_cmd(adapter);
+
+	if (adapter->if_ops.card_reset)
+		adapter->if_ops.card_reset(adapter);
+}
+
 /*
  * This function initializes the private structure and sets default
  * values to the members.
@@ -285,6 +297,9 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->ext_scan = true;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
+
+	setup_timer(&adapter->wakeup_timer, wakeup_timer_fn,
+		    (unsigned long)adapter);
 }
 
 /*
@@ -391,6 +406,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 		return;
 	}
 
+	del_timer(&adapter->wakeup_timer);
 	mwifiex_cancel_all_pending_cmd(adapter);
 
 	/* Free lock variables */
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2d4047f..119e875 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -237,6 +237,7 @@ process_start:
 		    (is_command_pending(adapter) ||
 		     !mwifiex_wmm_lists_empty(adapter))) {
 			adapter->pm_wakeup_fw_try = true;
+			mod_timer(&adapter->wakeup_timer, jiffies + (HZ*3));
 			adapter->if_ops.wakeup(adapter);
 			continue;
 		}
@@ -244,6 +245,7 @@ process_start:
 		if (IS_CARD_RX_RCVD(adapter)) {
 			adapter->data_received = false;
 			adapter->pm_wakeup_fw_try = false;
+			del_timer_sync(&adapter->wakeup_timer);
 			if (adapter->ps_state == PS_STATE_SLEEP)
 				adapter->ps_state = PS_STATE_AWAKE;
 		} else {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f927939..55273ee 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -830,6 +830,7 @@ struct mwifiex_adapter {
 	u16 gen_null_pkt;
 	u16 pps_uapsd_mode;
 	u32 pm_wakeup_fw_try;
+	struct timer_list wakeup_timer;
 	u8 is_hs_configured;
 	struct mwifiex_hs_config_param hs_cfg;
 	u8 hs_activated;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c3a20f9..10e4a93 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2064,6 +2064,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 				 * state until cookie is set */
 				adapter->ps_state = PS_STATE_AWAKE;
 				adapter->pm_wakeup_fw_try = false;
+				del_timer(&adapter->wakeup_timer);
 		}
 	}
 }
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index fbec95b..419e35f 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -312,6 +312,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					adapter->ps_state = PS_STATE_AWAKE;
 					adapter->pm_wakeup_card_req = false;
 					adapter->pm_wakeup_fw_try = false;
+					mod_timer(&adapter->wakeup_timer,
+						  jiffies + (HZ*3));
 					break;
 				}
 				if (!mwifiex_send_null_packet
@@ -326,6 +328,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->ps_state = PS_STATE_AWAKE;
 		adapter->pm_wakeup_card_req = false;
 		adapter->pm_wakeup_fw_try = false;
+		del_timer_sync(&adapter->wakeup_timer);
 
 		break;
 
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 8ae7a85..199b43f 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -990,6 +990,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	/* Simulation of HS_AWAKE event */
 	adapter->pm_wakeup_fw_try = false;
+	del_timer_sync(&adapter->wakeup_timer);
 	adapter->pm_wakeup_card_req = false;
 	adapter->ps_state = PS_STATE_AWAKE;
 
-- 
1.8.1.4

