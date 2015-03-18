Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31062 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbbCRIWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 04:22:54 -0400
Date: Wed, 18 Mar 2015 11:22:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>
Cc: Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: missing curly braces in
 mwifiex_write_data_complete()
Message-ID: <20150318082235.GC10434@mwanda> (sfid-20150318_092259_450922_49370427)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's clear from the indenting that curly braces were intended here.

Fixes: e35000ead491 ('mwifiex: preprocess packets from TX queue')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 4d43371..a245f44 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -302,10 +302,11 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		priv->stats.tx_errors++;
 	}
 
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT) {
 		atomic_dec_return(&adapter->pending_bridged_pkts);
 		if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
 			goto done;
+	}
 
 	if (aggr)
 		/* For skb_aggr, do not wake up tx queue */
