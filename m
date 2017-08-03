Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35424 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdHCJHG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:07:06 -0400
Received: by mail-pg0-f68.google.com with SMTP id l64so947654pge.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 02:07:06 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: add module parameter to disable 40MHZ support in 2.4G band
Date: Thu,  3 Aug 2017 09:06:55 +0000
Message-Id: <1501751215-12742-1-git-send-email-huxinming820@gmail.com> (sfid-20170803_110710_912989_6295A8A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch provide a new module parameter disable_2g4_40m, with
which driver will not report 40M capability for 2.4GHZ to cfg80211.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 2be7817..820475a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -25,6 +25,10 @@
 static char *reg_alpha2;
 module_param(reg_alpha2, charp, 0);
 
+static bool disable_2g4_40m;
+module_param(disable_2g4_40m, bool, 0000);
+MODULE_PARM_DESC(disable_2g4_40m, "2.4G 40M support disable:1, enable:0");
+
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
 		.max = 3, .types = BIT(NL80211_IFTYPE_STATION) |
@@ -2755,7 +2759,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
  */
 static void
 mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
-		      struct mwifiex_private *priv)
+		      struct mwifiex_private *priv, int disable_40m)
 {
 	int rx_mcs_supp;
 	struct ieee80211_mcs_info mcs_set;
@@ -2769,7 +2773,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
 
 	/* Fill HT capability information */
-	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
+	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) && !disable_40m)
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -2779,7 +2783,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_20;
 
-	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap))
+	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap) && !disable_40m)
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_40;
@@ -2799,7 +2803,8 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_GRN_FLD;
 
-	if (ISENABLED_40MHZ_INTOLERANT(adapter->hw_dot_11n_dev_cap))
+	if (ISENABLED_40MHZ_INTOLERANT(adapter->hw_dot_11n_dev_cap) &&
+	    !disable_40m)
 		ht_info->cap |= IEEE80211_HT_CAP_40MHZ_INTOLERANT;
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_40MHZ_INTOLERANT;
@@ -2819,7 +2824,7 @@ static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
 	memset(&mcs[rx_mcs_supp], 0,
 	       sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
-	    ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
+	    (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) && !disable_40m))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(mcs_set.rx_mask);
 
@@ -2974,14 +2979,15 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	if (ret)
 		goto err_sta_init;
 
-	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
-	if (adapter->is_hw_11ac_capable)
+	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv,
+			      disable_2g4_40m);
+	if (adapter->is_hw_11ac_capable && !disable_2g4_40m)
 		mwifiex_setup_vht_caps(
 			&wiphy->bands[NL80211_BAND_2GHZ]->vht_cap, priv);
 
 	if (adapter->config_bands & BAND_A)
 		mwifiex_setup_ht_caps(
-			&wiphy->bands[NL80211_BAND_5GHZ]->ht_cap, priv);
+			&wiphy->bands[NL80211_BAND_5GHZ]->ht_cap, priv, 0);
 
 	if ((adapter->config_bands & BAND_A) && adapter->is_hw_11ac_capable)
 		mwifiex_setup_vht_caps(
-- 
1.9.1
