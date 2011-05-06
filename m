Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50994 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab1EFAlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 20:41:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	greearb@candelatech.com
Subject: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP interfaces
Date: Fri,  6 May 2011 02:41:14 +0200
Message-Id: <1304642474-32935-1-git-send-email-nbd@openwrt.org> (sfid-20110506_024151_061932_3EE28DE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS filtering is only useful in AP mode and by setting the flags in mac80211,
vif mode checks do not have to be added to every single driver supporting
this.
Fixes part of a regression introduced in commit 93ae2dd2
"ath9k: assign keycache slots to unencrypted stations"

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/tx.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1a39ed..b301216 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1267,6 +1267,9 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	else if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	         sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
-- 
1.7.3.2

