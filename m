Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12977 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030495AbcGKPD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:03:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BF2Gfl007452
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:03:57 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 2430sge5j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:03:57 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 7/9] mwifiex: remove misleading disconnect message
Date: Mon, 11 Jul 2016 20:23:50 +0530
Message-ID: <1468248832-21969-8-git-send-email-akarwar@marvell.com> (sfid-20160711_170401_920448_85F225FD)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
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
index bf95cca..73dd39d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2022,10 +2022,6 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
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

