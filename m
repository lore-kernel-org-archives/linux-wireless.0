Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36486 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbbG1OXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 10:23:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6SEEIxd026040
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 07:23:08 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vv91rgqpx-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 07:23:08 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: correct TDLS link delete failure message priority
Date: Tue, 28 Jul 2015 07:22:20 -0700
Message-ID: <1438093340-20392-1-git-send-email-akarwar@marvell.com> (sfid-20150728_162314_366517_4926C6B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d8d2f19feb16 ("mwifiex: silence TDLS link delete failure
for nonexistent link") lowers the priority of error message when
TDLS link is already deleted. But it had got increased by
commit acebe8c10a6e ("mwifiex: change dbg print func to
mwifiex_dbg")

Reported-by: Nicholas Mc Guire <der.herr@hofr.at>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 89e8daf..87b69d8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -895,7 +895,7 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 	case ACT_TDLS_DELETE:
 		if (reason) {
 			if (!node || reason == TDLS_ERR_LINK_NONEXISTENT)
-				mwifiex_dbg(priv->adapter, ERROR,
+				mwifiex_dbg(priv->adapter, MSG,
 					    "TDLS link delete for %pM failed: reason %d\n",
 					    cmd_tdls_oper->peer_mac, reason);
 			else
-- 
1.8.1.4

