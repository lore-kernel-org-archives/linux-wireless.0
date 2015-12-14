Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16923 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbbLNMRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGeuh027459
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:17 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng01v-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:16 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 06/14] mwifiex: abort cac in del_station() handler
Date: Mon, 14 Dec 2015 04:15:07 -0800
Message-ID: <1450095315-19927-7-git-send-email-akarwar@marvell.com> (sfid-20151214_131722_680373_E2B2B24A)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

When hostapd is killed with Ctrl+C before cac get completed,
stop_ap handler will not be called, thus priv->wdev.cac_started
flag remains set.
Hostapd restart attempt will be failed in this case with device
busy error. This patch aborts cac in del_station handler to
handle this corner case.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0aab935..f7c26d6 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1708,6 +1708,11 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 	u8 deauth_mac[ETH_ALEN];
 	unsigned long flags;
 
+	if (!priv->bss_started && priv->wdev.cac_started) {
+		mwifiex_dbg(priv->adapter, INFO, "%s: abort CAC!\n", __func__);
+		mwifiex_abort_cac(priv);
+	}
+
 	if (list_empty(&priv->sta_list) || !priv->bss_started)
 		return 0;
 
-- 
1.8.1.4

