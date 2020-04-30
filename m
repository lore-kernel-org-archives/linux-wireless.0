Return-Path: <SRS0=B82j=6O=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862F6C28CBC
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 14:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AD162063A
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Apr 2020 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588255749;
	bh=zI9U96ifGGqZbsvmYhIvux+kaVFx/2j17snz9G3CqCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rPqraux26t+rGrs6CFe7KMvGIORykyV3f2f/B2Zz2sg+1g8WvRRaZR7N2ZYQd9TNb
	 8Bx2kDC65ZMRNCsh18zW/LumwLxMOMdNvcuaWq9Kz6at7vQ/7THoXb7GrYOBIJd1GA
	 Gqdo11enWr9Geh1Eh1gduUFlgU7ADZqWdO8egF2Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgD3OI6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgD3NwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395C221775;
        Thu, 30 Apr 2020 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254722;
        bh=zI9U96ifGGqZbsvmYhIvux+kaVFx/2j17snz9G3CqCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+FUOpJmh/RgylIPDES5vJ7Rx+CTLWk5FfnVgQrSrLujmP66MOF0js2mPUQVVb0bc
         vvRnPL9q/Dem0WGF9gyTXLW6TKuxKyYrCvNPN4CgtRVWIgtCDt60G/UmnKw6/YOdS6
         CJ0tpxpzo9PLwPl1VqhY+R8hHKEgKspx1zrs9mk4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 69/79] mac80211: sta_info: Add lockdep condition for RCU list usage
Date:   Thu, 30 Apr 2020 09:50:33 -0400
Message-Id: <20200430135043.19851-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 8ca47eb9f9e4e10e7e7fa695731a88941732c38d ]

The function sta_info_get_by_idx() uses RCU list primitive.
It is called with  local->sta_mtx held from mac80211/cfg.c.
Add lockdep expression to avoid any false positive RCU list warnings.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200409082906.27427-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e3572be307d6c..149ed0510778d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -231,7 +231,8 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int i = 0;
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list,
+				lockdep_is_held(&local->sta_mtx)) {
 		if (sdata != sta->sdata)
 			continue;
 		if (i < idx) {
-- 
2.20.1

