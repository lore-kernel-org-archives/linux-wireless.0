Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1048 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaDOQOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 12:14:01 -0400
Date: Tue, 15 Apr 2014 19:13:56 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Allow HT capa override to add 40 MHz intolerant
Message-ID: <20140415161356.GA14293@jouni.qca.qualcomm.com> (sfid-20140415_181408_065355_35CF34C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful for testing purposes to confirm valid AP behavior on
HT 20/40 co-existence functionality.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/ht.c   |   18 +++++++++++++++++-
 net/mac80211/main.c |    3 ++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c150b68..7ddb260 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -31,6 +31,18 @@ static void __check_htcap_disable(struct ieee80211_ht_cap *ht_capa,
 	}
 }
 
+static void __check_htcap_enable(struct ieee80211_ht_cap *ht_capa,
+				  struct ieee80211_ht_cap *ht_capa_mask,
+				  struct ieee80211_sta_ht_cap *ht_cap,
+				  u16 flag)
+{
+	__le16 le_flag = cpu_to_le16(flag);
+
+	if ((ht_capa_mask->cap_info & le_flag) &&
+	    (ht_capa->cap_info & le_flag))
+		ht_cap->cap |= flag;
+}
+
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap)
 {
@@ -59,7 +71,7 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	smask = (u8 *)(&ht_capa_mask->mcs.rx_mask);
 
 	/* NOTE:  If you add more over-rides here, update register_hw
-	 * ht_capa_mod_msk logic in main.c as well.
+	 * ht_capa_mod_mask logic in main.c as well.
 	 * And, if this method can ever change ht_cap.ht_supported, fix
 	 * the check in ieee80211_add_ht_ie.
 	 */
@@ -86,6 +98,10 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	__check_htcap_disable(ht_capa, ht_capa_mask, ht_cap,
 			      IEEE80211_HT_CAP_MAX_AMSDU);
 
+	/* Allow user to enable 40 MHz intolerant bit. */
+	__check_htcap_enable(ht_capa, ht_capa_mask, ht_cap,
+			     IEEE80211_HT_CAP_40MHZ_INTOLERANT);
+
 	/* Allow user to decrease AMPDU factor */
 	if (ht_capa_mask->ampdu_params_info &
 	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4c1bf61..d1d50f7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -446,7 +446,8 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 				IEEE80211_HT_CAP_MAX_AMSDU |
 				IEEE80211_HT_CAP_SGI_20 |
-				IEEE80211_HT_CAP_SGI_40),
+				IEEE80211_HT_CAP_SGI_40 |
+				IEEE80211_HT_CAP_40MHZ_INTOLERANT),
 	.mcs = {
 		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
 			     0xff, 0xff, 0xff, 0xff, 0xff, },
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
