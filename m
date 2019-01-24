Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EB1C282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40412082C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dPyeg2EV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfAXSGM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:06:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51926 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbfAXSGL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:06:11 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so4184332wmj.1;
        Thu, 24 Jan 2019 10:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzySAr5RT4bnc+X0cIqdAC5wUwa0PpgnGMBYPkgYA/4=;
        b=dPyeg2EVQTinioQfR/mLB8s01tLSf+kTCNj+8NP7Xt8ebWj/QGwtjSEYpBwp1knC6e
         0xUiDhYlsRpxbGPoqxBV75Gx5UnrTOxiWvCrTWe0JtuvtBO92ksYqYUw3JyaUHGf5KPE
         ZXCoGQQStwygaTEqlJS0U4J+iSznzTjSoNcaEDNSbLhsabJgMFgjmOT6zsfFJQuvKYd1
         18laPsC0NTnbT6Kwlr/RY+06B7QBy9IB60ljzLm+guFWN4bsDrzt3ntmbLMDgRceZmNt
         i76Cw/4tpiVeEG/6B8gs5UzpaVjXkMN6UQa6SzUU42Z5iIqhL922DLmGUw8NTRuhl9C2
         +k3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=fzySAr5RT4bnc+X0cIqdAC5wUwa0PpgnGMBYPkgYA/4=;
        b=KK+JJXb6CzDi7KdR0iQ2TpNV3+4de9/0ObEQSGAaht0xis1CV+JbyYMCwvuC2tPLWG
         i5DiHtvtLb6B9a07SQEcSqYk0efcHg+ZftmSLsBINUSXe9q4KMNTLiWKTRZbQ57h3e88
         QwLlukV0l9e3ALHSLY2QNQMFx2CSX7scvqrnsrcYSW6vlrJ8KLPSKcnfPVjjpv+wNX8I
         H82B78qL/BiSlqLgMWU8SQmDqhpx9t2GWLHA64pf1Z2DVwDKLcYGZ6Hsm+ZfrDbDVW89
         n/W1AGkjMEEuWDxjqQbrjJXrlUMUKAB1kptjr6ZbGMQfXgXtHx8zwH1bMa8D4kqAA3HX
         1IPw==
X-Gm-Message-State: AJcUukf6YHTD+1P4EuIY6O/RAFLGU3Vu6pD4yIMAcCbeRM++BEZgHwvz
        ++1HwZTKk1K482zuPrtJLe8=
X-Google-Smtp-Source: ALg8bN77KcK4bSCuWNqKuz/e5P9VrDnsCT0Lu79tQgIkxqQH9Z6Y4v8kU/UQYdT9SvY8HsnbuLqWtg==
X-Received: by 2002:a1c:7706:: with SMTP id t6mr3500992wmi.57.1548353169107;
        Thu, 24 Jan 2019 10:06:09 -0800 (PST)
Received: from macbookpro.malat.net (bru31-1-78-225-224-134.fbx.proxad.net. [78.225.224.134])
        by smtp.gmail.com with ESMTPSA id f10sm25380660wmb.35.2019.01.24.10.06.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 10:06:08 -0800 (PST)
Received: by macbookpro.malat.net (Postfix, from userid 1000)
        id 277A71143573; Thu, 24 Jan 2019 19:06:07 +0100 (CET)
From:   Mathieu Malaterre <malat@debian.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Mathieu Malaterre <malat@debian.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: Remove attribute packed from struct 'action'
Date:   Thu, 24 Jan 2019 19:05:35 +0100
Message-Id: <20190124180535.20216-1-malat@debian.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During refactor in commit 9e478066eae4 ("mac80211: fix MU-MIMO
follow-MAC mode") a new struct 'action' was declared with packed
attribute as:

  struct {
          struct ieee80211_hdr_3addr hdr;
          u8 category;
          u8 action_code;
  } __packed action;

But since struct 'ieee80211_hdr_3addr' is declared with an aligned
keyword as:

  struct ieee80211_hdr {
  	__le16 frame_control;
  	__le16 duration_id;
  	u8 addr1[ETH_ALEN];
  	u8 addr2[ETH_ALEN];
  	u8 addr3[ETH_ALEN];
  	__le16 seq_ctrl;
  	u8 addr4[ETH_ALEN];
  } __packed __aligned(2);

Solve the ambiguity of placing aligned structure in a packed one by
removing the packed attribute from struct. This seems to be the behavior
of gcc anyway, since the following is still compiling:

  BUILD_BUG_ON(sizeof(action) != IEEE80211_MIN_ACTION_SIZE + 1);

This removes the following warning (W=1):

  net/mac80211/rx.c:234:2: warning: alignment 1 of 'struct <anonymous>' is less than 2 [-Wpacked-not-aligned]

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 45aad3d3108c..709359650149 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -231,7 +231,7 @@ static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_hdr_3addr hdr;
 		u8 category;
 		u8 action_code;
-	} __packed action;
+	} action;
 
 	if (!sdata)
 		return;
-- 
2.19.2

