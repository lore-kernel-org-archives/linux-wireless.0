Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33834 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbcGONho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 09:37:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6FDb6mg011238
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 06:37:43 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 246gatm24s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 06:37:43 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: update command response skb length correctly
Date: Fri, 15 Jul 2016 19:07:05 +0530
Message-ID: <1468589825-9188-2-git-send-email-akarwar@marvell.com> (sfid-20160715_153746_689725_5453E832)
In-Reply-To: <1468589825-9188-1-git-send-email-akarwar@marvell.com>
References: <1468589825-9188-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same skb is being reused for storing command response from firmware
in PCIe chipsets. There was a bug while updating the skb length.
This patch ensures skb length correctly gets updated based on rx_len.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 38bd62e..a6af85d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1616,6 +1616,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 
 	pkt_len = *((__le16 *)skb->data);
 	rx_len = le16_to_cpu(pkt_len);
+	skb_put(skb, MWIFIEX_UPLD_SIZE - skb->len);
 	skb_trim(skb, rx_len);
 	skb_pull(skb, INTF_HEADER_LEN);
 
-- 
1.9.1

