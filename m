Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47176 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933918AbbGVLyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:54:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6MBnwAI028751
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:12 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vqm5jkw46-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:11 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/4] mwifiex: using right aid value for tdls action frame
Date: Wed, 22 Jul 2015 04:53:42 -0700
Message-ID: <1437566025-3324-1-git-send-email-akarwar@marvell.com> (sfid-20150722_135421_509470_12CCB4E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Variable pos is u8 here, so memcpy is needed to store u16 aid.
At the same time, aid should be platform independent, upper layer
utility(wpa_supplicant,etc.,) parse it as le16, so keep it le16
here.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index aa3d3c5..b3e163d 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -164,7 +164,7 @@ static void mwifiex_tdls_add_aid(struct mwifiex_private *priv,
 	pos = (void *)skb_put(skb, 4);
 	*pos++ = WLAN_EID_AID;
 	*pos++ = 2;
-	*pos++ = le16_to_cpu(assoc_rsp->a_id);
+	memcpy(pos, &assoc_rsp->a_id, sizeof(assoc_rsp->a_id));
 
 	return;
 }
-- 
1.8.1.4

