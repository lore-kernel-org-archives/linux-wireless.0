Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44082 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1JRGPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:15:33 -0400
Date: Tue, 18 Oct 2011 09:15:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/4] mwifiex: prevent corruption instead of just warning
Message-ID: <20111018061514.GI27732@elgon.mountain> (sfid-20111018_081537_503619_3EDD9755)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We may as well put a return here instead of just printing a warning
message and then corrupting memory.  The caller doesn't check the
return code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index d12d440..40b154d 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1228,9 +1228,11 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	if (!skb)
 		return 0;
 
-	if (rdptr >= MWIFIEX_MAX_EVT_BD)
+	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
 		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
 					rdptr);
+		return -EINVAL;
+	}
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
