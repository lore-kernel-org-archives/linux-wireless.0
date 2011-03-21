Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42530 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab1CUTBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 15:01:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2.6.39] mac80211: initialize sta->last_rx in sta_info_alloc
Date: Mon, 21 Mar 2011 20:01:00 +0100
Message-Id: <1300734060-55770-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This field is used to determine the inactivity time. When in AP mode,
hostapd uses it for kicking out inactive clients after a while. Without this
patch, hostapd immediately deauthenticates a new client if it checks the
inactivity time before the client sends its first data frame.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 net/mac80211/sta_info.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5a11078..d0311a3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -243,6 +243,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
+	sta->last_rx = jiffies;
 
 	ewma_init(&sta->avg_signal, 1024, 8);
 
-- 
1.7.3.2

