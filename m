Return-Path: <SRS0=kZdm=TH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EBEC04AAB
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 06:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CACD205C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 06:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557208847;
	bh=36BUSRee9HE2uWpbcerLnNOQq+0cWm2BA22NuOBMvHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0BzhMmS/hEA6u0UIudSmh+PpCRH6MpoiuXxH348OV8d/Bv3Gyu6cs3bh9LjqOQ1Fc
	 TF3YnoIhkwv1WvSLwCFrNLQ3DWXo/AMd55Fb4SkZu32NpVW3pbmXU3keLHZu74kHWl
	 B5n8RWKgk1XWyb6zoZ/JRtARQPjCVlLItaCp3DEo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfEGGAm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 May 2019 02:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbfEGFgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 May 2019 01:36:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B0720C01;
        Tue,  7 May 2019 05:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207373;
        bh=36BUSRee9HE2uWpbcerLnNOQq+0cWm2BA22NuOBMvHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npY/Gu/oB/HNb1OX3kMa8vOVVmmZauW9w5zBn1DfL9MI4BYaRGGpOEvj4pui2D/AA
         CEfvSbHFcA1X+fy9D42vu8HNyGH//hh41xjKfmfvOEqYJOn0jAxSfHSppL+HAcQAW+
         Ew4RAVm1qLOiemmiQfvbYv6pUmUOCNp2/m96knY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/81] mac80211: fix memory accounting with A-MSDU aggregation
Date:   Tue,  7 May 2019 01:34:45 -0400
Message-Id: <20190507053554.30848-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit eb9b64e3a9f8483e6e54f4e03b2ae14ae5db2690 ]

skb->truesize can change due to memory reallocation or when adding extra
fragments. Adjust fq->memory_usage accordingly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 743cde66aaf6..2f726cde9998 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3185,6 +3185,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	u8 max_subframes = sta->sta.max_amsdu_subframes;
 	int max_frags = local->hw.max_tx_fragments;
 	int max_amsdu_len = sta->sta.max_amsdu_len;
+	int orig_truesize;
 	__be16 len;
 	void *data;
 	bool ret = false;
@@ -3218,6 +3219,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!head)
 		goto out;
 
+	orig_truesize = head->truesize;
 	orig_len = head->len;
 
 	if (skb->len + head->len > max_amsdu_len)
@@ -3272,6 +3274,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	*frag_tail = skb;
 
 out_recalc:
+	fq->memory_usage += head->truesize - orig_truesize;
 	if (head->len != orig_len) {
 		flow->backlog += head->len - orig_len;
 		tin->backlog_bytes += head->len - orig_len;
-- 
2.20.1

