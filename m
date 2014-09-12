Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58320 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbaILJLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:32 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 05/16] mwifiex: support for event done interrupt
Date: Fri, 12 Sep 2014 20:08:49 +0530
Message-ID: <1410532740-3173-6-git-send-email-patila@marvell.com> (sfid-20140912_111232_686543_33775041)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for writing CPU event interrupt done back
to device.
Patch also increases interrupt buffer ring size from 4 to 8.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 7 +++++++
 drivers/net/wireless/mwifiex/pcie.h | 5 +++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 27c2bf8..2ada1b7 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1726,6 +1726,13 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		   buffer is released. This is just to make things simpler,
 		   we need to find a better method of managing these buffers.
 		*/
+	} else {
+		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+				      CPU_INTR_EVENT_DONE)) {
+			dev_warn(adapter->dev,
+				 "Write register failed\n");
+			return -1;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index a1a8fd3..200e8b0 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -40,8 +40,8 @@
 #define MWIFIEX_TXBD_MASK			0x3F
 #define MWIFIEX_RXBD_MASK			0x3F
 
-#define MWIFIEX_MAX_EVT_BD			0x04
-#define MWIFIEX_EVTBD_MASK			0x07
+#define MWIFIEX_MAX_EVT_BD			0x08
+#define MWIFIEX_EVTBD_MASK			0x0f
 
 /* PCIE INTERNAL REGISTERS */
 #define PCIE_SCRATCH_0_REG				0xC10
@@ -69,6 +69,7 @@
 #define CPU_INTR_DOOR_BELL				BIT(1)
 #define CPU_INTR_SLEEP_CFM_DONE			BIT(2)
 #define CPU_INTR_RESET					BIT(3)
+#define CPU_INTR_EVENT_DONE				BIT(5)
 
 #define HOST_INTR_DNLD_DONE				BIT(0)
 #define HOST_INTR_UPLD_RDY				BIT(1)
-- 
1.8.1.4

