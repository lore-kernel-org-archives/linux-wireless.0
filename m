Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39064 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753340AbeDDDDK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 23:03:10 -0400
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 3/3] mwifiex: keep user configured mac address during changing virtual interface
Date: Wed, 4 Apr 2018 11:02:41 +0800
Message-ID: <1522810961-27521-3-git-send-email-huxm@marvell.com> (sfid-20180404_050314_290321_A857CB91)
In-Reply-To: <1522810961-27521-1-git-send-email-huxm@marvell.com>
References: <1522810961-27521-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During changing virtual interface, keep using previous net device
mac address.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index cef4dea8..bd036bf 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1345,7 +1345,10 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->assocresp_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->gen_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
-	ether_addr_copy(priv->curr_addr, priv->adapter->perm_addr);
+	if (is_valid_ether_addr(dev->dev_addr))
+		ether_addr_copy(priv->curr_addr, dev->dev_addr);
+	else
+		ether_addr_copy(priv->curr_addr, priv->adapter->perm_addr);
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
 	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
-- 
1.9.1
