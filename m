Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7760 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbbLNMRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGb8k027452
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:30 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng02f-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:30 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 13/14] mwifiex: use world for unidentified region code
Date: Mon, 14 Dec 2015 04:15:14 -0800
Message-ID: <1450095315-19927-14-git-send-email-akarwar@marvell.com> (sfid-20151214_131738_232968_E599D05D)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's better to use world if region code from EEPROM is
unidentied instead of forcing it to FCC

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 45ae38e..cb25aa7 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1637,9 +1637,9 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		if (adapter->region_code == region_code_index[i])
 			break;
 
-	/* If it's unidentified region code, use the default (USA) */
+	/* If it's unidentified region code, use the default (world) */
 	if (i >= MWIFIEX_MAX_REGION_CODE) {
-		adapter->region_code = 0x10;
+		adapter->region_code = 0x00;
 		mwifiex_dbg(adapter, WARN,
 			    "cmd: unknown region code, use default (USA)\n");
 	}
-- 
1.8.1.4

