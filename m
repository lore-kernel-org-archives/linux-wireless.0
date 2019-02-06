Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99A0C282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E7C2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfBFLRa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:17:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55678 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727501AbfBFLRa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:17:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCp-0001ED-TC; Wed, 06 Feb 2019 13:17:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:07 +0200
Message-Id: <20190206111721.29283-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/15] cfg80211: pmsr: record netlink port ID
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Without recording the netlink port ID, we cannot return the
results or complete messages to userspace, nor will we be
able to abort if the socket is closed, so clearly we need
to fill the value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/pmsr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index de9286703280..70b1d2983552 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -272,6 +272,7 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 
 	req->n_peers = count;
 	req->cookie = cfg80211_assign_cookie(rdev);
+	req->nl_portid = info->snd_portid;
 
 	err = rdev_start_pmsr(rdev, wdev, req);
 	if (err)
-- 
2.20.1

