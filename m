Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17272 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbcGYPwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 11:52:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6PFo7f0019449
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:10 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 24c83gynf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:52:10 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 6/8] mwifiex: remove misleading disconnect message
Date: Mon, 25 Jul 2016 21:21:09 +0530
Message-ID: <1469461871-3135-7-git-send-email-akarwar@marvell.com> (sfid-20160725_175215_294043_3705FEE9)
In-Reply-To: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
References: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disconnect message in mwifiex_reset_connect_state() would displays
necessary information. We unnecessarily have exactly same message in
cfg80211_disconnect(). As priv->cfg_bssid is cleared at this point of
time, it prints incorrect(all zero) MAC.

This message is removed here.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 871ad8a..235fb39 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2012,10 +2012,6 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
-	mwifiex_dbg(priv->adapter, MSG,
-		    "info: successfully disconnected from %pM:\t"
-		    "reason code %d\n", priv->cfg_bssid, reason_code);
-
 	eth_zero_addr(priv->cfg_bssid);
 	priv->hs2_enabled = false;
 
-- 
1.9.1

