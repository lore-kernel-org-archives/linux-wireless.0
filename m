Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38790 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065Ab3DCQct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:32:49 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: siwu@hrz.tu-chemnitz.de, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [TESTING-QH 2/2] REMOVEME: remove NO_IBSS and PASSIVE_SCAN from reg_can_beacon()
Date: Wed,  3 Apr 2013 18:32:39 +0200
Message-Id: <1365006759-16779-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183254_111254_9B40EF49)
In-Reply-To: <1365006759-16779-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1365006759-16779-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

The concept of clearing a DFS channel with a CAC and open it for transmission
is not yet supported by the channel framework. This patch is required to
temporary remove the additional consideration of the flags that are anyhow
superposed by the DFS flag.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 net/wireless/chan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index fd556ac..16d0ee7 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -425,8 +425,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	res = cfg80211_chandef_usable(wiphy, chandef,
 				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
+//				      IEEE80211_CHAN_PASSIVE_SCAN |
+//				      IEEE80211_CHAN_NO_IBSS |
 				      IEEE80211_CHAN_RADAR);
 
 	trace_cfg80211_return_bool(res);
-- 
1.7.4.1

