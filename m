Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:61937 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbZAVLqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 06:46:12 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v2 1/2] mac80211: remove multicast check from check_tim()
To: johannes@sipsolutions.net, vivek.natraj@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Jan 2009 13:45:39 +0200
Message-ID: <20090122114539.31443.45201.stgit@tikku> (sfid-20090122_124615_168068_35735FF9)
In-Reply-To: <20090122114240.31443.18218.stgit@tikku>
References: <20090122114240.31443.18218.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 checks for the multicast tim bit from beacons,
disables power save and sends a null frame if the bit is set. This was
added to support ath9k. But this is a bit controversial because the AP will
send multicast frames immediately after the beacon and the time constraints
are really high. Relying mac80211 to be fast enough here might not be
reliable in all situations. And there's no need to send a null frame, AP
will send the frames immediately after the dtim beacon no matter what.

Also if dynamic power save is disabled (iwconfig wlan0 power timeout 0)
currently mac80211 disables power save whenever the multicast bit is set
but it's never enabled again after receiving the first multicast/broadcast
frame.

The current implementation is not usable on p54/stlc45xx and the
easiest way to fix this is to remove the multicast tim bit check
altogether. Handling multicast tim bit in host is rare, most of the
designs do this in firmware/hardware, so it's better not to have it in
mac80211. It's a lot better to do this in firmware/hardware, or if
that's not possible it could be done in the driver.

Also renamed the function to ieee80211_check_tim() to follow the style
of the file.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/mlme.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 51f021f..c7e61e2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -575,7 +575,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	}
 }
 
-static bool check_tim(struct ieee802_11_elems *elems, u16 aid, bool *is_mc)
+static bool ieee80211_check_tim(struct ieee802_11_elems *elems, u16 aid)
 {
 	u8 mask;
 	u8 index, indexn1, indexn2;
@@ -585,9 +585,6 @@ static bool check_tim(struct ieee802_11_elems *elems, u16 aid, bool *is_mc)
 	index = aid / 8;
 	mask  = 1 << (aid & 7);
 
-	if (tim->bitmap_ctrl & 0x01)
-		*is_mc = true;
-
 	indexn1 = tim->bitmap_ctrl & 0xfe;
 	indexn2 = elems->tim_len + indexn1 - 4;
 
@@ -1788,7 +1785,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
-	bool erp_valid, directed_tim, is_mc = false;
+	bool erp_valid, directed_tim;
 	u8 erp_value = 0;
 
 	/* Process beacon from the current BSS */
@@ -1816,9 +1813,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK &&
 	    local->hw.conf.flags & IEEE80211_CONF_PS) {
-		directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
+		directed_tim = ieee80211_check_tim(&elems, ifsta->aid);
 
-		if (directed_tim || is_mc) {
+		if (directed_tim) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
 			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 			ieee80211_send_nullfunc(local, sdata, 0);

