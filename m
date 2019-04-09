Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E08C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B7720880
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 12:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfDIMIY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:08:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48298 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfDIMIY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 08:08:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDpY5-0003Tp-EL; Tue, 09 Apr 2019 14:08:21 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix RX STBC override byte order
Date:   Tue,  9 Apr 2019 14:08:19 +0200
Message-Id: <20190409120819.3196-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The original patch neglected to take byte order conversions
into account, fix that.

Fixes: d9bb410888ce ("mac80211: allow overriding HT STBC capabilities")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index e03c46ac8e4d..f0735413bff3 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -112,8 +112,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 			     IEEE80211_HT_CAP_TX_STBC);
 
 	/* Allow user to configure RX STBC bits */
-	if (ht_capa_mask->cap_info & IEEE80211_HT_CAP_RX_STBC)
-		ht_cap->cap |= ht_capa->cap_info & IEEE80211_HT_CAP_RX_STBC;
+	if (ht_capa_mask->cap_info & cpu_to_le16(IEEE80211_HT_CAP_RX_STBC))
+		ht_cap->cap |= ht_capa->cap_info &
+					cpu_to_le16(IEEE80211_HT_CAP_RX_STBC);
 
 	/* Allow user to decrease AMPDU factor */
 	if (ht_capa_mask->ampdu_params_info &
-- 
2.17.2

