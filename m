Return-Path: <SRS0=vpNd=3C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C36C33CA9
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Jan 2020 18:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2C0207E0
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Jan 2020 18:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tDNHg+NK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAMSVK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:21:10 -0500
Received: from nbd.name ([46.4.11.11]:38002 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728633AbgAMSVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Jan 2020 13:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jfg1CH/BWu8y14E87TMalUIfmXnxxWjXnaCMLIpLMCA=; b=tDNHg+NKl0rDlws2ygYpd0woxj
        6Mn2WR2FddwrqoSFd5f5s2YQsRrVT/RrFtXpWCBSZ6pCi08n/VmEYwE6CQIw1vnlfuGKo+0igiUUu
        U2DKmEAOzdUv1Tggk/jsRh8C+hLC50SBylE94bz9VbK71hHR5TyDE5p4pjc3NWwIguoo=;
Received: from [80.255.7.117] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ir4Kq-0005oU-PE; Mon, 13 Jan 2020 19:21:08 +0100
Received: by maeck.local (Postfix, from userid 501)
        id D159777EB435; Mon, 13 Jan 2020 19:21:07 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5.5] cfg80211: fix page refcount issue in A-MSDU decap
Date:   Mon, 13 Jan 2020 19:21:07 +0100
Message-Id: <20200113182107.20461-1-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The fragments attached to a skb can be part of a compound page. In that case,
page_ref_inc will increment the refcount for the wrong page. Fix this by
using get_page instead, which calls page_ref_inc on the compound head and
also checks for overflow.

Fixes: 2b67f944f88c ("cfg80211: reuse existing page fragments in A-MSDU rx")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 5b4ed5bbc542..8481e9ac33da 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -564,7 +564,7 @@ __frame_add_frag(struct sk_buff *skb, struct page *page,
 	struct skb_shared_info *sh = skb_shinfo(skb);
 	int page_offset;
 
-	page_ref_inc(page);
+	get_page(page);
 	page_offset = ptr - page_address(page);
 	skb_add_rx_frag(skb, sh->nr_frags, page, page_offset, len, size);
 }
-- 
2.24.0

