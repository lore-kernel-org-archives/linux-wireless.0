Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30372 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941AbbA3ImO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:42:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0U8ccgb006600
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:14 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s7fgab5hr-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:13 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/4] mwifiex: fix memory leak in mwifiex_send_processed_packet()
Date: Fri, 30 Jan 2015 00:40:05 -0800
Message-ID: <1422607207-15229-2-git-send-email-akarwar@marvell.com> (sfid-20150130_094217_248069_F0488ACD)
In-Reply-To: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
References: <1422607207-15229-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Memory is leaked after downloading already processed packet. This
patch fixes the problem by freeing returned skb. Other transmit
paths don't have this problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index ffffd2c..ef717ac 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1228,6 +1228,9 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	case -EINPROGRESS:
 		if (adapter->iface_type != MWIFIEX_PCIE)
 			adapter->data_sent = false;
+		break;
+	case 0:
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
 	default:
 		break;
 	}
-- 
1.8.1.4

