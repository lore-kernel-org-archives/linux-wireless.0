Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZBKQvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 11:51:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 08:51:48 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Make sure non-HT connection when IEEE80211_STA_TKIP_WEP_USED is set
Date: Wed, 11 Feb 2009 22:18:49 +0530
Message-ID: <1234370929-19519-1-git-send-email-vasanth@atheros.com> (sfid-20090211_175156_439151_EFED00D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possible that some broken AP might send HT IEs in it's
assoc response even though the STA has not sent them in assoc req
when WEP/TKIP is used as pairwise cipher suite. Also it is important
to check this bit before enabling ht mode in beacon receive path.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/mlme.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 169f10c..e7aafb0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1532,7 +1532,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					 elems.wmm_param_len);
 
 	if (elems.ht_info_elem && elems.wmm_param &&
-	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
+	    !(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       ap_ht_cap_flags);
 
@@ -1933,7 +1934,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			erp_valid, erp_value);
 
 
-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param) {
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
+	    !(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED)) {
 		struct sta_info *sta;
 		struct ieee80211_supported_band *sband;
 		u16 ap_ht_cap_flags;
-- 
1.5.5.1

