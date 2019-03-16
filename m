Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6521BC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F07D218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 17:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="taMkpusa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfCPRGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:06:38 -0400
Received: from nbd.name ([46.4.11.11]:55500 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfCPRGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 13:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1CfOMgju2cup4ZCplUj/wHStT67GkO5CmSz7bJxHpKs=; b=taMkpusa5jTrvfFTYhNoz432Vb
        ck3ZI9mYuaI4ihokDRTb+sTXOoVTmfI8sNqi13xucXU0l5jcWMFtO1Q8VOVm46GL6HK+Gv8QVkmEg
        6YQMzBFMSLGyoTsBIRzH+yQ2vDnD0L+osv1oIE22cfaQkJ1N15m5S0k8Mn/t9WyjRVWE=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5ClX-00071q-PE; Sat, 16 Mar 2019 18:06:36 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CCC8052C90E6; Sat, 16 Mar 2019 18:06:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 2/5] mac80211: fix memory accounting with A-MSDU aggregation
Date:   Sat, 16 Mar 2019 18:06:31 +0100
Message-Id: <20190316170634.13125-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316170634.13125-1-nbd@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

skb->truesize can change due to memory reallocation or when adding extra
fragments. Adjust fq->memory_usage accordingly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 51cc37802439..0b73a0fe8218 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3227,6 +3227,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	u8 max_subframes = sta->sta.max_amsdu_subframes;
 	int max_frags = local->hw.max_tx_fragments;
 	int max_amsdu_len = sta->sta.max_amsdu_len;
+	int orig_truesize;
 	__be16 len;
 	void *data;
 	bool ret = false;
@@ -3267,6 +3268,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!head || skb_is_gso(head))
 		goto out;
 
+	orig_truesize = head->truesize;
 	orig_len = head->len;
 
 	if (skb->len + head->len > max_amsdu_len)
@@ -3324,6 +3326,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	*frag_tail = skb;
 
 out_recalc:
+	fq->memory_usage += head->truesize - orig_truesize;
 	if (head->len != orig_len) {
 		flow->backlog += head->len - orig_len;
 		tin->backlog_bytes += head->len - orig_len;
-- 
2.17.0

