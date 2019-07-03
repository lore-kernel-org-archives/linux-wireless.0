Return-Path: <SRS0=v3Rz=VA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4348DC0650E
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 13:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26DA32080C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jul 2019 13:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGCNib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:38:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGCNib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jul 2019 09:38:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hifSu-0000Uu-V0; Wed, 03 Jul 2019 15:38:29 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] cfg80211: don't parse MBSSID if transmitting BSS isn't created
Date:   Wed,  3 Jul 2019 15:38:22 +0200
Message-Id: <20190703133823.10530-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190703133823.10530-1-johannes@sipsolutions.net>
References: <20190703133823.10530-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Don't parse the multi-BSSID structures if we couldn't even create
their transmitting BSS, this would confuse all of our tracking.

This also means that non_tx_data->tx_bss will never be NULL, so
we can clean up a little bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 70d061ed9cb6..186ae1bb510a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1440,7 +1440,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 			regulatory_hint_found_beacon(wiphy, channel, gfp);
 	}
 
-	if (non_tx_data && non_tx_data->tx_bss) {
+	if (non_tx_data) {
 		/* this is a nontransmitting bss, we need to add it to
 		 * transmitting bss' list if it is not there
 		 */
@@ -1659,6 +1659,8 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
 					      capability, beacon_interval, ie,
 					      ielen, NULL, gfp);
+	if (!res)
+		return NULL;
 	non_tx_data.tx_bss = res;
 	cfg80211_parse_mbssid_data(wiphy, data, ftype, bssid, tsf,
 				   beacon_interval, ie, ielen, &non_tx_data,
-- 
2.17.2

