Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28085 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbCBIAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 03:00:54 -0500
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH v2] mac80211: send station PMF configuration to driver
Date: Mon, 2 Mar 2015 13:29:40 +0530
Message-ID: <1425283180-3848-1-git-send-email-sjegadee@qti.qualcomm.com> (sfid-20150302_090103_462038_6EC087B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to provide station PMF configuration to driver.

Some device drivers, offload part of aggregation including ADDBa/DELBa
negotiations to low layers. In such scenario, PMF configuration of
station needs to be provided to driver to enable encryption of
ADDBa/DELBa action frames.

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 include/net/mac80211.h | 3 +++
 net/mac80211/cfg.c     | 1 +
 net/mac80211/mlme.c    | 6 +++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d52914b..1502086 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1488,6 +1488,8 @@ struct ieee80211_sta_rates {
  * @tdls: indicates whether the STA is a TDLS peer
  * @tdls_initiator: indicates the STA is an initiator of the TDLS link. Only
  *	valid if the STA is a TDLS peer in the first place.
+ * @mfp: indicates whether the STA supports management frame
+ *	protection.
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1504,6 +1506,7 @@ struct ieee80211_sta {
 	struct ieee80211_sta_rates __rcu *rates;
 	bool tdls;
 	bool tdls_initiator;
+	bool mfp;

 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..c124626 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1068,6 +1068,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);

 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
+		sta->sta.mfp = !!(set & BIT(NL80211_STA_FLAG_MFP));
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			set_sta_flag(sta, WLAN_STA_MFP);
 		else
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 10ac632..52c34cd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2969,8 +2969,12 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,

 	rate_control_rate_init(sta);

-	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
+	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED) {
 		set_sta_flag(sta, WLAN_STA_MFP);
+		sta->sta.mfp = true;
+	} else {
+		sta->sta.mfp = false;
+	}

 	sta->sta.wme = elems.wmm_param;

--
1.9.1

