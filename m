Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34BEC77B61
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Apr 2023 17:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjDXRtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Apr 2023 13:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjDXRtm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2023 13:49:42 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Apr 2023 10:49:41 PDT
Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93B476A42
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2023 10:49:41 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id r0CUpcWVXvolhr0CUpT3DX; Mon, 24 Apr 2023 19:42:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682358129;
        bh=RGet4KUq9B1fJpP0L51TGQdjanN5MhnW13ggXU8IDME=;
        h=From:To:Cc:Subject:Date;
        b=EeI3HeSgO1T+RpbkqVax1D07SQkY7niWGixqo6V6IiUhuatBwX71Rf4spa/flXjx5
         +f2rmxEFzxNdx2EPGVUwOAVnmkEKsgI1T015mLAWqkv76eslV1Hh7azG8Zp0BDhqHX
         SvW2kamNfl8YoUeV6Nm1roaQbjHl+uD1Z7z7QBoYHy4BsZ6P5uOPL19dCxNwJVWN68
         f8dQ1Z1Aq0d2Ua/NQKIc/+7gpT2n7m115gwStE2Oqs/C3/3yi0liQSaNkt6HLYB5qx
         Y1GCdFdvDb+rdJ81rz7eVQcRHcfPAUceHxtUAyHJ7bp457GTNuHQnP5j5l+EIGZ3gP
         rQHT+QD+KjzXw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 24 Apr 2023 19:42:09 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Aloka Dixit <quic_alokad@quicinc.com>,
        Muna Sinada <quic_msinada@quicinc.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] wifi: mac80211: Fix puncturing bitmap handling in __ieee80211_csa_finalize()
Date:   Mon, 24 Apr 2023 19:42:04 +0200
Message-Id: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

'changed' can be OR'ed with BSS_CHANGED_EHT_PUNCTURING which is larger than
an u32.
So, turn 'changed' into an u64 and update ieee80211_set_after_csa_beacon()
accordingly.

In the commit in Fixes, only ieee80211_start_ap() was updated.

Fixes: 2cc25e4b2a04 ("wifi: mac80211: configure puncturing bitmap")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7317e4a5d1ff..c5e5f783f137 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3589,7 +3589,7 @@ void ieee80211_channel_switch_disconnect(struct ieee80211_vif *vif, bool block_t
 EXPORT_SYMBOL(ieee80211_channel_switch_disconnect);
 
 static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
-					  u32 *changed)
+					  u64 *changed)
 {
 	int err;
 
@@ -3632,7 +3632,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	u32 changed = 0;
+	u64 changed = 0;
 	int err;
 
 	sdata_assert_lock(sdata);
-- 
2.34.1

