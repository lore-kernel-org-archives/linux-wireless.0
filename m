Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA872C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84165214D8
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545864470;
	bh=/0MO91npWNYvNOFgyDWGtZ0HncdS3CyrScxoEsQMtug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PhiHQIspRbJk9WrGYVkLyMjCOCf6KY5qLgoi1JR9iWTFkaiHi/jWKKjh6U+/Vcqe/
	 YDEi5oEMf0Qq/Ocpjr6ZjjouW9ZKcSy04e9uYUvDI1kBuyJQYXdlAxrDbEXUlP5Ybb
	 ZUeupBl7cCOzMg5qcg7i+LoIZ1kyCEk0Bc2Bjs7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbeLZWro (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 17:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbeLZWiO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 17:38:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFA6218E2;
        Wed, 26 Dec 2018 22:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545863893;
        bh=/0MO91npWNYvNOFgyDWGtZ0HncdS3CyrScxoEsQMtug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcVF8bsM8FeID+8gonzC77PfrwMXhdT/LiCOoP/erIvWnXCW5zcxU+xKZLO+AWHdZ
         jhAexcWw9P2qkQKSC8TFd/ExS0b1onv1VplEXUXu/t4tF1/UkIhCYsMsVMTNZjGX2C
         DiFAPNLGsukYTuM2MeycblS+BFOUuHRCSAP2GvIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 81/97] mac80211: free skb fraglist before freeing the skb
Date:   Wed, 26 Dec 2018 17:35:41 -0500
Message-Id: <20181226223557.149329-81-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
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
index 7fa10d06cc51..534a604b75c2 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -556,6 +556,11 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
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

