Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41750 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934238AbcJUPQ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 11:16:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9LFFmH8021082
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 08:16:25 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 265pbxn1w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 08:16:25 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: fix corner case power save issue
Date: Fri, 21 Oct 2016 20:45:47 +0530
Message-ID: <1477062948-8558-1-git-send-email-akarwar@marvell.com> (sfid-20161021_171630_277511_09D8E749)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We may get SLEEP event from firmware even if TXDone for last Tx packet
is still pending. In this case, we may end up accessing PCIe memory for
handling TXDone after power save handshake is completed. This causes
kernel crash with external abort.

We will delay sending SLEEP confirm to firmware in
this case to resolve the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 5347728..f582f61 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1118,7 +1118,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 void
 mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
 {
-	if (!adapter->cmd_sent &&
+	if (!adapter->cmd_sent && !adapter->data_sent &&
 	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
 		mwifiex_dnld_sleep_confirm_cmd(adapter);
 	else
-- 
1.9.1
