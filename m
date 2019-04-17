Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D26C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35A142173C
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MYn0NVnW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MYn0NVnW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbfDQJWI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:22:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfDQJWH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:22:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ED6C3613A6; Wed, 17 Apr 2019 09:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555492926;
        bh=9W5NYYPY1AS3aNyp/dw3tQEPsvHTkh5PZGRKFOwfpuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MYn0NVnWKWThGyuVCpKOircnYhN+im4QrLJDNyMMwNnPjq5hTqVMd81mybzQoRaaK
         OX/k++eciy2jI9g/S2WUedzOxPAVI+7bi0V9nNHP2B5kaE9bFdBnUu95butbxc6WAo
         UyX2RVjOI3pVU3X7gNofFTiF6Ao0RcRMAo4XQeZ8=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4269061382;
        Wed, 17 Apr 2019 09:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555492926;
        bh=9W5NYYPY1AS3aNyp/dw3tQEPsvHTkh5PZGRKFOwfpuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MYn0NVnWKWThGyuVCpKOircnYhN+im4QrLJDNyMMwNnPjq5hTqVMd81mybzQoRaaK
         OX/k++eciy2jI9g/S2WUedzOxPAVI+7bi0V9nNHP2B5kaE9bFdBnUu95butbxc6WAo
         UyX2RVjOI3pVU3X7gNofFTiF6Ao0RcRMAo4XQeZ8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4269061382
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 0/2] cfg80211/mac80211: Add support to configure and monitor station's rssi threshold
Date:   Wed, 17 Apr 2019 14:51:18 +0530
Message-Id: <1555492880-26457-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
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

v4:
 * Fixed sparse warning

v3:
 * Address Johannes comments

v2:
 * Combined patchset 2 and 3 as single patch and addressed Johannes comments.

 include/net/cfg80211.h       |   39 +++++++++
 include/net/mac80211.h       |    7 ++
 include/uapi/linux/nl80211.h |   21 +++++
 net/mac80211/cfg.c           |  108 +++++++++++++++++++++++++
 net/mac80211/rx.c            |   56 ++++++++++++-
 net/mac80211/sta_info.c      |    1 +
 net/mac80211/sta_info.h      |   31 ++++++++
 net/wireless/nl80211.c       |  179 ++++++++++++++++++++++++++++++++++++------
 net/wireless/rdev-ops.h      |   13 +++
 net/wireless/trace.h         |   21 +++++
 10 files changed, 449 insertions(+), 27 deletions(-)

-- 
1.7.9.5

