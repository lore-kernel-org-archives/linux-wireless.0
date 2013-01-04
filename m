Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45577 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab3ADFw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:52:29 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/5] mwifiex: add init_fw_port handler for PCIe interface
Date: Thu,  3 Jan 2013 21:21:29 -0800
Message-Id: <1357276892-32759-3-git-send-email-bzhao@marvell.com> (sfid-20130104_065241_777154_032F5C40)
In-Reply-To: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
References: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for init_fw_port handler for PCIe
interface, which resets RXBD read pointer for PCIe.
This fixes issue where RX doesn't work until some TX from
driver happens.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    6 ++++++
 drivers/net/wireless/mwifiex/main.h |    1 +
 drivers/net/wireless/mwifiex/pcie.c |   20 ++++++++++++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 39f03ce..e00b806 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -591,6 +591,12 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 				return -1;
 		}
 	}
+
+	if (adapter->if_ops.init_fw_port) {
+		if (adapter->if_ops.init_fw_port(adapter))
+			return -1;
+	}
+
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d717c98..ef02a5b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -599,6 +599,7 @@ struct mwifiex_if_ops {
 	int (*cmdrsp_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*data_complete) (struct mwifiex_adapter *, struct sk_buff *);
+	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
 };
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index e4c2cfd..191c682 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -966,8 +966,23 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	return 0;
 }
 
-/*
- * This function downloads commands to the device
+/* This function init rx port in firmware which in turn enables to receive data
+ * from device before transmitting any packet.
+ */
+static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	/* Write the RX ring read pointer in to REG_RXBD_RDPTR */
+	if (mwifiex_write_reg(adapter, REG_RXBD_RDPTR, card->rxbd_rdptr | 0)) {
+		dev_err(adapter->dev,
+			"RECV DATA: failed to write REG_RXBD_RDPTR\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* This function downloads commands to the device
  */
 static int
 mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
@@ -1899,6 +1914,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.event_complete =		mwifiex_pcie_event_complete,
 	.update_mp_end_port =		NULL,
 	.cleanup_mpa_buf =		NULL,
+	.init_fw_port =			mwifiex_pcie_init_fw_port,
 };
 
 /*
-- 
1.7.0.2

