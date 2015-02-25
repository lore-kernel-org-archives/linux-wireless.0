Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34075 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbbBYLQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 06:16:07 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1PBG6jn016672
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:16:06 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1srpgjbfxw-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:16:06 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: do not initialize ext_scan in mwifiex_init_adapter
Date: Wed, 25 Feb 2015 22:15:41 +0530
Message-ID: <1424882741-11937-1-git-send-email-patila@marvell.com> (sfid-20150225_121612_203197_5BB86A91)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Features which are device specific are already updated in
interface specific initialization e.g. register_dev.
We should not initialize them in mwifiex_init_adapter();
else this would overwrite earlier settings.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b77ba74..2e1df02 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -296,7 +296,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
-	adapter->ext_scan = false;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
 	memset(adapter->perm_addr, 0xff, ETH_ALEN);
-- 
1.8.1.4

