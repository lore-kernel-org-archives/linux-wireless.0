Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29895 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbcFPN0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:26:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDHMU2017193
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:26:03 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 23gj5fs06y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:26:03 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/6] mwifiex: cancel pending scan during disconnect
Date: Thu, 16 Jun 2016 18:52:23 +0530
Message-ID: <1466083346-18607-3-git-send-email-akarwar@marvell.com> (sfid-20160616_152612_446677_8D94D21B)
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
References: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is obeserved that sometimes scan operation will block the disconnect
during system suspend. It's ok to cancel ongoing scan in this case. It
reduces unnecessary system suspend delay.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 313115e..cd50425 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1695,6 +1695,9 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 					  struct cfg80211_beacon_data *data)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	mwifiex_cancel_scan(adapter);
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP) {
 		mwifiex_dbg(priv->adapter, ERROR,
-- 
1.9.1

