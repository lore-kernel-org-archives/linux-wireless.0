Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:47819 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZAKSya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 13:54:30 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v2 1/2] mac80211: remove multicast check from check_tim()
To: johannes@sipsolutions.net, vivek.natraj@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Jan 2009 20:54:25 +0200
Message-ID: <20090111185425.6137.92252.stgit@tikku> (sfid-20090111_195432_929456_B95737F7)
In-Reply-To: <20090111185310.6137.66672.stgit@tikku>
References: <20090111185310.6137.66672.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 checks for the multicast tim bit from beacons and
disables power save if the bit is set. This was added to support
ath9k. But this is a bit controversial because the AP will send
multicast frames immediately after the beacon and the time constraints
are really high. Relying mac80211 to be fast enough here might not be
reliable in all situations.

Also with current implementation mac80211 disables power save whenever
multicast bit is set but it's never enabled again. So if dynamic power
save is disabled (iwconfig wlan0 power timeout 0), the power save mode
is enabled only until first multicast/broadcast frame is received, which
isn't a long time in a normal network.

The current implementation is not usable on p54/stlc45xx and the
easiest way to fix this is to remove the multicast tim bit check
altogether. Handling multicast tim bit in host is rare, most of the
designs do this in firmware/hardware, so it's better not to have it in
mac80211. It's a lot better to do this in firmware/hardware, or if
that's not possible it could be done in the driver.

Also renamed the function to ieee80211_check_tim() to follow the style
of the file.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
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

