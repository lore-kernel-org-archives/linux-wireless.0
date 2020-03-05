Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C92C3F2D2
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 17:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7502D20637
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583429009;
	bh=idOIMTE6Zyt3F86aW3sP2PcOyQAZyqAKYQdsQE9Lt9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=prXeGjY8nQKJ3vcyidLbLrwYJVFpSYWpk8ou1O7YtBx6Ysm+g2xslD3j8F773bOQJ
	 fw3Og9tJqcb21amOdVzFmYXT7m0VUJmMYeGC9C3l1QFQ6oEyzwwqFDSxoBqnskkodV
	 kim/Z9jqIyh2+12i088Kyj0sm2uLJ5BmProiEe9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCERNn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbgCERNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE87A20870;
        Thu,  5 Mar 2020 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428422;
        bh=idOIMTE6Zyt3F86aW3sP2PcOyQAZyqAKYQdsQE9Lt9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8Tp3upoFmuRv1ugDhkgiZW2F8u/saKXPTQeJTfnVOOF7Vm6IVRMJhsUwJoc/XeP2
         E1xa9BaACFu65GHOvdN1/gmdgKZQMv6EFMbI3GDSPuN2lJRNYO/dyXQj3jhgIJtL9+
         UJSvW2PjD21U52otrJ0p37sfrEKIz2/dsY9Kg5Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 24/67] nl80211: fix potential leak in AP start
Date:   Thu,  5 Mar 2020 12:12:25 -0500
Message-Id: <20200305171309.29118-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9951ebfcdf2b97dbb28a5d930458424341e61aa2 ]

If nl80211_parse_he_obss_pd() fails, we leak the previously
allocated ACL memory. Free it in this case.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200221104142.835aba4cdd14.I1923b55ba9989c57e13978f91f40bfdc45e60cbd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1e97ac5435b23..6032f1cce9416 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4799,8 +4799,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		err = nl80211_parse_he_obss_pd(
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
-		if (err)
-			return err;
+		goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);
@@ -4822,6 +4821,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 	wdev_unlock(wdev);
 
+out:
 	kfree(params.acl);
 
 	return err;
-- 
2.20.1

