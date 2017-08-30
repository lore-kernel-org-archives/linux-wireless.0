Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39789 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751415AbdH3Suo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 14:50:44 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: check for mfg_mode in add_virtual_intf
Date: Thu, 31 Aug 2017 00:16:58 +0530
Message-ID: <1504118818-1749-1-git-send-email-gbhat@marvell.com> (sfid-20170830_205048_024559_A4D93A51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If driver is loaded with 'mfg_mode' enabled, then the sending
commands are not allowed. So, when mwifiex_send_cmd fails in
mwifiex_add_virtual_intf, driver must check for 'mfg_mode' before
returning error.

Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ffada17..1856205 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2967,11 +2967,11 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 			       HostCmd_ACT_GEN_SET, 0, NULL, true);
-	if (ret)
+	if (ret && !adapter->mfg_mode)
 		goto err_set_bss_mode;
 
 	ret = mwifiex_sta_init_cmd(priv, false, false);
-	if (ret)
+	if (ret && !adapter->mfg_mode)
 		goto err_sta_init;
 
 	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
-- 
1.9.1
