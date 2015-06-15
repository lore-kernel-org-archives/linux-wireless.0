Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14692 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbbFOLET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 07:04:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t5FB03mX024596
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 04:04:18 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v042959k5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 04:04:18 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: add missing break statement in switch case
Date: Mon, 15 Jun 2015 04:03:35 -0700
Message-ID: <1434366215-1107-1-git-send-email-akarwar@marvell.com> (sfid-20150615_130423_009309_60822EF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds missing break statement at the end of
EVENT_BT_COEX_WLAN_PARA_CHANGE switch section.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index ac229ef..848de26 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -592,6 +592,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "EVENT: BT coex wlan param update\n");
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR, "event: unknown event id: %#x\n",
 			    eventcause);
-- 
1.8.1.4

