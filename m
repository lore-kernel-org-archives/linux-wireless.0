Return-Path: <SRS0=87w+=7P=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684A0C433E0
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jun 2020 03:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44EB0206F1
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Jun 2020 03:20:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="MojXSq4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgFBDU3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Jun 2020 23:20:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:60444 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgFBDU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Jun 2020 23:20:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591068028; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=sSkWnPbOtKeW7AsHL3ZW2nfA0Xlfu7mGoP+cmyM+db4=; b=MojXSq4d18oeJAF8TdZBgs1NkMkoQLcDw339MSYyridhaV8j30Ah0VgkWizPyfW2Bp4/7dog
 DScI0UWyJvuHe0ADTSQj6GPOe6mCp/m9l3iQ+35KWKji5h3mSIKW+suUo7Ykzl9VyJmV107m
 BO5Aw2wdHr4ediqNlCRxGucbZoo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ed5c5683131442d95e0d5c4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 02 Jun 2020 03:20:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 70AC1C433C9; Tue,  2 Jun 2020 03:20:07 +0000 (UTC)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D12C7C433C6;
        Tue,  2 Jun 2020 03:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D12C7C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH 0/2] Unsolicited bcast probe resp support
Date:   Mon,  1 Jun 2020 20:19:59 -0700
Message-Id: <20200602032001.21142-1-alokad@codeaurora.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for unsolicited broadcast probe response
for in-band discovery in 6GHz. Packet interval range is 0 -20 TUs.

Aloka Dixit (2):
  nl80211: Unsolicited bcast probe resp support
  mac80211: 20TU unsolicited bcast probe resp support

 include/net/cfg80211.h       | 21 +++++++++++++++
 include/net/mac80211.h       | 21 +++++++++++++++
 include/uapi/linux/nl80211.h | 32 ++++++++++++++++++++++
 net/mac80211/cfg.c           | 44 ++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |  7 +++++
 net/mac80211/tx.c            | 26 ++++++++++++++++++
 net/wireless/nl80211.c       | 52 ++++++++++++++++++++++++++++++++++++
 7 files changed, 203 insertions(+)

-- 
2.25.0

