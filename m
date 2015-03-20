Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43157 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbbCTPY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:24:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: don't look up destination station twice
Date: Fri, 20 Mar 2015 16:24:21 +0100
Message-Id: <1426865064-17707-2-git-send-email-johannes@sipsolutions.net> (sfid-20150320_162438_430479_9D56D8E3)
In-Reply-To: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
References: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to look up the destination station twice while
building the 802.11 header for a given frame if the frame will
actually be transmitted to the station we initially looked up.

This happens for 4-addr VLAN interfaces and TDLS connections, which
both directly send the frame to the station they looked up, though
in the case of TDLS some station conditions need to be checked.

To avoid that, add a variable indicating that we've looked up the
station that the frame is going to be transmitted to, and avoid the
lookup/flag checking if it already has been done.

In the TDLS case, also move the authorized/wme_sta flag assignment
to the correct place, i.e. only when that station is really used.
Before this change, the new lookup should always have succeeded so
that the potentially erroneous data would be overwritten.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0bae03bca49e..dcf60ee38b93 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1816,6 +1816,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	bool wme_sta = false, authorized = false, tdls_auth = false;
 	bool tdls_peer = false, tdls_setup_frame = false;
 	bool multicast;
+	bool have_station = false;
 	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
@@ -1840,6 +1841,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			hdrlen = 30;
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
+			have_station = true;
 		}
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
@@ -1956,9 +1958,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 			sta = sta_info_get(sdata, skb->data);
 			if (sta) {
-				authorized = test_sta_flag(sta,
-							WLAN_STA_AUTHORIZED);
-				wme_sta = sta->sta.wme;
 				tdls_peer = test_sta_flag(sta,
 							  WLAN_STA_TDLS_PEER);
 				tdls_auth = test_sta_flag(sta,
@@ -1990,6 +1989,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 			memcpy(hdr.addr3, sdata->u.mgd.bssid, ETH_ALEN);
 			hdrlen = 24;
+			have_station = true;
+			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+			wme_sta = sta->sta.wme;
 		}  else if (sdata->u.mgd.use_4addr &&
 			    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
@@ -2052,7 +2054,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	 * in AP mode)
 	 */
 	multicast = is_multicast_ether_addr(hdr.addr1);
-	if (!multicast) {
+	if (!multicast && !have_station) {
 		sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-- 
2.1.4

