Return-Path: <SRS0=4i1v=CA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10993C433E3
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CA12080D
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aAzIgMxU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHVXUG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Aug 2020 19:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgHVXUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Aug 2020 19:20:02 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F8BC061574;
        Sat, 22 Aug 2020 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ff0QBRhB1nNLDhUI1Xp1o62KpueSz58fVp2BodyAIAo=; b=aAzIgMxUCzH4+FeGc0cmfJBeyn
        c2uvVLDI+BDC7V2NFKoLvq1d/v5/JA6Yn+Ke/oAf8Tgx4yvs7qp++mNFUopaxfpXm/5SYCKbeslSU
        bIdmK0AI08HVvn6cxTjncN+inTsTFOOEgfJk8SI+vithkw2eRDzzTAPNLeetG5r5CaKyEw9gSrJAv
        gDDJezORBQKN1dykRPmzYBWBOc6uHHic/F31NSNb7F8CmD8cIOdkS1hEkMPaC4/ZkhxBlZSNsC1lV
        79S0XmtuznUgE1hihSG/NJX2Solvk6SPZJdYqlCKdOPMIVLzYx2u0rnKD6ySdRZhbwO3FHiDMmeFU
        4ROqCIIA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnn-0006fS-Pr; Sat, 22 Aug 2020 23:20:00 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] net: mac80211: agg-rx.c: fix duplicated words
Date:   Sat, 22 Aug 2020 16:19:47 -0700
Message-Id: <20200822231953.465-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Change "If if" to "If it".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/agg-rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/mac80211/agg-rx.c
+++ linux-next-20200731/net/mac80211/agg-rx.c
@@ -350,7 +350,7 @@ void ___ieee80211_start_rx_ba_session(st
 					   sta->sta.addr, tid);
 			/* We have no API to update the timeout value in the
 			 * driver so reject the timeout update if the timeout
-			 * changed. If if did not change, i.e., no real update,
+			 * changed. If it did not change, i.e., no real update,
 			 * just reply with success.
 			 */
 			rcu_read_lock();
