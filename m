Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30935 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbbFDOCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 10:02:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t54Dwx6o006648
	for <linux-wireless@vger.kernel.org>; Thu, 4 Jun 2015 07:02:21 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1usq1cn40f-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 07:02:21 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	<liuzy@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/2] mwifiex: change debug dump issue since skb maybe null
Date: Fri, 5 Jun 2015 01:01:53 +0530
Message-ID: <1433446314-13098-1-git-send-email-patila@marvell.com> (sfid-20150604_160225_918356_C8BD3C7E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch fixes semantic warning for debugging data dump feature.
Previous code is based on the assumption that skb is not null.
New change makes sure that we already have data buffer.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index a51feac..207da40 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -469,10 +469,11 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		memset(rx_info, 0, sizeof(*rx_info));
 		rx_info->bss_num = priv->bss_num;
 		rx_info->bss_type = priv->bss_type;
+		mwifiex_dbg_dump(adapter, EVT_D, "Event Buf:",
+				 skb->data, skb->len);
 	}
 
 	mwifiex_dbg(adapter, EVENT, "EVENT: cause: %#x\n", eventcause);
-	mwifiex_dbg_dump(adapter, EVT_D, "Event Buf:", skb->data, skb->len);
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 		ret = mwifiex_process_uap_event(priv);
-- 
1.8.1.4

