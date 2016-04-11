Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13247 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbcDKOxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:53:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3BEpS1x016296
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:12 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 226y3kdqvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:12 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/5] mwifiex: missing break statement
Date: Mon, 11 Apr 2016 07:52:37 -0700
Message-ID: <1460386361-29918-1-git-send-email-akarwar@marvell.com> (sfid-20160411_165400_886100_614C1C9E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds missing break statement at the end of
PCIE_DEVICE_ID_MARVELL_88W8897 switch section.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index edf8b07..c28edbb 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2831,6 +2831,7 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		default:
 			break;
 		}
+		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8997:
 		mwifiex_read_reg(adapter, 0x0c48, &revision_id);
 		switch (revision_id) {
-- 
1.8.1.4

