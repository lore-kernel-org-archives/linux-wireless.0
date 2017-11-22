Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751244AbdKVGzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 01:55:53 -0500
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
Subject: [PATCH v3] mwifiex: do not support change AP interface to station mode
Date: Wed, 22 Nov 2017 14:55:31 +0800
Message-ID: <1511333731-23474-1-git-send-email-huxm@marvell.com> (sfid-20171122_075556_841896_48C68399)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware do not support change interface from micro-ap mode
to station mode, forbid this operation

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
v2: remove unnecessary sta/uap combo check(James Cameron)
v3: correct description(James Cameron)

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
