Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F1FC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A2A020883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 23:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WC769HJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391447AbfAOXdJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:33:09 -0500
Received: from mail-qt1-f201.google.com ([209.85.160.201]:35151 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOXdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 18:33:08 -0500
Received: by mail-qt1-f201.google.com with SMTP id p24so4061220qtl.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 15:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xDZucaWf638JH/a6TLBLLXD9xduch2eacsa8aHLD1I8=;
        b=WC769HJyZSoneJyc4JYUS/shRXIESiUGIOSqjsTZbHalaSgxMDGLqErWtwgvc43aKq
         oiJHNjkmV4v3nEyo0+8cCrJDIxeWtpyi50H4WkLxjalEBEKMRIt9wUk6Xq/H5DXtQuQZ
         amRX8T4bEQtJvMNIrWFibvTQdJWuvsnwfoSdyuGS+hzisRfkX+61b0a26ifkSepviBmw
         p8jgpzjluWvO2EIMOVahoIvHNV1npYyt2lrs0nUbhbwrSC9RgJaNlbcsJEoLF1m8CnOT
         J/AK0+KcLhTvtzVGtj8n8+bQCTg3Ec4LmcF2YWrU2NUkJwspQCw0qafSqkR4z2n5y5O+
         Njrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xDZucaWf638JH/a6TLBLLXD9xduch2eacsa8aHLD1I8=;
        b=efpOklHkg/bLBPYHRZtnvUjEq36T5quGWAp8VSKDYGJ3txpCRVo5aJZqvbYyHrigCF
         TjQnImTzHQdwU/th8Rq19G0atWk0MrpOPythJEnlGcYUyFEe6C/7lsoRtNQ2MTy0QTIt
         YX4lq8Z4xxET2sHdNqVVFoqkFrSMrmNq3PbXimODS+llSi1lJfBi91pgYHqzRCZCII7A
         zYITr6jhe1KDZaNDM1AV93QpoyK9nTMnSp69HOUqsLM03dkHil68lQz9fg2cbfz/evKg
         m5nI8Dmjhdk1dG7XjyJ3SNOiFbd+zIb29+3nFr8LX1nRT05PxdjvXneJNtxwlR2niKe8
         Qu+g==
X-Gm-Message-State: AJcUukcniSY7Vtw60A0ffcTTnwaz76eKZBgdi2J8Y/3QyOXl0AYk+qgd
        8CS0jEiBTW4x0M+zVMrBAFQ7e+bfgDdakA==
X-Google-Smtp-Source: ALg8bN55sWOm+0RHyri8jhbiXVJsAVXXin+X2xqfb6HpN5J3oPcRGiyknjg5ZGyEiaWEr2Z6g9Yf1ABVYUZVYg==
X-Received: by 2002:a0c:94b8:: with SMTP id j53mr3568599qvj.56.1547595187737;
 Tue, 15 Jan 2019 15:33:07 -0800 (PST)
Date:   Tue, 15 Jan 2019 15:33:03 -0800
Message-Id: <20190115233303.226908-1-julanhsu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.20.1.97.g81188d93c3-goog
Subject: [PATCH] mac80211: mesh: only switch path when new metric is at least
 10% better
From:   julanhsu@google.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Julan Hsu <julanhsu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Julan Hsu <julanhsu@google.com>

This helps to reduce frequent path switches when multiple path
candidates have the same or very similar path metrics.

Signed-off-by: Julan Hsu <julanhsu@google.com>
---
 net/mac80211/mesh_hwmp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 6950cd0bf594..9ce75ef3e249 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -441,7 +441,10 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			    (mpath->flags & MESH_PATH_SN_VALID)) {
 				if (SN_GT(mpath->sn, orig_sn) ||
 				    (mpath->sn == orig_sn &&
-				     new_metric >= mpath->metric)) {
+				     (rcu_access_pointer(mpath->next_hop) !=
+						      sta ?
+					      mult_frac(new_metric, 10, 9) :
+					      new_metric) >= mpath->metric)) {
 					process = false;
 					fresh_info = false;
 				}
@@ -506,8 +509,10 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if ((mpath->flags & MESH_PATH_FIXED) ||
-				((mpath->flags & MESH_PATH_ACTIVE) &&
-					(last_hop_metric > mpath->metric)))
+			    ((mpath->flags & MESH_PATH_ACTIVE) &&
+			     ((rcu_access_pointer(mpath->next_hop) != sta ?
+				       mult_frac(last_hop_metric, 10, 9) :
+				       last_hop_metric) > mpath->metric)))
 				fresh_info = false;
 		} else {
 			mpath = mesh_path_add(sdata, ta);
-- 
2.20.1.97.g81188d93c3-goog

