Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54998 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab3CTTNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 15:13:36 -0400
Received: by mail-ie0-f181.google.com with SMTP id 17so2476828iea.40
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 12:13:35 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 20:13:35 +0100
Message-ID: <CAFED-jk3UYwxD52mWOQA_DRfzz3Sv90To6sQ9A5R2Ni+dX4w7Q@mail.gmail.com> (sfid-20130320_201342_230293_2E92276E)
Subject: [PATCH 2/4] mac80211: use ieee80211_p2p_noa_attr structure
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_p2p_noa_attr structure during
P2P_PS (oppps) detection.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/mlme.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fdc06e3..14612cd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1655,18 +1655,20 @@ static void ieee80211_set_associated(struct
ieee80211_sub_if_data *sdata,
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
+				bss_conf->p2p_oppps = noa.oppps_ctwindow &
+						IEEE80211_P2P_OPPPS_ENABLE_BIT;
+				bss_conf->p2p_ctwindow = noa.oppps_ctwindow &
+						IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
 				bss_info_changed |= BSS_CHANGED_P2P_PS;
-				sdata->u.mgd.p2p_noa_index = noa[0];
+				sdata->u.mgd.p2p_noa_index = noa.index;
 			}
 		}
 		rcu_read_unlock();
@@ -2953,18 +2955,20 @@ ieee80211_rx_mgmt_beacon(struct
ieee80211_sub_if_data *sdata,
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
+			bss_conf->p2p_oppps = noa.oppps_ctwindow &
+						IEEE80211_P2P_OPPPS_ENABLE_BIT;
+			bss_conf->p2p_ctwindow = noa.oppps_ctwindow &
+						IEEE80211_P2P_OPPPS_CTWINDOW_MASK;
 			changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa[0];
+			sdata->u.mgd.p2p_noa_index = noa.index;
 			/*
 			 * make sure we update all information, the CRC
 			 * mechanism doesn't look at P2P attributes.
-- 
1.7.9.5
