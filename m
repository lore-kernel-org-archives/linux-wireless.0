Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:64550 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab2GPQhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 12:37:06 -0400
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix tx-mgmt cookie value being left uninitialized.
Date: Mon, 16 Jul 2012 18:36:52 +0200
Message-Id: <1342456612-11706-1-git-send-email-cavallar@lri.fr> (sfid-20120716_183711_123433_3F58AB44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit "mac80211: unify SW/offload remain-on-channel"
moved the cookie assignment from ieee80211_mgmt_tx()
to ieee80211_start_roc_work().  But the latter is only
called where offchannel is needed.  If offchannel isn't
needed/used, a uninitialized cookie value would be returned
to userspace.

This patch sets the cookie value when offchannel isn't used.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
based on wireless-testing.

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cfdc03f..106f381 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2493,6 +2493,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	skb->dev = sdata->dev;
 
 	if (!need_offchan) {
+		*cookie = (unsigned long) skb;
 		ieee80211_tx_skb(sdata, skb);
 		ret = 0;
 		goto out_unlock;
-- 
1.7.10.4

