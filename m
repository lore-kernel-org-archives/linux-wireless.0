Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2DFVf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 17:35:56 -0400
Date: Fri, 06 Apr 2012 16:35:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Convert WARN_ON to WARN_ON_ONCE
Message-ID: <4f7f61b9.74kJroV/7ZKg1qgV%Larry.Finger@lwfinger.net> (sfid-20120406_233559_616516_A1F23CE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the control-rate tables are not set up correctly, it makes
little sense to spam the logs, thus change the WARN_ON to WARN_ON_ONCE.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/include/net/mac80211.h
===================================================================
--- wireless-testing-new.orig/include/net/mac80211.h
+++ wireless-testing-new/include/net/mac80211.h
@@ -1325,7 +1325,7 @@ static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
 {
-	if (WARN_ON(c->control.rates[0].idx < 0))
+	if (WARN_ON_ONCE(c->control.rates[0].idx < 0))
 		return NULL;
 	return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];
 }
