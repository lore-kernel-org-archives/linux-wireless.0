Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3553 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbbBLMqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 07:46:23 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1CCjLnj023554
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:22 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1sgtb7rd5d-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:22 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Li Long <longli@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/3] mwifiex: add cfg80211 set_default_mgmt_key handler
Date: Thu, 12 Feb 2015 23:45:52 +0530
Message-ID: <1423764954-30412-1-git-send-email-patila@marvell.com> (sfid-20150212_134627_640778_2A1810BC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is observed that hostapd failed to setup with management frame
protection mode enabled when using mwifiex.

This is because hostapd will try to install IGTK using
cfg80211 set_default_mgmt_key handler.

we have already support IGTK install in set_key handler, so just work
around this issue by add an empty cfg80211_set_default_mgmt_key handler.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Li Long <longli@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5f3c1d3..ab7643d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -415,6 +415,18 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /*
+ * CFG802.11 operation handler to set default mgmt key.
+ */
+static int
+mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
+				      struct net_device *netdev,
+				      u8 key_index)
+{
+	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n", key_index);
+	return 0;
+}
+
+/*
  * This function sends domain information to the firmware.
  *
  * The following information are passed to the firmware -
@@ -3280,6 +3292,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
 	.add_key = mwifiex_cfg80211_add_key,
 	.del_key = mwifiex_cfg80211_del_key,
+	.set_default_mgmt_key = mwifiex_cfg80211_set_default_mgmt_key,
 	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
 	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
 	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,
-- 
1.8.1.4

