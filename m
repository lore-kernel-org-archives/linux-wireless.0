Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947A8C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 14:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783A22084C
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 14:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391292AbgE1Oyu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 10:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391243AbgE1Oys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 10:54:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CEBC08C5C6
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 07:54:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeJrc-004vYI-F7; Thu, 28 May 2020 16:50:32 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tova Mussai <tova.mussai@intel.com>
Subject: [PATCH 23/24] mac80211: set short_slot for 6 GHz band
Date:   Thu, 28 May 2020 16:50:19 +0200
Message-Id: <20200528165011.457ca3267eb1.I272fbae402b03123f04e9ae69204eeab960c70cd@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528165011.993f108e96ca.I0086ae42d672379380d04ac5effb2f3d5135731b@changeid>
References: <20200528165011.993f108e96ca.I0086ae42d672379380d04ac5effb2f3d5135731b@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tova Mussai <tova.mussai@intel.com>

Set short slot also for 6 GHz band, just like 5 GHz.

Signed-off-by: Tova Mussai <tova.mussai@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  | 3 ++-
 net/mac80211/mlme.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 90a07d075fdb..9b360544ad6f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2198,7 +2198,8 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    sband->band == NL80211_BAND_5GHZ) {
+	    (sband->band == NL80211_BAND_5GHZ ||
+	     sband->band == NL80211_BAND_6GHZ)) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5922464dc453..84fcd52645cc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2171,7 +2171,8 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (sband->band == NL80211_BAND_5GHZ)
+	if (sband->band == NL80211_BAND_5GHZ ||
+	    sband->band == NL80211_BAND_6GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
-- 
2.26.2

