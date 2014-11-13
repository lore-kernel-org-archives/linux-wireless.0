Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31957 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbaKMKzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:55:12 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/6] mwifiex: do not explicitly disable TDLS link during teardown
Date: Thu, 13 Nov 2014 21:54:14 +0530
Message-ID: <1415895858-4007-3-git-send-email-patila@marvell.com> (sfid-20141113_115516_766576_8377DDAD)
In-Reply-To: <1415895858-4007-1-git-send-email-patila@marvell.com>
References: <1415895858-4007-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When Teardown event from FW is indicated to userspace, userspace
would trigger tdls_oper handler to disable TDLS link.
We need not do this explicitly here.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f1c240e..0efd6f0 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -163,9 +163,6 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 					   NL80211_TDLS_TEARDOWN,
 					   le16_to_cpu(tdls_evt->u.reason_code),
 					   GFP_KERNEL);
-		ret = mwifiex_tdls_oper(priv, tdls_evt->peer_mac,
-					MWIFIEX_TDLS_DISABLE_LINK);
-		queue_work(adapter->workqueue, &adapter->main_work);
 		break;
 	default:
 		break;
-- 
1.8.1.4

