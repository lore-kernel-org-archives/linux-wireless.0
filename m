Return-Path: <SRS0=l8aR=WZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42F1C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 10:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B2A23403
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567075965;
	bh=gSJhoSXLpg8F7vuSlsW3fB97IwJDgWsUSWkH/xxXhyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=urL45A5wGa9cr91RSy8/I+Uhcw8Woq1EwCBoXnXS6IdLslxob5hjiRai6B056ljER
	 NC7z+NB1ByeOpsyscqqZ5K4xxWP/VoCfAIJIcJaysECyi2WK+Mxg0YRt/ttbd+aALT
	 omSpJPrz5H4X+gKK9krT3UVqwpuflAzOD+8jTGSU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfH2Kwk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Aug 2019 06:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbfH2KvI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 573E02341B;
        Thu, 29 Aug 2019 10:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075867;
        bh=gSJhoSXLpg8F7vuSlsW3fB97IwJDgWsUSWkH/xxXhyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f342f0PY1Lrp6/ph/K0g2irwEA+2XouY84MDGLkZhkAxC7LzLzHiVvB2SPyb8H6c+
         imuJki/K650L/KVLAnEpH5yQ8orxbcJgcdrAyNYfhJPiPM/sxW5WvsY+OM1pixFQ4s
         EGrbS67npiOzsbX3b93d66aq89yTsBzTgXbY3RhU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/8] mac80211: fix possible sta leak
Date:   Thu, 29 Aug 2019 06:50:57 -0400
Message-Id: <20190829105100.2649-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105100.2649-1-sashal@kernel.org>
References: <20190829105100.2649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5fd2f91ad483baffdbe798f8a08f1b41442d1e24 ]

If TDLS station addition is rejected, the sta memory is leaked.
Avoid this by moving the check before the allocation.

Cc: stable@vger.kernel.org
Fixes: 7ed5285396c2 ("mac80211: don't initiate TDLS connection if station is not associated to AP")
Link: https://lore.kernel.org/r/20190801073033.7892-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 954315e1661df..3b2c4692d966f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1418,6 +1418,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -1425,10 +1430,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
-	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);
-- 
2.20.1

