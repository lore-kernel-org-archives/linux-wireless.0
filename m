Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A23C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 17:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3927220651
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 17:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="q4PoNZEk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfCMRyb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:54:31 -0400
Received: from nbd.name ([46.4.11.11]:34652 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfCMRyb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 13:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5zZqXEw7/dzCPSpFudFQ9KHK2gHAqJOPRbUudYzncVQ=; b=q4PoNZEkSGIsdvix3Fc1Gt5jYk
        nkmuwUjUNTNZcIj0DD1xot6k9WsBiPrSYxzn2TPnaMb4ervwp8V+RT8aYNKASzsJIznrgQ7Rxwf42
        Pv92svYiKHwUVppc47ED28WH4UutjD15VeKTXHomk9VGZqPcW4IyRe1eEpDFnUt7hD6g=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h485F-0000C4-79; Wed, 13 Mar 2019 18:54:29 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id 21A29528F81A; Wed, 13 Mar 2019 18:54:27 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix unaligned access in mesh table hash function
Date:   Wed, 13 Mar 2019 18:54:27 +0100
Message-Id: <20190313175427.62271-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The pointer to the last four bytes of the address is not guaranteed to be
aligned, so we need to use __get_unaligned_cpu32 here

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 8822c4f3dc48..0a1148328f19 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -23,7 +23,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl, struct mesh_path *mpath);
 static u32 mesh_table_hash(const void *addr, u32 len, u32 seed)
 {
 	/* Use last four bytes of hw addr as hash index */
-	return jhash_1word(*(u32 *)(addr+2), seed);
+	return jhash_1word(__get_unaligned_cpu32(addr+2), seed);
 }
 
 static const struct rhashtable_params mesh_rht_params = {
-- 
2.17.0

