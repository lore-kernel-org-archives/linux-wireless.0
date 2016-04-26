Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45141 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbcDZO0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 10:26:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3QEMhZU010027
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 07:26:33 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 22g8jfr01c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 07:26:33 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: change sleep cookie poll count
Date: Tue, 26 Apr 2016 07:25:45 -0700
Message-ID: <1461680745-22994-1-git-send-email-akarwar@marvell.com> (sfid-20160426_162637_901675_668A5D33)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Sometimes current polling count is not sufficient.
This patch increases it to 100.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 5770b43..9a1d09d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -117,7 +117,7 @@
 /* FW awake cookie after FW ready */
 #define FW_AWAKE_COOKIE						(0xAA55AA55)
 #define MWIFIEX_DEF_SLEEP_COOKIE			0xBEEFBEEF
-#define MWIFIEX_MAX_DELAY_COUNT				5
+#define MWIFIEX_MAX_DELAY_COUNT				100
 
 struct mwifiex_pcie_card_reg {
 	u16 cmd_addr_lo;
-- 
1.8.1.4

