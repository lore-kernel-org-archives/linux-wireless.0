Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63776 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbaCSFT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 01:19:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: handle extended scan event for AP interface
Date: Tue, 18 Mar 2014 22:19:16 -0700
Message-ID: <1395206358-11573-1-git-send-email-bzhao@marvell.com> (sfid-20140319_061929_943252_86C12022)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Stations associated to mwifiex AP would not be able to ping AP
after scan was issued on AP interface. This happened because
there was no handling of extended scan event in AP. This patch
adds this handling and fixes ping failure issue.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index ae50e91..92e77a3 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -166,6 +166,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 			mwifiex_11n_ba_stream_timeout(priv, ba_timeout);
 		}
 		break;
+	case EVENT_EXT_SCAN_REPORT:
+		dev_dbg(adapter->dev, "event: EXT_SCAN Report\n");
+		if (adapter->ext_scan)
+			return mwifiex_handle_event_ext_scan_report(priv,
+						adapter->event_skb->data);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
-- 
1.8.2.3

