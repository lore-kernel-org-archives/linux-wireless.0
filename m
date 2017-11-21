Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59618 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752905AbdKUHYc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 02:24:32 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: do not support change AP interface to station mode
Date: Tue, 21 Nov 2017 15:24:03 +0800
Message-ID: <1511249043-21404-1-git-send-email-huxm@marvell.com> (sfid-20171121_082521_360222_58138CE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware do not support change interface from micro-ap mode to
station mode, forbidden this operation in driver accordingly.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6e0d9a9..a87758f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1181,6 +1181,12 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_STATION:
+			if (mwifiex_get_priv_by_id(priv->adapter, priv->bss_num,
+						   MWIFIEX_BSS_TYPE_STA)){
+				mwifiex_dbg(priv->adapter, INFO,
+					    "Skip change virtual interface\n");
+				return 0;
+			}
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
 							       type, params);
 			break;
-- 
1.9.1
