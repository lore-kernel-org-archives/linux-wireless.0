Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35915 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdAXPma (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:42:30 -0500
Received: by mail-lf0-f53.google.com with SMTP id z134so113219585lff.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 07:42:29 -0800 (PST)
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>
Subject: [PATCH 2/2] mac80211: use accessor functions to set sta->_flags
Date: Tue, 24 Jan 2017 16:42:11 +0100
Message-Id: <1485272531-11587-2-git-send-email-amadeusz.slawinski@tieto.com> (sfid-20170124_164316_136155_5264F11B)
In-Reply-To: <1485272531-11587-1-git-send-email-amadeusz.slawinski@tieto.com>
References: <1485272531-11587-1-git-send-email-amadeusz.slawinski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cleanup patch to make use of set_sta_flag()/clear_sta_flag() in places
where we access sta->_flags

Signed-off-by: Amadeusz Sławiński <amadeusz.slawinski@tieto.com>
---
 net/mac80211/sta_info.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b6cfcf0..6c9cc2f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1855,13 +1855,13 @@ int sta_info_move_state(struct sta_info *sta,
 	switch (new_state) {
 	case IEEE80211_STA_NONE:
 		if (sta->sta_state == IEEE80211_STA_AUTH)
-			clear_bit(WLAN_STA_AUTH, &sta->_flags);
+			clear_sta_flag(sta, WLAN_STA_AUTH);
 		break;
 	case IEEE80211_STA_AUTH:
 		if (sta->sta_state == IEEE80211_STA_NONE) {
-			set_bit(WLAN_STA_AUTH, &sta->_flags);
+			set_sta_flag(sta, WLAN_STA_AUTH);
 		} else if (sta->sta_state == IEEE80211_STA_ASSOC) {
-			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
+			clear_sta_flag(sta, WLAN_STA_ASSOC);
 			ieee80211_recalc_min_chandef(sta->sdata);
 			if (!sta->sta.support_p2p_ps)
 				ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
@@ -1869,13 +1869,13 @@ int sta_info_move_state(struct sta_info *sta,
 		break;
 	case IEEE80211_STA_ASSOC:
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
-			set_bit(WLAN_STA_ASSOC, &sta->_flags);
+			set_sta_flag(sta, WLAN_STA_ASSOC);
 			ieee80211_recalc_min_chandef(sta->sdata);
 			if (!sta->sta.support_p2p_ps)
 				ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			ieee80211_vif_dec_num_mcast(sta->sdata);
-			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+			clear_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			ieee80211_clear_fast_xmit(sta);
 			ieee80211_clear_fast_rx(sta);
 		}
@@ -1883,7 +1883,7 @@ int sta_info_move_state(struct sta_info *sta,
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
 			ieee80211_vif_inc_num_mcast(sta->sdata);
-			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+			set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			ieee80211_check_fast_xmit(sta);
 			ieee80211_check_fast_rx(sta);
 		}
-- 
1.9.1
