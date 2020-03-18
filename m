Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E80C4332B
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 20:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90CEB208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 20:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565185;
	bh=ZkfJrT9V50vG+aQGnn9VvvlNy5AIoNeX22Kv/9I1x5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VHAJkZlHUSphzLPrCC7MdEFieR6ri7355H9rm02E8zowtWkCwsCqo0RxuauFP7aXr
	 uBnGpYzRXMT9UY4r8jYZxcGZn3GaiKUHthaGKFGqyabPFi+9vnlzgZGX8qlZIbOVMg
	 3l/Ck+7RzPZBGETk5V/j02vWdjQsugk7AvP/uVsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgCRU4q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgCRU4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BBE720BED;
        Wed, 18 Mar 2020 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565004;
        bh=ZkfJrT9V50vG+aQGnn9VvvlNy5AIoNeX22Kv/9I1x5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWQg9bQuMRpLJRowAoJRwyvLzUJDF6i4L9vPu6fZ8aTUW5g4Ng5a5YIyZqzumUG1f
         IijVJC/BWeawYtx6tShvHtWOLzb/vr+DaPhoodDcvEt+GrsuYD5C0PhzcMo2IMUTKx
         OUvadABs7Y2YMkjJUbX3O2NN+YG4SuReb6BM8buc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/15] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Wed, 18 Mar 2020 16:56:26 -0400
Message-Id: <20200318205629.17750-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205629.17750-1-sashal@kernel.org>
References: <20200318205629.17750-1-sashal@kernel.org>
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
index 5f4c228b82e56..f7eaa1051b5b2 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1131,7 +1131,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1

