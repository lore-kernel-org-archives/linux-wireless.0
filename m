Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54837 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1CKUqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:46:21 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	greearb@candelatech.com
Subject: [PATCH v2] mac80211: fix channel type recalculation with HT and non-HT interfaces
Date: Fri, 11 Mar 2011 21:45:51 +0100
Message-Id: <1299876351-3329-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running an AP interface along with the cooked monitor interface created
by hostapd, adding an interface and deleting it again triggers a channel type
recalculation during which the (non-HT) monitor interface takes precedence
over the HT AP interface, thus causing the channel type to be set to non-HT.
Fix this by ensuring that a more wide channel type will not be overwritten
by a less wide channel type.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/chan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5b24740..889c3e9 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -77,6 +77,9 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 		switch (tmp->vif.bss_conf.channel_type) {
 		case NL80211_CHAN_NO_HT:
 		case NL80211_CHAN_HT20:
+			if (superchan > tmp->vif.bss_conf.channel_type)
+				break;
+
 			superchan = tmp->vif.bss_conf.channel_type;
 			break;
 		case NL80211_CHAN_HT40PLUS:
-- 
1.7.3.2

