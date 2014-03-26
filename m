Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9439 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbaCZCBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 22:01:49 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: cancel pending commands during host sleep
Date: Tue, 25 Mar 2014 19:01:20 -0700
Message-ID: <1395799280-29221-3-git-send-email-bzhao@marvell.com> (sfid-20140326_030153_692063_40DE9779)
In-Reply-To: <1395799280-29221-1-git-send-email-bzhao@marvell.com>
References: <1395799280-29221-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Sometimes we may end up downloading other commands when host
sleep is configured. This patch makes sure that pending
commands are cancelled and we stop queueing further commands
during host sleep.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c    | 5 +++++
 drivers/net/wireless/mwifiex/main.h      | 1 +
 drivers/net/wireless/mwifiex/pcie.c      | 1 +
 drivers/net/wireless/mwifiex/sdio.c      | 2 ++
 drivers/net/wireless/mwifiex/sta_ioctl.c | 3 +++
 drivers/net/wireless/mwifiex/usb.c       | 1 +
 6 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index cc81fcd..a23791d 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -509,6 +509,11 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		return -1;
 	}
 
+	if (adapter->hs_enabling && cmd_no != HostCmd_CMD_802_11_HS_CFG_ENH) {
+		dev_err(adapter->dev, "PREP_CMD: host entering sleep state\n");
+		return -1;
+	}
+
 	if (adapter->surprise_removed) {
 		dev_err(adapter->dev, "PREP_CMD: card is removed\n");
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a67f7da..d53e1e8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -774,6 +774,7 @@ struct mwifiex_adapter {
 	u16 hs_activate_wait_q_woken;
 	wait_queue_head_t hs_activate_wait_q;
 	bool is_suspended;
+	bool hs_enabling;
 	u8 event_body[MAX_EVENT_SIZE];
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 57c353a..38c2837 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -120,6 +120,7 @@ static int mwifiex_pcie_suspend(struct device *dev)
 
 	/* Indicate device suspended */
 	adapter->is_suspended = true;
+	adapter->hs_enabling = false;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index e0dcd3e..d206f04 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -237,6 +237,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	/* Enable the Host Sleep */
 	if (!mwifiex_enable_hs(adapter)) {
 		dev_err(adapter->dev, "cmd: failed to suspend\n");
+		adapter->hs_enabling = false;
 		return -EFAULT;
 	}
 
@@ -245,6 +246,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 
 	/* Indicate device suspended */
 	adapter->is_suspended = true;
+	adapter->hs_enabling = false;
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fcb791c..8942706 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -509,6 +509,9 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
 	hscfg.is_invoke_hostcmd = true;
 
+	adapter->hs_enabling = true;
+	mwifiex_cancel_all_pending_cmd(adapter);
+
 	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
 						   MWIFIEX_BSS_ROLE_STA),
 				  HostCmd_ACT_GEN_SET, MWIFIEX_SYNC_CMD,
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index ae30c39..edbe4af 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -459,6 +459,7 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	 * 'suspended' state and a 'disconnect' one.
 	 */
 	adapter->is_suspended = true;
+	adapter->hs_enabling = false;
 
 	if (atomic_read(&card->rx_cmd_urb_pending) && card->rx_cmd.urb)
 		usb_kill_urb(card->rx_cmd.urb);
-- 
1.8.2.3

