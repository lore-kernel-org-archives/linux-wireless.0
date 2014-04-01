Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37517 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAFNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 01:13:36 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so2644416wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 22:13:35 -0700 (PDT)
From: Pawel Kulakowski <pawel.kulakowski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Pawel Kulakowski <pawel.kulakowski@tieto.com>
Subject: [PATCH] mac80211: Allow disabling LDPC
Date: Tue,  1 Apr 2014 07:13:21 +0200
Message-Id: <1396329202-2549-1-git-send-email-pawel.kulakowski@tieto.com> (sfid-20140401_071339_294088_A274E3C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user-space (wpa_supplicant) to disable LDPC coding.

Signed-off-by: Pawel Kulakowski <pawel.kulakowski@tieto.com>
---
 net/mac80211/ht.c   |    4 ++++
 net/mac80211/main.c |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c150b68..1495b9e 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -86,6 +86,10 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
 			      IEEE80211_HT_CAP_MAX_AMSDU);
 
+	/* Allow user to disable LDPC */
+	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
+			      IEEE80211_HT_CAP_LDPC_CODING);
+
 	/* Allow user to decrease AMPDU factor */
 	if (ht_capa_mask->ampdu_params_info &
 	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b055f6a5..cfc24e9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -444,7 +444,8 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 				IEEE80211_HT_CAP_MAX_AMSDU |
 				IEEE80211_HT_CAP_SGI_20 |
-				IEEE80211_HT_CAP_SGI_40),
+				IEEE80211_HT_CAP_SGI_40 |
+				IEEE80211_HT_CAP_LDPC_CODING),
 	.mcs = {
 		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
 			     0xff, 0xff, 0xff, 0xff, 0xff, },
-- 
1.7.9.5

