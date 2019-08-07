Return-Path: <SRS0=5ylD=WD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D07C19759
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 08:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE2A422BED
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 08:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfHGIAA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Aug 2019 04:00:00 -0400
Received: from nbd.name ([46.4.11.11]:33930 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbfHGIAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Aug 2019 04:00:00 -0400
Received: from pd95fd65c.dip0.t-ipconnect.de ([217.95.214.92] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hvGrW-00038j-TG; Wed, 07 Aug 2019 09:59:59 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 1/4] mac80211: fix TX legacy rate reporting when tx_status_ext is used
Date:   Wed,  7 Aug 2019 09:59:46 +0200
Message-Id: <20190807075949.32414-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The RX Radiotap header length was not calculated properly when reporting
legacy rates using tx_status_ext.

fixes commit 3d07ffcaf320 ("mac80211: add struct ieee80211_tx_status
support to ieee80211_add_tx_radiotap_header")

Signed-off-by: John Crispin <john@phrozen.org>
---
 net/mac80211/status.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f03aa8924d23..f984943cdabd 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -260,9 +260,15 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info,
 	int len = sizeof(struct ieee80211_radiotap_header);
 
 	/* IEEE80211_RADIOTAP_RATE rate */
-	if (info->status.rates[0].idx >= 0 &&
-	    !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
-					     IEEE80211_TX_RC_VHT_MCS)))
+	if (status && status->rate && !(status->rate->flags &
+					(RATE_INFO_FLAGS_MCS |
+					 RATE_INFO_FLAGS_60G |
+					 RATE_INFO_FLAGS_VHT_MCS |
+					 RATE_INFO_FLAGS_HE_MCS)))
+		len += 2;
+	else if (info->status.rates[0].idx >= 0 &&
+		 !(info->status.rates[0].flags &
+		   (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS)))
 		len += 2;
 
 	/* IEEE80211_RADIOTAP_TX_FLAGS */
-- 
2.20.1

