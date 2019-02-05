Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED1CC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 10:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DBBE20844
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 10:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R0mmQLn+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R0mmQLn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfBEKF0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 05:05:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbfBEKF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 05:05:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7169A60770; Tue,  5 Feb 2019 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549361125;
        bh=G/jmwxIpgSm65i0gPtfvvgCeI7I206m0CtZSBSIGVGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=R0mmQLn+9R8TUD1YIKIFR84c1qPUIWy9zaHBkNEGxntdT4ceZsF16l0gtEb4sNXTF
         lzGTts+Stpxn4dvFNb44f7kqANv2f4L0i6X1IcsPQ+c0PNPzXFbz4S4xU4dRxIfXVO
         IgljC1ewVHtKrpwV9iZpC3YKfuolOfA4rs0Bg0GE=
Received: from che-swdbs-01.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBF1F60734;
        Tue,  5 Feb 2019 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549361125;
        bh=G/jmwxIpgSm65i0gPtfvvgCeI7I206m0CtZSBSIGVGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=R0mmQLn+9R8TUD1YIKIFR84c1qPUIWy9zaHBkNEGxntdT4ceZsF16l0gtEb4sNXTF
         lzGTts+Stpxn4dvFNb44f7kqANv2f4L0i6X1IcsPQ+c0PNPzXFbz4S4xU4dRxIfXVO
         IgljC1ewVHtKrpwV9iZpC3YKfuolOfA4rs0Bg0GE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EBF1F60734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 0/2] cfg80211/mac80211: Add support to configure and monitor station's rssi threshold
Date:   Tue,  5 Feb 2019 15:36:19 +0530
Message-Id: <1549361181-6237-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchsets introduced new NL command and api to support
configuring rssi for the connected stations and api to notify
userspace application upon crossing the configured threshold.
This will be useful for the application which requires
station's current signal strength change information.
Monitoring station's signal strength through station dump command
will unnecessarily increase the system overhead. This event based
mechanism will reduce the system overhead and helps application to
take a decision for the station for which event received.

Tamizh chelvam (2):
  cfg80211: Add support to configure station specific RSSI threshold
    for AP mode
  mac80211: Implement API to configure station specific rssi threshold

v2:
 * Combined patchset 2 and 3 as single patch and addressed Johannes comments.

 include/net/cfg80211.h       |   39 ++++++++++
 include/net/mac80211.h       |    7 ++
 include/uapi/linux/nl80211.h |   21 ++++++
 net/mac80211/cfg.c           |  103 +++++++++++++++++++++++++
 net/mac80211/rx.c            |   56 +++++++++++++-
 net/mac80211/sta_info.c      |    1 +
 net/mac80211/sta_info.h      |   30 ++++++++
 net/wireless/nl80211.c       |  169 +++++++++++++++++++++++++++++++++++-------
 net/wireless/rdev-ops.h      |   13 ++++
 net/wireless/trace.h         |   22 ++++++
 10 files changed, 433 insertions(+), 28 deletions(-)

-- 
1.7.9.5

