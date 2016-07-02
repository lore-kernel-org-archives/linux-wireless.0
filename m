Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37212 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbcGBHVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2016 03:21:23 -0400
Date: Sat, 2 Jul 2016 10:20:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: fix mwifiex_add_virtual_intf()
Message-ID: <20160702072045.GA25758@mwanda> (sfid-20160702_092127_969122_C099FBE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We accidentally left some if statements out so the
mwifiex_add_virtual_intf() function returns early.

Fixes: 7311ea850079 ('mwifiex: fix AP start problem for newly added interface')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 99e8cf1..5de9f63 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2865,9 +2865,11 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 			       HostCmd_ACT_GEN_SET, 0, NULL, true);
+	if (ret)
 		return ERR_PTR(ret);
 
 	ret = mwifiex_sta_init_cmd(priv, false, false);
+	if (ret)
 		return ERR_PTR(ret);
 
 	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
