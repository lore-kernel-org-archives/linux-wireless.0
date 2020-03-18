Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B216C4332E
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD62920409
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565537;
	bh=CamO4UEFcXfw9TeICbbmIbQ1M6RNs/sXyPRb67bcy08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SMumJHoy6d8/ZMk6qvk6xn32CwjqNr7avgOYMmmMBh3VZTJfZ9XfeYp36eVkFcICC
	 D2GpOUqbjIBwcZ2XStX00cVH3vciwomkqkxVVAbkiVxRhV8L3/wKxQAN2agka9Y8IK
	 /8XlQpGcEIbsMSKyydEH9LVEtIwCfanEHzEYq5NE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgCRUyw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgCRUyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FA8208FE;
        Wed, 18 Mar 2020 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564890;
        bh=CamO4UEFcXfw9TeICbbmIbQ1M6RNs/sXyPRb67bcy08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o98BJprnaqdBUbYrQNnJwLrv31nGzhXMZM7hJbWV2ULbpGOpk7YN4NCv7HnI2r7N2
         zGwCN5XX9Wsw/qFtQngdLE2u5C2MxPjJANf4cv2BH00qxDTmg4MReFYn5jiqYMHoiy
         SoJ7gMv1Ls0HLMEeLhCAmuYtV3Y6gjXFtU1NSZFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 59/73] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Wed, 18 Mar 2020 16:53:23 -0400
Message-Id: <20200318205337.16279-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit ba32679cac50c38fdf488296f96b1f3175532b8e ]

When trying to transmit to an unknown destination, the mesh code would
unconditionally transmit a HWMP PREQ even if HWMP is not the current
path selection algorithm.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://lore.kernel.org/r/20200305140409.12204-1-cavallar@lri.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d699833703819..38a0383dfbcfa 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1152,7 +1152,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1

