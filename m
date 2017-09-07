Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755691AbdIGUgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 16:36:48 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: check for mfg_mode in add_virtual_intf
Date: Fri, 8 Sep 2017 02:02:43 +0530
Message-ID: <1504816363-31015-1-git-send-email-gbhat@marvell.com> (sfid-20170907_223703_752332_E8A29035)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If driver is loaded with 'mfg_mode' enabled, then the sending
commands are not allowed. So, skip sending commands, to firmware
in mwifiex_add_virtual_intf if 'mfg_mode' is enabled.

Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: addressed Brian's comments.
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 32c5074..ad1ebd8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2959,18 +2959,21 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	}
 
 	mwifiex_init_priv_params(priv, dev);
-	mwifiex_set_mac_address(priv, dev);
 
 	priv->netdev = dev;
 
-	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
-			       HostCmd_ACT_GEN_SET, 0, NULL, true);
-	if (ret)
-		goto err_set_bss_mode;
+	if (!adapter->mfg_mode) {
+		mwifiex_set_mac_address(priv, dev);
 
-	ret = mwifiex_sta_init_cmd(priv, false, false);
-	if (ret)
-		goto err_sta_init;
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+				       HostCmd_ACT_GEN_SET, 0, NULL, true);
+		if (ret)
+			goto err_set_bss_mode;
+
+		ret = mwifiex_sta_init_cmd(priv, false, false);
+		if (ret)
+			goto err_sta_init;
+	}
 
 	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
 	if (adapter->is_hw_11ac_capable)
-- 
1.9.1
