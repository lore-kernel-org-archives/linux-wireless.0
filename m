Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab1EFS2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Cindy H. Kao" <cindy.h.kao@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/7] iwlwifi: support the svtool messages interactions through nl80211 test mode
Date: Fri,  6 May 2011 11:04:34 -0700
Message-Id: <1304705080-29349-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202849_112384_4EDE484C)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cindy H. Kao <cindy.h.kao@intel.com>

This patch adds the feature to support the test mode operation through
the generic netlink channel NL80211_CMD_TESTMODE between intel
wireless device iwlwifi and the user space application svtool.

The main purpose is to create a transportation layer between the iwlwifi
device and the user space application so that the interaction between the
user space application svtool and the iwlwifi device in the kernel space is
in a way of generic netlink messaging.

The detail specific functions are:

1. The function iwl_testmode_cmd() is added to digest the svtool test command
   from the user space application. The svtool test commands are categorized  to
   three types : commands to be processed by the device ucode, commands to access
   the registers, and commands to be processed at the driver level(such as reload
   the ucode). iwl_testmode_cmd() dispatches the commands the corresponding handlers
   and reply to user space regarding the command execution status. Extra data is
   returned to the user space application if there's any.

2. The function iwl_testmode_ucode_rx_pkt() is added to multicast all the spontaneous
   messages from the iwlwifi device to the user space. Regardless the message types,
   whenever there is a valid spontaneous message received by the iwlwifi ISR,
   iwl_testmode_ucode_rx_pkt() is invoked to multicast the message content to user
   space. The message content is not attacked and the message parsing is left to
   the user space application.

Implementation guidelines:

1. The generic netlink messaging for iwliwif test mode is through  NL80211_CMD_TESTMODE
   channel, therefore, the codes need to follow the regulations set by cfg80211.ko
   to get the actual device instance ieee80211_ops via cfg80211.ko, so that the iwlwifi
   device is indicated with ieee80211_ops and can be actually accessed.

   Therefore, a callback iwl_testmode_cmd() is added to the structure
   iwlagn_hw_ops in iwl-agn.c.

2. It intends to utilize those low level device access APIs from iwlwifi device driver
   (ie. iwlagn.ko) rather than creating it's own set of device access functions.
   For example, iwl_send_cmd(), iwl_read32(), iwl_write8(), and iwl_write32() are reused.

3. The main functions are maintained in new files instead of spreading all over the
   existing iwlwifi driver files.

   The new files added are :

   drivers/net/wireless/iwlwifi/iwl-sv-open.c
        - to handle the user space test mode application command
          and reply the respective command status to the user space application.
        - to multicast the spontaneous messages from device to user space.

   drivers/net/wireless/iwlwifi/iwl-testmode.h
        - the commonly referenced definitions for the TLVs used in
          the generic netlink messages

Signed-off-by: Cindy H. Kao <cindy.h.kao@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig         |   10 +
 drivers/net/wireless/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   17 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |  469 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h  |  151 +++++++++
 8 files changed, 656 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-sv-open.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 17d555f..ad3bdba 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -102,6 +102,16 @@ config IWLWIFI_DEVICE_TRACING
 	  occur.
 endmenu
 
+config IWLWIFI_DEVICE_SVTOOL
+	bool "iwlwifi device svtool support"
+	depends on IWLAGN
+	select NL80211_TESTMODE
+	help
+	  This option enables the svtool support for iwlwifi device through
+	  NL80211_TESTMODE. svtool is a software validation tool that runs in
+	  the user space and interacts with the device in the kernel space
+	  through the generic netlink message via NL80211_TESTMODE channel.
+
 config IWL_P2P
 	bool "iwlwifi experimental P2P support"
 	depends on IWLAGN
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 89a41d3..8226604 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -16,6 +16,7 @@ iwlagn-objs             += iwl-2000.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
+iwlagn-$(CONFIG_IWLWIFI_DEVICE_SVTOOL) += iwl-sv-open.o
 
 CFLAGS_iwl-devtrace.o := -I$(src)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index c3ae2e4..8bda0e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -269,7 +269,7 @@ void iwlagn_rx_calib_result(struct iwl_priv *priv,
 	iwl_calib_set(&priv->calib_results[index], pkt->u.raw, len);
 }
 
