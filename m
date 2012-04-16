Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34024 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab2DPUKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:10:54 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3.4] mac80211: fix logic error in ibss channel type check
Date: Mon, 16 Apr 2012 22:10:42 +0200
Message-Id: <1334607042-32574-1-git-send-email-nbd@openwrt.org> (sfid-20120416_221059_319517_200D2B37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The broken check leads to rate control attempting to use HT40 while
the driver is configured for HT20. This leads to interesting hardware
issues.

HT40 can only be used if the channel type is either HT40- or HT40+
and if the channel type of the cell matches the local type.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/mac80211/ibss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 49a2079..61cd391 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -455,8 +455,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if ((channel_type == NL80211_CHAN_HT40MINUS ||
-			     channel_type == NL80211_CHAN_HT40PLUS) &&
+			if (!(channel_type == NL80211_CHAN_HT40MINUS ||
+			      channel_type == NL80211_CHAN_HT40PLUS) ||
 			    channel_type != sdata->u.ibss.channel_type)
 				sta_ht_cap_new.cap &=
 					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-- 
1.7.3.2

