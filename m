Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:36821 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752174Ab1KHDcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 22:32:06 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH RESEND 2/4] mwifiex: remove an unneeded NULL check
Date: Mon,  7 Nov 2011 19:31:45 -0800
Message-Id: <1320723107-24202-3-git-send-email-bzhao@marvell.com> (sfid-20111108_043209_038874_B5BC7A45)
In-Reply-To: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
References: <1320723107-24202-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

We dereference adapter in the error handling code so this needed to
be fixed.  This function is always called like:
	adapter->if_ops.host_to_card(adapter, ...);
so adapter can never be NULL and I've removed the NULL check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4466976..d12d440 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1671,9 +1671,8 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 				     struct sk_buff *skb,
 				     struct mwifiex_tx_param *tx_param)
 {
-	if (!adapter || !skb) {
-		dev_err(adapter->dev, "Invalid parameter in %s <%p, %p>\n",
-				__func__, adapter, skb);
+	if (!skb) {
+		dev_err(adapter->dev, "Passed NULL skb to %s\n", __func__);
 		return -1;
 	}
 
-- 
1.7.0.2

