Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63418 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbcAGHnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 02:43:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u077e73R016039
	for <linux-wireless@vger.kernel.org>; Wed, 6 Jan 2016 23:43:08 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 209g1d8jdn-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2016 23:43:07 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 1/3] mwifiex: firmware download enhancements
Date: Wed, 6 Jan 2016 23:40:47 -0800
Message-ID: <1452152449-29803-1-git-send-email-akarwar@marvell.com> (sfid-20160107_084312_709321_6974409A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

Same chip is being used by WLAN as well as bluetooth
drivers. Each driver needs to check during initialisation
if firmware is already active or it needs to be freshly
downloaded. If one driver has started downloading the
firmware, other finds the winner flag as false.

mwifiex_check_fw_status() checks firmware status and also
check if WLAN is the winner for firmware downloading.

Once we detect that other interface is downloading
the firmware, we call this routine again with max
poll count to wait until firmware is ready.

This patch splits the routine to avoid checking
winner status unnecessarily multiple times and ensures
that correct messages are displayed to user.

Firmware status poll count is also increased to 150.

Signed-off-by: Chunfan Chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Correct the patch title and explain winner, loser and
other interface concept
---
 drivers/net/wireless/marvell/mwifiex/fw.h   |  2 +-
 drivers/net/wireless/marvell/mwifiex/init.c | 16 +++++++++---
 drivers/net/wireless/marvell/mwifiex/main.h |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c | 40 +++++++++++++++++------------
 drivers/net/wireless/marvell/mwifiex/sdio.c | 33 ++++++++++++++----------
 5 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index ced7af2..426e76a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -96,7 +96,7 @@ enum KEY_TYPE_ID {
 #define WAPI_KEY_LEN			(WLAN_KEY_LEN_SMS4 + PN_LEN + 2)
 
 #define MAX_POLL_TRIES			100
-#define MAX_FIRMWARE_POLL_TRIES			100
+#define MAX_FIRMWARE_POLL_TRIES			150
 
 #define FIRMWARE_READY_SDIO				0xfedc
 #define FIRMWARE_READY_PCIE				0xfedcba00
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 6f7876e..517653b 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -741,8 +741,6 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	u32 poll_num = 1;
 
 	if (adapter->if_ops.check_fw_status) {
-		adapter->winner = 0;
-
 		/* check if firmware is already running */
 		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 		if (!ret) {
@@ -750,13 +748,23 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 				    "WLAN FW already running! Skip FW dnld\n");
 			return 0;
 		}
+	}
+
+	/* check if we are the winner for downloading FW */
+	if (adapter->if_ops.check_winner_status) {
+		adapter->winner = 0;
+		ret = adapter->if_ops.check_winner_status(adapter);
 
 		poll_num = MAX_FIRMWARE_POLL_TRIES;
+		if (ret) {
+			mwifiex_dbg(adapter, MSG,
+				    "WLAN read winner status failed!\n");
+			return ret;
+		}
 
-		/* check if we are the winner for downloading FW */
 		if (!adapter->winner) {
 			mwifiex_dbg(adapter, MSG,
-				    "FW already running! Skip FW dnld\n");
+				    "WLAN is not the winner! Skip FW dnld\n");
 			goto poll_fw;
 		}
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 2f7f478..c08be79 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -791,6 +791,7 @@ struct mwifiex_if_ops {
 	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
 	int (*check_fw_status) (struct mwifiex_adapter *, u32);
+	int (*check_winner_status)(struct mwifiex_adapter *);
 	int (*prog_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	int (*register_dev) (struct mwifiex_adapter *);
 	void (*unregister_dev) (struct mwifiex_adapter *);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 9703848..4000357 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2007,14 +2007,12 @@ done:
 
 /*
  * This function checks the firmware status in card.
- *
- * The winner interface is also determined by this function.
  */
 static int
 mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 {
 	int ret = 0;
-	u32 firmware_stat, winner_status;
+	u32 firmware_stat;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	u32 tries;
@@ -2054,19 +2052,28 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 		}
 	}
 
-	if (ret) {
-		if (mwifiex_read_reg(adapter, reg->fw_status,
-				     &winner_status))
-			ret = -1;
-		else if (!winner_status) {
-			mwifiex_dbg(adapter, INFO,
-				    "PCI-E is the winner\n");
-			adapter->winner = 1;
-		} else {
-			mwifiex_dbg(adapter, ERROR,
-				    "PCI-E is not the winner <%#x,%d>, exit dnld\n",
-				    ret, adapter->winner);
-		}
+	return ret;
+}
+
+/* This function checks if WLAN is the winner.
+ */
+static int
+mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
+{
+	u32 winner = 0;
+	int ret = 0;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (mwifiex_read_reg(adapter, reg->fw_status, &winner)) {
+		ret = -1;
+	} else if (!winner) {
+		mwifiex_dbg(adapter, INFO, "PCI-E is the winner\n");
+		adapter->winner = 1;
+	} else {
+		mwifiex_dbg(adapter, ERROR,
+			    "PCI-E is not the winner <%#x,%d>, exit dnld\n",
+			    ret, adapter->winner);
 	}
 
 	return ret;
@@ -2681,6 +2688,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.init_if =			mwifiex_pcie_init,
 	.cleanup_if =			mwifiex_pcie_cleanup,
 	.check_fw_status =		mwifiex_check_fw_status,
+	.check_winner_status =          mwifiex_check_winner_status,
 	.prog_fw =			mwifiex_prog_fw_w_helper,
 	.register_dev =			mwifiex_register_dev,
 	.unregister_dev =		mwifiex_unregister_dev,
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 78a8474..024306a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1039,19 +1039,14 @@ done:
 
 /*
  * This function checks the firmware status in card.
- *
- * The winner interface is also determined by this function.
  */
 static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 				   u32 poll_num)
 {
-	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 	u16 firmware_stat;
 	u32 tries;
-	u8 winner_status;
 
-	/* Wait for firmware initialization event */
 	for (tries = 0; tries < poll_num; tries++) {
 		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
 		if (ret)
@@ -1065,16 +1060,25 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	if (ret) {
-		if (mwifiex_read_reg
-		    (adapter, card->reg->status_reg_0, &winner_status))
-			winner_status = 0;
+	return ret;
+}
+
+/* This function checks if WLAN is the winner.
+ */
+static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	u8 winner = 0;
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (mwifiex_read_reg(adapter, card->reg->status_reg_0, &winner))
+		return -1;
+
+	if (winner)
+		adapter->winner = 0;
+	else
+		adapter->winner = 1;
 
-		if (winner_status)
-			adapter->winner = 0;
-		else
-			adapter->winner = 1;
-	}
 	return ret;
 }
 
@@ -2609,6 +2613,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
 	.check_fw_status = mwifiex_check_fw_status,
+	.check_winner_status = mwifiex_check_winner_status,
 	.prog_fw = mwifiex_prog_fw_w_helper,
 	.register_dev = mwifiex_register_dev,
 	.unregister_dev = mwifiex_unregister_dev,
-- 
1.8.1.4

