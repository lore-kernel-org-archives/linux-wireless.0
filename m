Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:53186 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3CNHdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 03:33:15 -0400
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Date: Thu, 14 Mar 2013 09:33:11 +0200
Subject: [RFC 2/3] mac80211: use ieee80211_p2p_noa_attr structure
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912FA1693F26@EXMB01.eu.tieto.com> (sfid-20130314_083318_863473_90563F4C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_p2p_noa_attr structure during
P2P_PS detection.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/mlme.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fdc06e3..4fecfb8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1655,18 +1655,18 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
 		if (ies) {
-			u8 noa[2];
+			struct ieee80211_p2p_noa_attr noa;
 			int ret;
 
 			ret = cfg80211_get_p2p_attr(
 					ies->data, ies->len,
 					IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
-					noa, sizeof(noa));
+					(u8 *) &noa, sizeof(noa));
 			if (ret >= 2) {
-				bss_conf->p2p_oppps = noa[1] & 0x80;
-				bss_conf->p2p_ctwindow = noa[1] & 0x7f;
+				bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
+				bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
 				bss_info_changed |= BSS_CHANGED_P2P_PS;
-				sdata->u.mgd.p2p_noa_index = noa[0];
+				sdata->u.mgd.p2p_noa_index = noa.index;
 			}
 		}
 		rcu_read_unlock();
@@ -2953,18 +2953,18 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (sdata->vif.p2p) {
-		u8 noa[2];
+		struct ieee80211_p2p_noa_attr noa;
 		int ret;
 
 		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
 					    len - baselen,
 					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
-					    noa, sizeof(noa));
-		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa[0]) {
-			bss_conf->p2p_oppps = noa[1] & 0x80;
-			bss_conf->p2p_ctwindow = noa[1] & 0x7f;
+					    (u8 *) &noa, sizeof(noa));
+		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
+			bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
+			bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
 			changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa[0];
+			sdata->u.mgd.p2p_noa_index = noa.index;
 			/*
 			 * make sure we update all information, the CRC
 			 * mechanism doesn't look at P2P attributes.
-- 
1.7.9.5
