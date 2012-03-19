Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64563 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2CTOzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 13:57:53 +0100
Subject: [RFC 12/12] mac80211: return NULL from get_channel in multi-channel
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <892b9fb4-fb69-486f-b619-85d6336e5a31@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155530_182045_07E4AF64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to comment on cfg80211_ops/get_channel we should return NULL
in case of concurrent multi-channel.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 88cc128..05f7022 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2680,6 +2680,9 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy)
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_MULTI_CHANNEL)
+		return NULL;
+
 	return chan_state->oper_channel;
 }
 
-- 
1.7.0.4

