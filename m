Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C80C6786F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB4F2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 08:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AB4F2080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbeJ3RKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 13:10:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53862 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbeJ3RKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 13:10:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHPDz-00079d-Lp; Tue, 30 Oct 2018 09:18:07 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: fix CSA beacon allocation size
Date:   Tue, 30 Oct 2018 09:17:45 +0100
Message-Id: <20181030081745.15771-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20181030081745.15771-1-johannes@sipsolutions.net>
References: <20181030081745.15771-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If the FTM responder settings are changed simultaneously with
the CSA beacon, the buffer size allocated isn't sufficient and
we'll have a heap overrun. Fix this.

While at it, also clean up the ftm_responder assignment, doing
it only if ftm_responder is non-zero is valid as it's 0 to start
with, but not really useful to understand the code.

Fixes: bc847970f432 ("mac80211: support FTM responder configuration/statistics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..818aa0060349 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2891,7 +2891,7 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 
 	len = beacon->head_len + beacon->tail_len + beacon->beacon_ies_len +
 	      beacon->proberesp_ies_len + beacon->assocresp_ies_len +
-	      beacon->probe_resp_len;
+	      beacon->probe_resp_len + beacon->lci_len + beacon->civicloc_len;
 
 	new_beacon = kzalloc(sizeof(*new_beacon) + len, GFP_KERNEL);
 	if (!new_beacon)
@@ -2934,8 +2934,9 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
 		pos += beacon->probe_resp_len;
 	}
-	if (beacon->ftm_responder)
-		new_beacon->ftm_responder = beacon->ftm_responder;
+
+	/* might copy -1, meaning no changes requested */
+	new_beacon->ftm_responder = beacon->ftm_responder;
 	if (beacon->lci) {
 		new_beacon->lci_len = beacon->lci_len;
 		new_beacon->lci = pos;
-- 
2.17.2

