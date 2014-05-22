Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1873 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbaEVFCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:02:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/5] mwifiex: delete TDLS link upon Teardown event
Date: Wed, 21 May 2014 22:02:29 -0700
Message-ID: <1400734951-6851-3-git-send-email-bzhao@marvell.com> (sfid-20140522_070257_097213_9F21AE2F)
In-Reply-To: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
References: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

If userspace application does not take care of TDLS teardown
event, TDLS link would be present in driver database and thus
driver would send such packets on direct link while peer has
already severed link causing data traffic failure. Disable TDLS
link upon teardown event so as to ensure this does not happen.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 5aea719..f6395ef 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -137,6 +137,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 				    struct sk_buff *event_skb)
 {
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_sta_node *sta_ptr;
 	struct mwifiex_tdls_generic_event *tdls_evt =
@@ -162,12 +163,15 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 					   NL80211_TDLS_TEARDOWN,
 					   le16_to_cpu(tdls_evt->u.reason_code),
 					   GFP_KERNEL);
+		ret = mwifiex_tdls_oper(priv, tdls_evt->peer_mac,
+					MWIFIEX_TDLS_DISABLE_LINK);
+		queue_work(adapter->workqueue, &adapter->main_work);
 		break;
 	default:
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.8.2.3

