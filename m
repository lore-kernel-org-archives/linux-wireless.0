Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18348 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbcFPNbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:31:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDQYjR018615
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:31:20 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 23gg0ksmwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:31:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/6] mwifiex: fix AP start problem for newly added interface
Date: Thu, 16 Jun 2016 18:52:26 +0530
Message-ID: <1466083346-18607-6-git-send-email-akarwar@marvell.com> (sfid-20160616_153124_417575_B28E92ED)
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
References: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that if interface type is changed from managed to
__ap, AP can be successfully started. But there is a problem if new
ap interface is added.

The problem got resolved after sending appropriate commands to firmware
in add_interface handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index cd50425..81ff8bb 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2775,6 +2775,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
+	int ret;
 
 	if (!adapter)
 		return ERR_PTR(-EFAULT);
@@ -2900,6 +2901,13 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_init_priv_params(priv, dev);
 	priv->netdev = dev;
 
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+			       HostCmd_ACT_GEN_SET, 0, NULL, true);
+		return ERR_PTR(ret);
+
+	ret = mwifiex_sta_init_cmd(priv, false, false);
+		return ERR_PTR(ret);
+
 	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
 	if (adapter->is_hw_11ac_capable)
 		mwifiex_setup_vht_caps(
-- 
1.9.1

