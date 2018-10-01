Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EA9C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B0620684
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97B0620684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbeJAQUJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:20:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56124 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbeJAQUJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:20:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6ujQ-0001lX-Ia; Mon, 01 Oct 2018 11:43:12 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: regulatory: make initialization more robust
Date:   Mon,  1 Oct 2018 11:43:00 +0200
Message-Id: <20181001094300.15280-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since my change to split out the regulatory init to occur later,
any issues during earlier cfg80211_init() or errors during the
platform device allocation would lead to crashes later. Make this
more robust by checking that the earlier initialization succeeded.

Fixes: d7be102f2945 ("cfg80211: initialize regulatory keys/database later")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 56be68a27bb9..d7b93a772edc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3829,6 +3829,15 @@ static int __init regulatory_init_db(void)
 {
 	int err;
 
+	/*
+	 * It's possible that - due to other bugs/issues - cfg80211
+	 * never called regulatory_init() below, or that it failed;
+	 * in that case, don't try to do any further work here as
+	 * it's doomed to lead to crashes.
+	 */
+	if (IS_ERR_OR_NULL(reg_pdev))
+		return -EINVAL;
+
 	err = load_builtin_regdb_keys();
 	if (err)
 		return err;
-- 
2.14.4

