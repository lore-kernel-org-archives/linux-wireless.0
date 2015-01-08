Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:34918 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbAHHEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 02:04:23 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <johannes@sipsolutions.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next] mac80211: silent build warnings
Date: Thu, 8 Jan 2015 15:04:15 +0800
Message-ID: <1420700655-9427-1-git-send-email-ying.xue@windriver.com> (sfid-20150108_080430_147923_FFEF72A3)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Silent the following build warnings:

net/mac80211/mlme.c: In function ‘ieee80211_rx_mgmt_beacon’:
net/mac80211/mlme.c:1348:3: warning: ‘pwr_level_cisco’ may be used uninitialized in this function [-Wuninitialized]
net/mac80211/mlme.c:1315:6: note: ‘pwr_level_cisco’ was declared here

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2c36c47..13b5506 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1312,7 +1312,7 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 {
 	bool has_80211h_pwr = false, has_cisco_pwr = false;
 	int chan_pwr = 0, pwr_reduction_80211h = 0;
-	int pwr_level_cisco, pwr_level_80211h;
+	int pwr_level_cisco = 0, pwr_level_80211h = 0;
 	int new_ap_level;
 
 	if (country_ie && pwr_constr_ie &&
-- 
1.7.9.5

