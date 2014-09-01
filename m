Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51984 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbaIAHbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:40 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 11/17] mwifiex: set passive scan type for scan requests with no ssid
Date: Mon, 1 Sep 2014 18:28:59 +0530
Message-ID: <1409576345-13717-12-git-send-email-patila@marvell.com> (sfid-20140901_093143_604019_607114B6)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was observed that station would sent probe request even when
scan type has been set as passive during iw scan.
This was happening because driver sets passive scan type only
when channel has IEEE80211_CHAN_NO_IR flag set.
Along with this, add condition to check if no ssids are specified in
scan request so as to mark such scan request passive.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e2e6bf1..320512f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1980,7 +1980,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		user_scan_cfg->chan_list[i].radio_type = chan->band;
 
-		if (chan->flags & IEEE80211_CHAN_NO_IR)
+		if ((chan->flags & IEEE80211_CHAN_NO_IR) || !request->n_ssids)
 			user_scan_cfg->chan_list[i].scan_type =
 						MWIFIEX_SCAN_TYPE_PASSIVE;
 		else
-- 
1.8.1.4

