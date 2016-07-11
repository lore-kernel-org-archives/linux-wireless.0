Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41608 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933858AbcGKPDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:03:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BF1ZNr000959
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:03:07 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 242xmkxctp-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:03:06 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Mon, 11 Jul 2016 20:23:48 +0530
Message-ID: <1468248832-21969-6-git-send-email-akarwar@marvell.com> (sfid-20160711_170315_730960_21EA8888)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is observed that hostapd fails to setup with management frame
protection mode enabled when using mwifiex. This patch adds
cfg80211_set_default_mgmt_key handler to resolve the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 8955f8c..bf95cca 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -484,6 +484,18 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
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
@@ -4002,6 +4014,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
 	.add_key = mwifiex_cfg80211_add_key,
 	.del_key = mwifiex_cfg80211_del_key,
+	.set_default_mgmt_key = mwifiex_cfg80211_set_default_mgmt_key,
 	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
 	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
 	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,
-- 
1.9.1

