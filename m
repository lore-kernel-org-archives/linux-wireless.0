Return-Path: <SRS0=v3Rz=VA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2214BC06511
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 13:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5B42080C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 13:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGCNib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:38:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38370 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCNib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jul 2019 09:38:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hifSu-0000Uu-Kh; Wed, 03 Jul 2019 15:38:28 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] cfg80211: clean up cfg80211_inform_single_bss_frame_data()
Date:   Wed,  3 Jul 2019 15:38:21 +0200
Message-Id: <20190703133823.10530-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_inform_single_bss_frame_data() doesn't need the
non_tx_data data argument since it's always NULL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d66e6d4b7555..70d061ed9cb6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1776,7 +1776,6 @@ static struct cfg80211_bss *
 cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 				      struct cfg80211_inform_bss *data,
 				      struct ieee80211_mgmt *mgmt, size_t len,
-				      struct cfg80211_non_tx_bss *non_tx_data,
 				      gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
@@ -1835,11 +1834,6 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 	tmp.pub.chains = data->chains;
 	memcpy(tmp.pub.chain_signal, data->chain_signal, IEEE80211_MAX_CHAINS);
 	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
-	if (non_tx_data) {
-		tmp.pub.transmitted_bss = non_tx_data->tx_bss;
-		tmp.pub.bssid_index = non_tx_data->bssid_index;
-		tmp.pub.max_bssid_indicator = non_tx_data->max_bssid_indicator;
-	}
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
@@ -1877,7 +1871,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	struct cfg80211_non_tx_bss non_tx_data;
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
-						    len, NULL, gfp);
+						    len, gfp);
 	if (!res || !wiphy->support_mbssid ||
 	    !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
-- 
2.17.2

