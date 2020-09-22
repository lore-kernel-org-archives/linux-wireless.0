Return-Path: <SRS0=PYjY=C7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198CDC4363D
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Sep 2020 05:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E921523A9C
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Sep 2020 05:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgIVFhf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Sep 2020 01:37:35 -0400
Received: from mail.adapt-ip.com ([173.164.178.19]:34072 "EHLO
        web.adapt-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728898AbgIVFhe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Sep 2020 01:37:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by web.adapt-ip.com (Postfix) with ESMTP id 254AC4F9DFF;
        Tue, 22 Sep 2020 05:37:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at web.adapt-ip.com
Received: from web.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sb7T494zj5k0; Tue, 22 Sep 2020 05:37:31 +0000 (UTC)
Received: from atlas.campbell.adapt-ip.com (gateway.adapt-ip.com [173.164.178.20])
        (Authenticated sender: thomas@adapt-ip.com)
        by web.adapt-ip.com (Postfix) with ESMTPSA id 7CEBB4F9E01;
        Tue, 22 Sep 2020 05:37:19 +0000 (UTC)
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>
Subject: [PATCH v4 10/17] mac80211: don't calculate duration for S1G
Date:   Mon, 21 Sep 2020 19:28:11 -0700
Message-Id: <20200922022818.15855-11-thomas@adapt-ip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200922022818.15855-1-thomas@adapt-ip.com>
References: <20200922022818.15855-1-thomas@adapt-ip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For now just skip the duration calculation for frames
transmitted on the S1G band and avoid a warning.

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
---
 net/mac80211/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index adc83d830691..713b432e3d8b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -82,6 +82,10 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 
 	erp = txrate->flags & IEEE80211_RATE_ERP_G;
 
+	/* device is expected to do this */
+	if (sband->band == NL80211_BAND_S1GHZ)
+		return 0;
+
 	/*
 	 * data and mgmt (except PS Poll):
 	 * - during CFP: 32768
-- 
2.20.1

