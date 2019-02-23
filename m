Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F54DC10F07
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 05:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E11420850
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 05:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfBWFbA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 00:31:00 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:60710 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfBWFbA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 00:31:00 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gxPtl-0001c1-QG; Sat, 23 Feb 2019 13:30:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gxPtf-0000qU-JS; Sat, 23 Feb 2019 13:30:47 +0800
Date:   Sat, 23 Feb 2019 13:30:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@01.org, kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, netdev@vger.kernel.org
Subject: [PATCH] ila: Fix uninitialised return value in ila_xlat_nl_cmd_flush
Message-ID: <20190223053047.tiwcuvs6tcg2htie@gondor.apana.org.au>
References: <20190223042747.GK1711@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223042747.GK1711@kadam>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Feb 23, 2019 at 07:27:47AM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> head:   db0342b20f32f584aedff27c9c09e0a4bbe5beff
> commit: 6c4128f658571b2dc7e01058ad09a8e947bc0159 [25/27] rhashtable: Remove obsolete rhashtable_walk_init function
> 
> smatch warnings:
> net/ipv6/ila/ila_xlat.c:420 ila_xlat_nl_cmd_flush() error: uninitialized symbol 'ret'.

Thanks for catching this.

---8<---
This patch fixes an uninitialised return value error in
ila_xlat_nl_cmd_flush.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6c4128f65857 ("rhashtable: Remove obsolete...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index ae6cd4cef8db..79d2e43c05c5 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -383,7 +383,7 @@ int ila_xlat_nl_cmd_flush(struct sk_buff *skb, struct genl_info *info)
 	struct rhashtable_iter iter;
 	struct ila_map *ila;
 	spinlock_t *lock;
-	int ret;
+	int ret = 0;
 
 	rhashtable_walk_enter(&ilan->xlat.rhash_table, &iter);
 	rhashtable_walk_start(&iter);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
