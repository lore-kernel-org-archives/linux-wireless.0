Return-Path: <SRS0=580q=BW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D4AC433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 01:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8319020678
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 01:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="hEKNEDSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:22:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13396 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Aug 2020 21:22:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597195362; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=duElXiBKZpbcBhNpytoBELe8G6CHrWT5/BDhqdJVYQI=; b=hEKNEDSoQJxwlFTUdthMsc7T1how/aQ9ZzJgl5oBWljAZf9MaQDUPLWlgdIVLvrKz4SICPJV
 fEFbH5NUsTrWvUj4ZHbMTjS30YMqiCkOMAsbmzDyCQs7bDO3HuTnVzJi3G5mtm5HisLIQ9No
 IrdopUaIxWaHJd5dhkoXQ4iy8A8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-east-1.postgun.com with SMTP id
 5f33445ccbcd42bdee034c8f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 12 Aug 2020 01:22:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24408C433CB; Wed, 12 Aug 2020 01:22:35 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F818C433C9;
        Wed, 12 Aug 2020 01:22:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F818C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH v4 0/2] Unsolicited broadcast probe resp support
Date:   Tue, 11 Aug 2020 18:22:24 -0700
Message-Id: <20200812012226.11347-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unsolicited broadcast probe response tranmission is used for in-band
discovery in 6GHz band (IEEE P802.11ax/D6.0 26.17.2.3.2, AP behavior for
fast passive scanning).

v4: Addressed comments.

v3: Rebased. Removed check for 6Ghz, drivers should add that check.

v2: Removed flag 'enabled' and changed 6GHz frequency range as per
    IEEE P802.11ax/D6.1.

Aloka Dixit (2):
  nl80211: Unsolicited broadcast probe response support
  mac80211: Unsolicited broadcast probe response support

 include/net/cfg80211.h       | 23 +++++++++++++++
 include/net/mac80211.h       | 24 +++++++++++++++
 include/uapi/linux/nl80211.h | 32 ++++++++++++++++++++
 net/mac80211/cfg.c           | 57 ++++++++++++++++++++++++++++++++----
 net/mac80211/debugfs.c       |  1 +
 net/mac80211/ieee80211_i.h   |  7 +++++
 net/mac80211/main.c          |  6 ++++
 net/mac80211/tx.c            | 29 ++++++++++++++++++
 net/wireless/nl80211.c       | 41 ++++++++++++++++++++++++++
 9 files changed, 214 insertions(+), 6 deletions(-)

-- 
2.25.0

