Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59736 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751587AbdKUMDs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 07:03:48 -0500
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
Subject: [PATCH v2] mwifiex: do not support change AP interface to station mode
Date: Tue, 21 Nov 2017 20:03:35 +0800
Message-ID: <1511265815-13087-1-git-send-email-huxm@marvell.com> (sfid-20171121_130352_756017_5B370C03)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware do not support change interface from micro-ap mode to
station mode, forbidden this operation in driver accordingly.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
v2: remove unnecessary sta/uap combo check(James Cameron)

 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6e0d9a9..4d45df8 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1180,7 +1180,6 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	case NL80211_IFTYPE_AP:
 		switch (type) {
 		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_STATION:
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
 							       type, params);
 			break;
-- 
1.9.1
