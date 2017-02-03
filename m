Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753241AbdBCNAp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 08:00:45 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v13CspiN007533
        for <linux-wireless@vger.kernel.org>; Fri, 3 Feb 2017 05:00:45 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 28c1mdpum9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2017 05:00:44 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Avoid skipping WEP key deletion for AP
Date: Fri, 3 Feb 2017 18:30:22 +0530
Message-ID: <1486126822-21958-1-git-send-email-akarwar@marvell.com> (sfid-20170203_140108_804229_91EBF45B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

This patch fixes the issue specific to AP. AP is started with WEP
security and external station is connected to it. Data path works
in this case. Now if AP is restarted with WPA/WPA2 security,
station is able to connect but ping fails.

Driver skips the deletion of WEP keys if interface type is AP.
Removing that redundant check resolves the issue.

Fixes: e57f1734("mwifiex: add key material v2 support")
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 644f3a2..1532ac9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1159,8 +1159,6 @@ int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
 			encrypt_key.is_rx_seq_valid = true;
 		}
 	} else {
-		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
-			return 0;
 		encrypt_key.key_disable = true;
 		if (mac_addr)
 			memcpy(encrypt_key.mac_addr, mac_addr, ETH_ALEN);
-- 
1.9.1
