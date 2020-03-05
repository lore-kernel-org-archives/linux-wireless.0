Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A5AC3F2D8
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 17:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25B0020848
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583428610;
	bh=CEZE2M2M19p/tI/qitCnZMFSK+sh5USz35jRAEJmX4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nvi91VTN77b7BIQD4BaIx7ruPIE2DPjBd/2xrq3KAzUiC0v3V2vv5/ZRYYE4QKZrD
	 vkdmUY1xC9uyFauJvG30mHaSUuhbd8eNBOCgorBUfxPVR4Xq2cqNsshqT6YMreav+f
	 +YAd0y6Wk4rvb8WA0mG284pSQwJmAxfhUC/XDm9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgCERQM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgCERQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 12:16:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0593B21556;
        Thu,  5 Mar 2020 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428570;
        bh=CEZE2M2M19p/tI/qitCnZMFSK+sh5USz35jRAEJmX4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnfKHpd2xcOs2rkVtjpn0P1UlX0mSjn35GG7GVx7yqdluY3gDdLU8CZkUG8vIGPXJ
         ZBJNDsk3USQHKUrzfpks+7Azs2KQOqM1FNC9zIcKcqmD0d6vS++mfmdTUoBR+joh2B
         A8AY85z+CyOO969F9Ruj86QOq7/T0ksT7zcuwM4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/12] mac80211: rx: avoid RCU list traversal under mutex
Date:   Thu,  5 Mar 2020 12:15:56 -0500
Message-Id: <20200305171559.30422-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171559.30422-1-sashal@kernel.org>
References: <20200305171559.30422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 253216ffb2a002a682c6f68bd3adff5b98b71de8 ]

local->sta_mtx is held in __ieee80211_check_fast_rx_iface().
No need to use list_for_each_entry_rcu() as it also requires
a cond argument to avoid false lockdep warnings when not used in
RCU read-side section (with CONFIG_PROVE_RCU_LIST).
Therefore use list_for_each_entry();

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200223143302.15390-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 74652eb2f90fd..a6f265262f151 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3841,7 +3841,7 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.20.1

