Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64210 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab2AJNRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 08:17:42 -0500
Received: by wgbdt14 with SMTP id dt14so2602251wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 05:17:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: update oper_channel on ibss join
Date: Tue, 10 Jan 2012 15:19:54 +0200
Message-Id: <1326201594-4748-1-git-send-email-eliad@wizery.com> (sfid-20120110_141745_388926_DF395501)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 13c40c5 ("mac80211: Add HT operation modes for IBSS") broke
ibss operation by mistakenly removing the local->oper_channel
update (causing ibss to start on the wrong channel). fix it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/ibss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f8a32bf..765072d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -106,6 +106,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
+	local->oper_channel = chan;
 	channel_type = ifibss->channel_type;
 	if (channel_type > NL80211_CHAN_HT20 &&
 	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
-- 
1.7.6.401.g6a319

