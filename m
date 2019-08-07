Return-Path: <SRS0=5ylD=WD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E930C433FF
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 08:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75FB322BED
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 08:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfHGIAB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Aug 2019 04:00:01 -0400
Received: from nbd.name ([46.4.11.11]:33934 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfHGIAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Aug 2019 04:00:00 -0400
Received: from pd95fd65c.dip0.t-ipconnect.de ([217.95.214.92] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hvGrX-00038j-Cr; Wed, 07 Aug 2019 09:59:59 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 2/4] mac80211: fix bad guard when reporting legacy rates
Date:   Wed,  7 Aug 2019 09:59:47 +0200
Message-Id: <20190807075949.32414-2-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807075949.32414-1-john@phrozen.org>
References: <20190807075949.32414-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When reporting legacy rates inside the TX Radiotap header we need to split
the check u between "uses tx_statua_ext" and "is legacy rate". Not doing so
would make the code drop into the !tx_status_ext path.

fixes commit 3d07ffcaf320 ("mac80211: add struct ieee80211_tx_status
support to ieee80211_add_tx_radiotap_header")

Signed-off-by: John Crispin <john@phrozen.org>
---
 net/mac80211/status.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f984943cdabd..eaea07db83e7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -327,13 +327,14 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 
 	/* IEEE80211_RADIOTAP_RATE */
 
-	if (status && status->rate && !(status->rate->flags &
-					(RATE_INFO_FLAGS_MCS |
-					 RATE_INFO_FLAGS_60G |
-					 RATE_INFO_FLAGS_VHT_MCS |
-					 RATE_INFO_FLAGS_HE_MCS)))
-		legacy_rate = status->rate->legacy;
-	else if (info->status.rates[0].idx >= 0 &&
+	if (status && status->rate) {
+		if (!(status->rate->flags &
+		      (RATE_INFO_FLAGS_MCS |
+		       RATE_INFO_FLAGS_60G |
+		       RATE_INFO_FLAGS_VHT_MCS |
+		       RATE_INFO_FLAGS_HE_MCS)))
+			legacy_rate = status->rate->legacy;
+	} else if (info->status.rates[0].idx >= 0 &&
 		 !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
 						  IEEE80211_TX_RC_VHT_MCS)))
 		legacy_rate =
-- 
2.20.1

