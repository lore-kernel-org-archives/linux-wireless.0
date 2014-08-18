Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13489 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbaHRJQn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 05:16:43 -0400
From: Avinash Patil <patila@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Aug 2014 02:15:35 -0700
Subject: [PATCH 3/4] mwifiex: support for event done interrupt
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147C23@SC-VEXCH2.marvell.com> (sfid-20140818_111741_111942_2D8152F2)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
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
index fbb0550..1f6e687 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1726,6 +1726,13 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
                   buffer is released. This is just to make things simpler,
                   we need to find a better method of managing these buffers.
                */
+       } else {
+               if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+                                     CPU_INTR_EVENT_DONE)) {
+                       dev_warn(adapter->dev,
+                                "Write register failed\n");
+                       return -1;
+               }
        }

        return 0;
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index a1a8fd3..200e8b0 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -40,8 +40,8 @@
 #define MWIFIEX_TXBD_MASK                      0x3F
 #define MWIFIEX_RXBD_MASK                      0x3F

-#define MWIFIEX_MAX_EVT_BD                     0x04
-#define MWIFIEX_EVTBD_MASK                     0x07
+#define MWIFIEX_MAX_EVT_BD                     0x08
+#define MWIFIEX_EVTBD_MASK                     0x0f

 /* PCIE INTERNAL REGISTERS */
 #define PCIE_SCRATCH_0_REG                             0xC10
@@ -69,6 +69,7 @@
 #define CPU_INTR_DOOR_BELL                             BIT(1)
 #define CPU_INTR_SLEEP_CFM_DONE                        BIT(2)
 #define CPU_INTR_RESET                                 BIT(3)
+#define CPU_INTR_EVENT_DONE                            BIT(5)

 #define HOST_INTR_DNLD_DONE                            BIT(0)
 #define HOST_INTR_UPLD_RDY                             BIT(1)
-- 
1.8.1.4
