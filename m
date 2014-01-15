Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56656 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbaAODWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 22:22:34 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Ujjal Roy <royujjal@gmail.com>
Subject: [PATCH] mwifiex: export threshold value and retry limit to cfg80211
Date: Tue, 14 Jan 2014 19:22:22 -0800
Message-ID: <1389756142-32607-1-git-send-email-bzhao@marvell.com> (sfid-20140115_042237_473809_5E5C6DAA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

While registering the driver with cfg80211, update the threshold
value and retry limit to cfg80211.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f3aa55a..aba6e46 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2679,6 +2679,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	struct wiphy *wiphy;
 	struct mwifiex_private *priv = adapter->priv[MWIFIEX_BSS_TYPE_STA];
 	u8 *country_code;
+	u32 thr, retry;
 
 	/* create a new wiphy for use with cfg80211 */
 	wiphy = wiphy_new(&mwifiex_cfg80211_ops,
@@ -2768,6 +2769,19 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 				   country_code);
 	}
 
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			      HostCmd_ACT_GEN_GET, FRAG_THRESH_I, &thr);
+	wiphy->frag_threshold = thr;
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			      HostCmd_ACT_GEN_GET, RTS_THRESH_I, &thr);
+	wiphy->rts_threshold = thr;
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			      HostCmd_ACT_GEN_GET, SHORT_RETRY_LIM_I, &retry);
+	wiphy->retry_short = (u8) retry;
+	mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			      HostCmd_ACT_GEN_GET, LONG_RETRY_LIM_I, &retry);
+	wiphy->retry_long = (u8) retry;
+
 	adapter->wiphy = wiphy;
 	return ret;
 }
-- 
1.8.2.3

