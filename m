Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45331 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1CKUFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:05:44 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix channel type recalculation with HT and non-HT interfaces
Date: Fri, 11 Mar 2011 21:05:39 +0100
Message-Id: <1299873939-1171-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running an AP interface along with the cooked monitor interface created
by hostapd, adding an interface and deleting it again triggers a channel type
recalculation during which the (non-HT) monitor interface takes precedence
over the HT AP interface, thus causing the channel type to be set to non-HT.
Fix this by not overriding HT interfaces with a non-HT channel type.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/chan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5b24740..8511e60 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -76,6 +76,7 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 
 		switch (tmp->vif.bss_conf.channel_type) {
 		case NL80211_CHAN_NO_HT:
+			break;
 		case NL80211_CHAN_HT20:
 			superchan = tmp->vif.bss_conf.channel_type;
 			break;
-- 
1.7.3.2

