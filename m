Return-Path: <SRS0=zIvl=3Y=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9914C35247
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Feb 2020 15:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFE52087E
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Feb 2020 15:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgBDPG1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:06:27 -0500
Received: from nbd.name ([46.4.11.11]:40652 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbgBDPG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Feb 2020 10:06:26 -0500
Received: from [149.224.158.146] (helo=bertha.datto.lan)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1iyzmS-0006jm-DF; Tue, 04 Feb 2020 16:06:24 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Miles Hu <milehu@codeaurora.org>,
        John Crispin <john@phrozen.org>
Subject: [PATCH] mac80211: add HE support to ieee80211_calculate_rx_timestamp
Date:   Tue,  4 Feb 2020 16:06:18 +0100
Message-Id: <20200204150618.15676-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miles Hu <milehu@codeaurora.org>

The RX timestamp was not calculated for HE yet. This patch adds the
missing case clause.

Signed-off-by: Miles Hu <milehu@codeaurora.org>
Tested-by: John Crispin <john@phrozen.org>
---
 net/mac80211/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 780df3e9092e..876f2d92347b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3242,6 +3242,13 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
+	case RX_ENC_HE:
+		ri.flags |= RATE_INFO_FLAGS_HE_MCS;
+		ri.mcs = status->rate_idx;
+		ri.nss = status->nss;
+		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
+			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
+		break;
 	default:
 		WARN_ON(1);
 		/* fall through */
-- 
2.20.1

