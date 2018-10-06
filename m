Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A56AC67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBB1F2064E
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="lrmbFNvG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBB1F2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbeJGAjW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:22 -0400
Received: from nbd.name ([46.4.11.11]:35796 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbeJGAjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P0ku8bIgjeRHKooDkEFiJGVk9VEUPzxc+ybYWRDik8g=; b=lrmbFNvGChCaTWoSwSlhHRVMDA
        5MGLDVx+abQjun16cx3dPRcWeO6YxokkWFIlrAio1/eObhZDwbdtQi2DaPf5hPljD+phACqdGF5Ff
        cYQun6MkIT1RKeHm6Y+EAOR33jcUar9BZ5aOwpB3cza/rGmYdCsYmWCPwpdsOaPyuHqY=;
Received: by maeck.local (Postfix, from userid 501)
        id 2E6603E6EAF4; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 5/9] mac80211: minstrel: fix using short preamble CCK rates on HT clients
Date:   Sat,  6 Oct 2018 19:35:03 +0200
Message-Id: <20181006173507.7316-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181006173507.7316-1-nbd@nbd.name>
References: <20181006173507.7316-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mi->supported[MINSTREL_CCK_GROUP] needs to be updated
short preamble rates need to be marked as supported regardless of
whether it's currently enabled. Its state can change at any time without
a rate_update call.

Fixes: 782dda00ab8e ("mac80211: minstrel_ht: move short preamble check out of get_rate")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 38e17ed20d41..118ffe7f88c4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1135,7 +1135,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 ht_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-	struct sta_info *sinfo = container_of(sta, struct sta_info, sta);
 	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
@@ -1265,8 +1264,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!n_supported)
 		goto use_legacy;
 
-	if (test_sta_flag(sinfo, WLAN_STA_SHORT_PREAMBLE))
-		mi->cck_supported_short |= mi->cck_supported_short << 4;
+	mi->supported[MINSTREL_CCK_GROUP] |= mi->cck_supported_short << 4;
 
 	/* create an initial rate table with the lowest supported rates */
 	minstrel_ht_update_stats(mp, mi);
-- 
2.17.0

