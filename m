Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0ADC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19A4C20652
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfDZIm7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 04:42:59 -0400
Received: from nbd.name ([46.4.11.11]:53226 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfDZIm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 04:42:57 -0400
Received: from p548c8674.dip0.t-ipconnect.de ([84.140.134.116] helo=bertha.fritz.box)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hJwRZ-0007KY-1c; Fri, 26 Apr 2019 10:42:53 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH 1/3] mac80211: allow turning TWT responder support on and off via netlink
Date:   Fri, 26 Apr 2019 10:42:42 +0200
Message-Id: <20190426084244.28098-2-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426084244.28098-1-john@phrozen.org>
References: <20190426084244.28098-1-john@phrozen.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow the userland daemon to en/disable TWT support for an AP.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 include/net/cfg80211.h       | 2 ++
 include/net/mac80211.h       | 5 +++++
 include/uapi/linux/nl80211.h | 4 ++++
 net/mac80211/cfg.c           | 6 ++++++
 net/wireless/nl80211.c       | 5 +++++
 5 files changed, 22 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a11ee63..8a20f5a42977 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1511,6 +1511,7 @@ struct mpath_info {
  * 	(u16 = opmode, -1 = do not change)
  * @p2p_ctwindow: P2P CT Window (-1 = no change)
  * @p2p_opp_ps: P2P opportunistic PS (-1 = no change)
+ * @twt_responder: HE Target Wait Time support.
  */
 struct bss_parameters {
 	int use_cts_prot;
@@ -1521,6 +1522,7 @@ struct bss_parameters {
 	int ap_isolate;
 	int ht_opmode;
 	s8 p2p_ctwindow, p2p_opp_ps;
+	int twt_responder;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2ed8ec662b..87a6e149abda 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -317,6 +317,7 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
  * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
  *	functionality changed for this BSS (AP mode).
+ * @BSS_CHANGED_TWT: TWT enable status changed
  *
  */
 enum ieee80211_bss_change {
@@ -347,6 +348,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 	BSS_CHANGED_MCAST_RATE		= 1<<25,
 	BSS_CHANGED_FTM_RESPONDER	= 1<<26,
+	BSS_CHANGED_TWT			= 1<<27,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -504,6 +506,8 @@ struct ieee80211_ftm_responder_params {
  * @he_support: does this BSS support HE
  * @twt_requester: does this BSS support TWT requester (relevant for managed
  *	mode only, set if the AP advertises TWT responder role)
+ * @twt_responder: does this BSS support TWT responder (relevant for AP
+ *	mode only, set if the AP advertises TWT responder role)
  * @assoc: association status
  * @ibss_joined: indicates whether this station is part of an IBSS
  *	or not
@@ -611,6 +615,7 @@ struct ieee80211_bss_conf {
 	u16 frame_time_rts_th;
 	bool he_support;
 	bool twt_requester;
+	bool twt_responder;
 	/* association related data */
 	bool assoc, ibss_joined;
 	bool ibss_creator;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86ee286e..ba1f69751a4a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2308,6 +2308,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
  *	scheduler.
  *
+ * @NL80211_ATTR_TWT_RESPONDER: Enable target wait time responder support.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2759,6 +2761,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AIRTIME_WEIGHT,
 
+	NL80211_ATTR_TWT_RESPONDER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 09dd1c2860fc..a66600bf9cef 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2176,6 +2176,12 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_P2P_PS;
 	}
 
+	if (params->twt_responder >= 0) {
+		sdata->vif.bss_conf.twt_responder =
+			params->twt_responder;
+		changed |= BSS_CHANGED_TWT;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25a9e3b5c154..4f98ee0a98f3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6105,6 +6105,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	params.ht_opmode = -1;
 	params.p2p_ctwindow = -1;
 	params.p2p_opp_ps = -1;
+	params.twt_responder = -1;
 
 	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
 		params.use_cts_prot =
@@ -6149,6 +6150,10 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_TWT_RESPONDER])
+		params.twt_responder =
+		    nla_get_u8(info->attrs[NL80211_ATTR_TWT_RESPONDER]);
+
 	if (!rdev->ops->change_bss)
 		return -EOPNOTSUPP;
 
-- 
2.11.0

