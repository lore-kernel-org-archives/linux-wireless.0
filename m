Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032653AbeEXLGm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 07:06:42 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: avoid exporting mwifiex_send_cmd
Date: Thu, 24 May 2018 16:36:28 +0530
Message-ID: <1527159988-20624-1-git-send-email-gbhat@marvell.com> (sfid-20180524_130741_113459_C6708047)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a follow-up patch for commit 21c5c83ce833
("mwifiex: support sysfs initiated device coredump").

Let us avoid exporting mwifiex_send_cmd and instead use a utility
function mwifiex_fw_dump_event to achive the work.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 1 -
 drivers/net/wireless/marvell/mwifiex/main.h   | 1 +
 drivers/net/wireless/marvell/mwifiex/usb.c    | 5 ++---
 drivers/net/wireless/marvell/mwifiex/util.c   | 7 +++++++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 8be1e69..9cfcdf6 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -674,7 +674,6 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mwifiex_send_cmd);
 
 /*
  * This function queues a command to the command pending queue.
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 8ae74ed..69ac0a2 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1691,6 +1691,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 void mwifiex_prepare_fw_dump_info(struct mwifiex_adapter *adapter);
 void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
+void mwifiex_fw_dump_event(struct mwifiex_private *priv);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 int mwifiex_get_wakeup_reason(struct mwifiex_private *priv, u16 action,
 			      int cmd_type,
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 7aa39878..bc475b8 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -658,9 +658,8 @@ static void mwifiex_usb_coredump(struct device *dev)
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_card_rec *card = usb_get_intfdata(intf);
 
-	mwifiex_send_cmd(mwifiex_get_priv(card->adapter, MWIFIEX_BSS_ROLE_ANY),
-			 HostCmd_CMD_FW_DUMP_EVENT, HostCmd_ACT_GEN_SET, 0,
-			 NULL, true);
+	mwifiex_fw_dump_event(mwifiex_get_priv(card->adapter,
+					       MWIFIEX_BSS_ROLE_ANY));
 }
 
 static struct usb_driver mwifiex_usb_driver = {
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 51ccf10..6dd2128 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -757,3 +757,10 @@ void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags)
 	return skb;
 }
 EXPORT_SYMBOL_GPL(mwifiex_alloc_dma_align_buf);
+
+void mwifiex_fw_dump_event(struct mwifiex_private *priv)
+{
+	mwifiex_send_cmd(priv, HostCmd_CMD_FW_DUMP_EVENT, HostCmd_ACT_GEN_SET,
+			 0, NULL, true);
+}
+EXPORT_SYMBOL_GPL(mwifiex_fw_dump_event);
-- 
1.9.1
