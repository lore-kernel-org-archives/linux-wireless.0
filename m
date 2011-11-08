Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42075 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298Ab1KHDce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 22:32:34 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH RESEND 4/4] mwifiex: prevent corruption instead of just warning
Date: Mon,  7 Nov 2011 19:31:47 -0800
Message-Id: <1320723107-24202-5-git-send-email-bzhao@marvell.com> (sfid-20111108_043236_458230_1F489011)
In-Reply-To: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
References: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

Probably we never hit this condition, but in case we do, we may as
well put a return here instead of just printing a warning message and
then corrupting memory.  The caller doesn't check the return code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index d12d440..a2f3200 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1228,9 +1228,12 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	if (!skb)
 		return 0;
 
-	if (rdptr >= MWIFIEX_MAX_EVT_BD)
+	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
 		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
 					rdptr);
+		ret = -EINVAL;
+		goto done;
+	}
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
-- 
1.7.0.2

