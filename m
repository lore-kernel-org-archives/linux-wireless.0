Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:47643 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755476Ab3CWEtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 00:49:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: do not enable PCIe interrupt in Power Save sleep state
Date: Fri, 22 Mar 2013 21:49:05 -0700
Message-ID: <1364014147-13986-2-git-send-email-bzhao@marvell.com> (sfid-20130323_054929_974177_0B0B2695)
In-Reply-To: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
References: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Enabling PCIe host interrupt may accidently wake up the card
when it's in sleep.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 8cd8cdc..112649a 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2112,7 +2112,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	}
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
 		adapter->cmd_sent, adapter->data_sent);
-	mwifiex_pcie_enable_host_int(adapter);
+	if (adapter->ps_state != PS_STATE_SLEEP)
+		mwifiex_pcie_enable_host_int(adapter);
 
 	return 0;
 }
-- 
1.7.0.2

