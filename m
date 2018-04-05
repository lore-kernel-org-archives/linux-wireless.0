Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeDELRd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:17:33 -0400
Date: Thu, 5 Apr 2018 14:17:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] mwifiex: pcie: tighten a check in
 mwifiex_pcie_process_event_ready()
Message-ID: <20180405111719.GB4218@mwanda> (sfid-20180405_131737_667067_2241EBA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If "evt_len" is 1 then we try to memcpy() negative 3 bytes and it would
cause memory corruption.

Fixes: d930faee141b ("mwifiex: add support for Marvell pcie8766 chipset")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 97a6199692ab..7538543d46fa 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1881,7 +1881,8 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		mwifiex_dbg(adapter, EVENT,
 			    "info: Event length: %d\n", evt_len);
 
-		if ((evt_len > 0) && (evt_len  < MAX_EVENT_SIZE))
+		if (evt_len > MWIFIEX_EVENT_HEADER_LEN &&
+		    evt_len < MAX_EVENT_SIZE)
 			memcpy(adapter->event_body, skb_cmd->data +
 			       MWIFIEX_EVENT_HEADER_LEN, evt_len -
 			       MWIFIEX_EVENT_HEADER_LEN);
