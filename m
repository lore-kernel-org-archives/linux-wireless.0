Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A289C33CB7
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9EB2077C
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579202226;
	bh=eq4V5fWRWUv3qEIk4JJVlBSpyfCfuRrIIjYJ1RW9xb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZKy4x3Sll2y+wk5oVcy/yrDmpqOMHIXJH6oX/ZB2KG7+AM3LEmSkojvH10OK7g/sv
	 2A5CmETR1MCMZLJ4QLIK10kg1ESUHjb4zWvnUGWHibLw++ENHATFKZfs3KAyIT6wLv
	 Y1ERaZ67vzLitwwFSXyDBdCzevBbKE4h/wOXwJe8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbgAPQze (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgAPQzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33152467C;
        Thu, 16 Jan 2020 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193731;
        bh=eq4V5fWRWUv3qEIk4JJVlBSpyfCfuRrIIjYJ1RW9xb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrqzuh17heWZLcRbrZSplidfpuKusQH8UV6gya78hxuY0H5LbyzTmPsSZjLYmE0FC
         zJGFcpfxXC91TQZ5YEPVvnFq5kN3j3eRdggS3NK7pYIRjs5ZmbQ9GtnIu5ZQL6QD/X
         yzQnu1SwVY9XeK4AWL2M7w5KfkY2E8WsCGSs+obQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 024/671] cfg80211: regulatory: make initialization more robust
Date:   Thu, 16 Jan 2020 11:44:15 -0500
Message-Id: <20200116165502.8838-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 71e5e886806ee3f8e0c44ed945eb2e4d6659c6e3 ]

Since my change to split out the regulatory init to occur later,
any issues during earlier cfg80211_init() or errors during the
platform device allocation would lead to crashes later. Make this
more robust by checking that the earlier initialization succeeded.

Fixes: d7be102f2945 ("cfg80211: initialize regulatory keys/database later")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 64841238df85..5643bdee7198 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3870,6 +3870,15 @@ static int __init regulatory_init_db(void)
 {
 	int err;
 
+	/*
+	 * It's possible that - due to other bugs/issues - cfg80211
+	 * never called regulatory_init() below, or that it failed;
+	 * in that case, don't try to do any further work here as
+	 * it's doomed to lead to crashes.
+	 */
+	if (IS_ERR_OR_NULL(reg_pdev))
+		return -EINVAL;
+
 	err = load_builtin_regdb_keys();
 	if (err)
 		return err;
-- 
2.20.1

