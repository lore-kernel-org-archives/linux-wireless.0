Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45255 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbbCWIv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 04:51:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2N8jTh0005430
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 01:51:27 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1ta9ymgr69-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 01:51:26 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/2] mwifiex: stop command path in suspend handler
Date: Mon, 23 Mar 2015 19:50:55 +0530
Message-ID: <1427120456-6247-1-git-send-email-patila@marvell.com> (sfid-20150323_095130_568830_44CD80FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel all pending commands including scan commands and stop CAC
during cfg80211 suspend handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fc3bbe7..eab110b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2942,15 +2942,23 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 	struct mwifiex_ds_hs_cfg hs_cfg;
-	int ret = 0;
-	struct mwifiex_private *priv =
-			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+	int i, ret = 0;
+	struct mwifiex_private *priv;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		mwifiex_abort_cac(priv);
+	}
+
+	mwifiex_cancel_all_pending_cmd(adapter);
 
 	if (!wowlan) {
 		dev_warn(adapter->dev, "None of the WOWLAN triggers enabled\n");
 		return 0;
 	}
 
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+
 	if (!priv->media_connected) {
 		dev_warn(adapter->dev,
 			 "Can not configure WOWLAN in disconnected state\n");
-- 
1.8.1.4

