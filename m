Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751237AbeDBMbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Apr 2018 08:31:49 -0400
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
Subject: [PATCH 2/2] mwifiex: uap: support cfg80211 ignore_broadcast_ssid=2
Date: Mon, 2 Apr 2018 20:31:23 +0800
Message-ID: <1522672283-1860-2-git-send-email-huxm@marvell.com> (sfid-20180402_143159_253694_C1776FD3)
In-Reply-To: <1522672283-1860-1-git-send-email-huxm@marvell.com>
References: <1522672283-1860-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware already support hidden ssid and keep ssid length,
Open the capability in driver.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 52bdb71..8b2aab1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1959,7 +1959,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		bss_cfg->bcast_ssid_ctl = 0;
 		break;
 	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
-		/* firmware doesn't support this type of hidden SSID */
+		bss_cfg->bcast_ssid_ctl = 2;
+		break;
 	default:
 		kfree(bss_cfg);
 		return -EINVAL;
-- 
1.9.1
