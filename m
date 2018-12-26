Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4B9C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4657F20879
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545864136;
	bh=JhODPtP1aq2gH9t0gZ9/NZiNxH6fHV0Q/CfS1KlKPpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jGbuha+5RPMRV4rJU5OcOHW1w+phEiZersb53zqmTQD3eCN9L5zBDr4yxNapFtlAI
	 YS7eg4/dvwRFd1hY/58+B9Gw4GfLxCiJArNlSdJAO8J/Gr9qzbGZwf1Oicfs8tk3HX
	 OfvcQezEqUtrsIGYSr9EiSqGmUn8yLv+aqVqCv/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbeLZWlb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 17:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbeLZWla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 17:41:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851082054F;
        Wed, 26 Dec 2018 22:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545864089;
        bh=JhODPtP1aq2gH9t0gZ9/NZiNxH6fHV0Q/CfS1KlKPpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x19iulmlHEo7YtWIWZ1RSyNO+lpdiEQIVX7USaVS0LPKdBqglcUEJdIrqrzo/kw19
         T/P9KwhkpmxglLXsUFq4kusNbX8esKbp12N+U7RNQQHRL4JetxQCAzrs8KtFyyp1V+
         gxt6Wc5Hp7qwM5+lqeQT3ruqGT1wWftM8nyGMdnI=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 51/59] mac80211: free skb fraglist before freeing the skb
Date:   Wed, 26 Dec 2018 17:38:31 -0500
Message-Id: <20181226223839.150262-51-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181226223839.150262-1-sashal@kernel.org>
References: <20181226223839.150262-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 34b1e0e9efe101822e83cc62d22443ed3867ae7a ]

mac80211 uses the frag list to build AMSDU. When freeing
the skb, it may not be really freed, since someone is still
holding a reference to it.
In that case, when TCP skb is being retransmitted, the
pointer to the frag list is being reused, while the data
in there is no longer valid.
Since we will never get frag list from the network stack,
as mac80211 doesn't advertise the capability, we can safely
free and nullify it before releasing the SKB.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/status.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 35912270087c..b18466cf466c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -545,6 +545,11 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	}
 
 	ieee80211_led_tx(local);
+
+	if (skb_has_frag_list(skb)) {
+		kfree_skb_list(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
 }
 
 /*
-- 
2.19.1

