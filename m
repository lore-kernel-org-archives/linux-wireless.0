Return-Path: <SRS0=5LI1=BA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85385C433E5
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 17:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EF1206E9
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 17:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KDjqZDsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgGUROt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:14:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14780 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbgGUROs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jul 2020 13:14:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351687; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=k+XAw9X2vHW5qNsF1IEl1DDQaBasaYhVfkIaTJygYog=; b=KDjqZDsEkkDW0aEt5fxxjhvy/mtOENTU/HfSxOOVNxrT3mRTjhFvqRUASMVm2dWjguEwP4f4
 cLebNj8rskmyTOuROPorDSP+VvU1t8QrDSxZ9oIpKoSoz85XpVfgpO2TcBBOwG4rFyV5gFSu
 6RZ57vBVI+vu3y6xml6Kyr6aePI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-west-2.postgun.com with SMTP id
 5f172287e32d449b31ed61e9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:14:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B7444C433A1; Tue, 21 Jul 2020 17:14:46 +0000 (UTC)
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 263A8C4339C;
        Tue, 21 Jul 2020 17:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 263A8C4339C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
Date:   Tue, 21 Jul 2020 22:44:20 +0530
Message-Id: <1595351666-28193-2-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The function ieee80211_rx_napi can be now called
from a thread context as well, with napi context
being NULL.

Hence add the napi context check before giving out
a warning for softirq count being 0.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a88ab6f..1e703f1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4652,7 +4652,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	WARN_ON_ONCE(softirq_count() == 0);
+	WARN_ON_ONCE(napi && softirq_count() == 0);
 
 	if (WARN_ON(status->band >= NUM_NL80211_BANDS))
 		goto drop;
-- 
2.7.4

