Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22044 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0I1I34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 04:29:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 01:29:49 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] mac80211: sets basic rate set parameter for IBSS creator
Date: Tue, 28 Sep 2010 13:59:46 +0530
Message-ID: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This fix sets the basic rate set parameter for IBSS creator when the
basic rates are not explicitly specified in the user space.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/ibss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1a3aae5..e117155 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -541,6 +541,9 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		capability |= WLAN_CAPABILITY_PRIVACY;
 	else
 		sdata->drop_unencrypted = 0;
+	if (ifibss->basic_rates == 0)
+		ifibss->basic_rates = ieee80211_mandatory_rates(local,
+					local->hw.conf.channel->band);
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, ifibss->basic_rates,
-- 
1.7.0.4

