Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55556 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab3CUOsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 10:48:15 -0400
Received: by mail-ee0-f44.google.com with SMTP id l10so1762491eei.17
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 07:48:14 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/4] mac80211: use ieee80211_p2p_noa_attr structure
Date: Thu, 21 Mar 2013 15:47:55 +0100
Message-Id: <1363877277-5108-2-git-send-email-janusz.dziedzic@gmail.com> (sfid-20130321_154852_909532_7129C657)
In-Reply-To: <1363877277-5108-1-git-send-email-janusz.dziedzic@gmail.com>
References: <1363877277-5108-1-git-send-email-janusz.dziedzic@gmail.com>
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
@@ -1655,18 +1655,20 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
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
@@ -2953,18 +2955,20 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
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