-static int iwlagn_init_alive_start(struct iwl_priv *priv)
+int iwlagn_init_alive_start(struct iwl_priv *priv)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 003d524..09fe841 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -776,6 +776,8 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 			wake_up_all(&priv->_agn.notif_waitq);
 		}
+		if (priv->pre_rx_handler)
+			priv->pre_rx_handler(priv, rxb);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
@@ -2211,7 +2213,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by iwl_init_alive_start()).
  */
-static int iwl_alive_start(struct iwl_priv *priv)
+int iwl_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
@@ -3507,6 +3509,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
 	.offchannel_tx = iwl_mac_offchannel_tx,
 	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
+	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
 };
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
@@ -3816,6 +3819,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
+	iwl_testmode_init(priv);
 
 	/*********************************************
 	 * 8. Enable interrupts and read RFKILL state
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index b477336..aa398b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -344,5 +344,22 @@ iwlagn_wait_notification(struct iwl_priv *priv,
 void __releases(wait_entry)
 iwlagn_remove_notification(struct iwl_priv *priv,
 			   struct iwl_notification_wait *wait_entry);
+extern int iwlagn_init_alive_start(struct iwl_priv *priv);
+extern int iwl_alive_start(struct iwl_priv *priv);
+/* svtool */
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+extern int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len);
+extern void iwl_testmode_init(struct iwl_priv *priv);
+#else
+static inline
+int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+{
+	return -ENOSYS;
+}
+static inline
+void iwl_testmode_init(struct iwl_priv *priv)
+{
+}
+#endif
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f098eff..3d28ad2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1194,6 +1194,8 @@ struct iwl_priv {
 
 	enum ieee80211_band band;
 
+	void (*pre_rx_handler)(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb);
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
new file mode 100644
index 0000000..89b6696
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -0,0 +1,469 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/net_namespace.h>
+#include <linux/netdevice.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
+#include <net/netlink.h>
+
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-debug.h"
+#include "iwl-fh.h"
+#include "iwl-io.h"
+#include "iwl-agn.h"
+#include "iwl-testmode.h"
+
+
+/* The TLVs used in the gnl message policy between the kernel module and
+ * user space application. iwl_testmode_gnl_msg_policy is to be carried
+ * through the NL80211_CMD_TESTMODE channel regulated by nl80211.
+ * See iwl-testmode.h
+ */
+static
+struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
+	[IWL_TM_ATTR_COMMAND] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_UCODE_CMD_ID] = { .type = NLA_U8, },
+	[IWL_TM_ATTR_UCODE_CMD_DATA] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_REG_OFFSET] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_REG_VALUE8] = { .type = NLA_U8, },
+	[IWL_TM_ATTR_REG_VALUE32] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_SYNC_RSP] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_UCODE_RX_PKT] = { .type = NLA_UNSPEC, },
+};
+
+/*
+ * See the struct iwl_rx_packet in iwl-commands.h for the format of the
+ * received events from the device
+ */
+static inline int get_event_length(struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	if (pkt)
+		return le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	else
+		return 0;
+}
+
+
+/*
+ * This function multicasts the spontaneous messages from the device to the
+ * user space. It is invoked whenever there is a received messages
+ * from the device. This function is called within the ISR of the rx handlers
+ * in iwlagn driver.
+ *
+ * The parsing of the message content is left to the user space application,
+ * The message content is treated as unattacked raw data and is encapsulated
+ * with IWL_TM_ATTR_UCODE_RX_PKT multicasting to the user space.
+ *
+ * @priv: the instance of iwlwifi device
+ * @rxb: pointer to rx data content received by the ISR
+ *
+ * See the message policies and TLVs in iwl_testmode_gnl_msg_policy[].
+ * For the messages multicasting to the user application, the mandatory
+ * TLV fields are :
+ *	IWL_TM_ATTR_COMMAND must be IWL_TM_CMD_DEV2APP_UCODE_RX_PKT
+ *	IWL_TM_ATTR_UCODE_RX_PKT for carrying the message content
+ */
+
+static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct ieee80211_hw *hw = priv->hw;
+	struct sk_buff *skb;
+	void *data;
+	int length;
+
+	data = (void *)rxb_addr(rxb);
+	length = get_event_length(rxb);
+
+	if (!data || length == 0)
+		return;
+
+	skb = cfg80211_testmode_alloc_event_skb(hw->wiphy, 20 + length,
+								GFP_ATOMIC);
+	if (skb == NULL) {
+		IWL_DEBUG_INFO(priv,
+			 "Run out of memory for messages to user space ?\n");
+		return;
+	}
+	NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT);
+	NLA_PUT(skb, IWL_TM_ATTR_UCODE_RX_PKT, length, data);
+	cfg80211_testmode_event(skb, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+	IWL_DEBUG_INFO(priv, "Ouch, overran buffer, check allocation!\n");
+}
+
+void iwl_testmode_init(struct iwl_priv *priv)
+{
+	priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
+}
+
+/*
+ * This function handles the user application commands to the ucode.
+ *
+ * It retrieves the mandatory fields IWL_TM_ATTR_UCODE_CMD_ID and
+ * IWL_TM_ATTR_UCODE_CMD_DATA and calls to the handler to send the
+ * host command to the ucode.
+ *
+ * If any mandatory field is missing, -ENOMSG is replied to the user space
+ * application; otherwise, the actual execution result of the host command to
+ * ucode is replied.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_host_cmd cmd;
+
+	memset(&cmd, 0, sizeof(struct iwl_host_cmd));
+
+	if (!tb[IWL_TM_ATTR_UCODE_CMD_ID] ||
+	    !tb[IWL_TM_ATTR_UCODE_CMD_DATA]) {
+		IWL_DEBUG_INFO(priv,
+			"Error finding ucode command mandatory fields\n");
+		return -ENOMSG;
+	}
+
+	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
+	cmd.data = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.len = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
+				" len %d\n", cmd.id, cmd.flags, cmd.len);
+	/* ok, let's submit the command to ucode */
+	return iwl_send_cmd(priv, &cmd);
+}
+
+
+/*
+ * This function handles the user application commands for register access.
+ *
+ * It retrieves command ID carried with IWL_TM_ATTR_COMMAND and calls to the
+ * handlers respectively.
+ *
+ * If it's an unknown commdn ID, -ENOSYS is returned; or -ENOMSG if the
+ * mandatory fields(IWL_TM_ATTR_REG_OFFSET,IWL_TM_ATTR_REG_VALUE32,
+ * IWL_TM_ATTR_REG_VALUE8) are missing; Otherwise 0 is replied indicating
+ * the success of the command execution.
+ *
+ * If IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_REG_READ32, the register read
+ * value is returned with IWL_TM_ATTR_REG_VALUE32.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	u32 ofs, val32;
+	u8 val8;
+	struct sk_buff *skb;
+	int status = 0;
+
+	if (!tb[IWL_TM_ATTR_REG_OFFSET]) {
+		IWL_DEBUG_INFO(priv, "Error finding register offset\n");
+		return -ENOMSG;
+	}
+	ofs = nla_get_u32(tb[IWL_TM_ATTR_REG_OFFSET]);
+	IWL_INFO(priv, "testmode register access command offset 0x%x\n", ofs);
+
+	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	case IWL_TM_CMD_APP2DEV_REG_READ32:
+		val32 = iwl_read32(priv, ofs);
+		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
+
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_REG_VALUE32, val32);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv,
+				       "Error sending msg : %d\n", status);
+		break;
+	case IWL_TM_CMD_APP2DEV_REG_WRITE32:
+		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
+			IWL_DEBUG_INFO(priv,
+				       "Error finding value to write\n");
+			return -ENOMSG;
+		} else {
+			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
+			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
+			iwl_write32(priv, ofs, val32);
+		}
+		break;
+	case IWL_TM_CMD_APP2DEV_REG_WRITE8:
+		if (!tb[IWL_TM_ATTR_REG_VALUE8]) {
+			IWL_DEBUG_INFO(priv, "Error finding value to write\n");
+			return -ENOMSG;
+		} else {
+			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
+			IWL_INFO(priv, "8bit value to write 0x%x\n", val8);
+			iwl_write8(priv, ofs, val8);
+		}
+		break;
+	default:
+		IWL_DEBUG_INFO(priv, "Unknown testmode register command ID\n");
+		return -ENOSYS;
+	}
+
+	return status;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+
+static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
+{
+	struct iwl_notification_wait calib_wait;
+	int ret;
+
+	iwlagn_init_notification_wait(priv, &calib_wait,
+				      CALIBRATION_COMPLETE_NOTIFICATION,
+				      NULL, NULL);
+	ret = iwlagn_init_alive_start(priv);
+	if (ret) {
+		IWL_DEBUG_INFO(priv,
+			"Error configuring init calibration: %d\n", ret);
+		goto cfg_init_calib_error;
+	}
+
+	ret = iwlagn_wait_notification(priv, &calib_wait, 2 * HZ);
+	if (ret)
+		IWL_DEBUG_INFO(priv, "Error detecting"
+			" CALIBRATION_COMPLETE_NOTIFICATION: %d\n", ret);
+	return ret;
+
+cfg_init_calib_error:
+	iwlagn_remove_notification(priv, &calib_wait);
+	return ret;
+}
+
+/*
+ * This function handles the user application commands for driver.
+ *
+ * It retrieves command ID carried with IWL_TM_ATTR_COMMAND and calls to the
+ * handlers respectively.
+ *
+ * If it's an unknown commdn ID, -ENOSYS is replied; otherwise, the returned
+ * value of the actual command execution is replied to the user application.
+ *
+ * If there's any message responding to the user space, IWL_TM_ATTR_SYNC_RSP
+ * is used for carry the message while IWL_TM_ATTR_COMMAND must set to
+ * IWL_TM_CMD_DEV2APP_SYNC_RSP.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct sk_buff *skb;
+	unsigned char *rsp_data_ptr = NULL;
+	int status = 0, rsp_data_len = 0;
+
+	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
+		rsp_data_ptr = (unsigned char *)priv->cfg->name;
+		rsp_data_len = strlen(priv->cfg->name);
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+							rsp_data_len + 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv,
+				       "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
+			    IWL_TM_CMD_DEV2APP_SYNC_RSP);
+		NLA_PUT(skb, IWL_TM_ATTR_SYNC_RSP,
+			rsp_data_len, rsp_data_ptr);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv, "Error sending msg : %d\n",
+				       status);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
+		status = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_init,
+					   UCODE_SUBTYPE_INIT, -1);
+		if (status)
+			IWL_DEBUG_INFO(priv,
+				"Error loading init ucode: %d\n", status);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
+		iwl_testmode_cfg_init_calib(priv);
+		iwlagn_stop_device(priv);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
+		status = iwlagn_load_ucode_wait_alive(priv,
+					   &priv->ucode_rt,
+					   UCODE_SUBTYPE_REGULAR,
+					   UCODE_SUBTYPE_REGULAR_NEW);
+		if (status) {
+			IWL_DEBUG_INFO(priv,
+				"Error loading runtime ucode: %d\n", status);
+			break;
+		}
+		status = iwl_alive_start(priv);
+		if (status)
+			IWL_DEBUG_INFO(priv,
+				"Error starting the device: %d\n", status);
+		break;
+
+	default:
+		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
+		return -ENOSYS;
+	}
+	return status;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+/* The testmode gnl message handler that takes the gnl message from the
+ * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
+ * invoke the corresponding handlers.
+ *
+ * This function is invoked when there is user space application sending
+ * gnl message through the testmode tunnel NL80211_CMD_TESTMODE regulated
+ * by nl80211.
+ *
+ * It retrieves the mandatory field, IWL_TM_ATTR_COMMAND, before
+ * dispatching it to the corresponding handler.
+ *
+ * If IWL_TM_ATTR_COMMAND is missing, -ENOMSG is replied to user application;
+ * -ENOSYS is replied to the user application if the command is unknown;
+ * Otherwise, the command is dispatched to the respective handler.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @data: pointer to user space message
+ * @len: length in byte of @data
+ */
+int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+{
+	struct nlattr *tb[IWL_TM_ATTR_MAX - 1];
+	struct iwl_priv *priv = hw->priv;
+	int result;
+
+	result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
+			iwl_testmode_gnl_msg_policy);
+	if (result != 0) {
+		IWL_DEBUG_INFO(priv,
+			       "Error parsing the gnl message : %d\n", result);
+		return result;
+	}
+
+	/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
+	if (!tb[IWL_TM_ATTR_COMMAND]) {
+		IWL_DEBUG_INFO(priv, "Error finding testmode command type\n");
+		return -ENOMSG;
+	}
+	/* in case multiple accesses to the device happens */
+	mutex_lock(&priv->mutex);
+
+	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	case IWL_TM_CMD_APP2DEV_UCODE:
+		IWL_DEBUG_INFO(priv, "testmode cmd to uCode\n");
+		result = iwl_testmode_ucode(hw, tb);
+		break;
+	case IWL_TM_CMD_APP2DEV_REG_READ32:
+	case IWL_TM_CMD_APP2DEV_REG_WRITE32:
+	case IWL_TM_CMD_APP2DEV_REG_WRITE8:
+		IWL_DEBUG_INFO(priv, "testmode cmd to register\n");
+		result = iwl_testmode_reg(hw, tb);
+		break;
+	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
+	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
+	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
+	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
+		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
+		result = iwl_testmode_driver(hw, tb);
+		break;
+	default:
+		IWL_DEBUG_INFO(priv, "Unknown testmode command\n");
+		result = -ENOSYS;
+		break;
+	}
+
+	mutex_unlock(&priv->mutex);
+	return result;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
new file mode 100644
index 0000000..31f8949
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -0,0 +1,151 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __IWL_TESTMODE_H__
+#define __IWL_TESTMODE_H__
+
+#include <linux/types.h>
+
+
+/* Commands from user space to kernel space(IWL_TM_CMD_ID_APP2DEV_XX) and
+ * from and kernel space to user space(IWL_TM_CMD_ID_DEV2APP_XX).
+ * The command ID is carried with IWL_TM_ATTR_COMMAND. There are three types of
+ * of command from user space and two types of command from kernel space.
+ * See below.
+ */
+enum iwl_tm_cmd_t {
+	/* commands from user application to the uCode,
+	 * the actual uCode host command ID is carried with
+	 * IWL_TM_ATTR_UCODE_CMD_ID */
+	IWL_TM_CMD_APP2DEV_UCODE = 1,
+
+	/* commands from user applicaiton to access register */
+	IWL_TM_CMD_APP2DEV_REG_READ32,
+	IWL_TM_CMD_APP2DEV_REG_WRITE32,
+	IWL_TM_CMD_APP2DEV_REG_WRITE8,
+
+	/* commands fom user space for pure driver level operations */
+	IWL_TM_CMD_APP2DEV_GET_DEVICENAME,
+	IWL_TM_CMD_APP2DEV_LOAD_INIT_FW,
+	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB,
+	IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW,
+	/* if there is other new command for the driver layer operation,
+	 * append them here */
+
+
+	/* commands from kernel space to carry the synchronous response
+	 * to user application */
+	IWL_TM_CMD_DEV2APP_SYNC_RSP,
+
+	/* commands from kernel space to multicast the spontaneous messages
+	 * to user application */
+	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
+	IWL_TM_CMD_MAX,
+};
+
+enum iwl_tm_attr_t {
+	IWL_TM_ATTR_NOT_APPLICABLE = 0,
+
+	/* From user space to kernel space:
+	 * the command either destines to ucode, driver, or register;
+	 * See enum iwl_tm_cmd_t.
+	 *
+	 * From kernel space to user space:
+	 * the command either carries synchronous response,
+	 * or the spontaneous message multicast from the device;
+	 * See enum iwl_tm_cmd_t. */
+	IWL_TM_ATTR_COMMAND,
+
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE,
+	 * The mandatory fields are :
+	 * IWL_TM_ATTR_UCODE_CMD_ID for recognizable command ID;
+	 * IWL_TM_ATTR_COMMAND_FLAG for the flags of the commands;
+	 * The optional fields are:
+	 * IWL_TM_ATTR_UCODE_CMD_DATA for the actual command payload
+	 * to the ucode */
+	IWL_TM_ATTR_UCODE_CMD_ID,
+	IWL_TM_ATTR_UCODE_CMD_DATA,
+
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_REG_XXX,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_REG_OFFSET for the offset of the target register;
+	 * IWL_TM_ATTR_REG_VALUE8 or IWL_TM_ATTR_REG_VALUE32 for value */
+	IWL_TM_ATTR_REG_OFFSET,
+	IWL_TM_ATTR_REG_VALUE8,
+	IWL_TM_ATTR_REG_VALUE32,
+
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_SYNC_RSP,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_SYNC_RSP for the data content responding to the user
+	 * application command */
+	IWL_TM_ATTR_SYNC_RSP,
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_UCODE_RX_PKT for the data content multicast to the user
+	 * application */
+	IWL_TM_ATTR_UCODE_RX_PKT,
+
+	IWL_TM_ATTR_MAX,
+};
+
+
+#endif
-- 
1.7.0.4

