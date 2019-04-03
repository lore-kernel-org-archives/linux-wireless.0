Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6195C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A360420882
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 19:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RpnABW9n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RpnABW9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDCTOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 15:14:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfDCTOv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 15:14:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DF61760C72; Wed,  3 Apr 2019 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554318890;
        bh=hwc/VgIgt7FPpAu/bqVDY/ps7DpRquLbBSsRru4IreA=;
        h=From:To:Cc:Subject:Date:From;
        b=RpnABW9nT9PvXqE4Ga+zecWj3dmbD4+/4GuAW/i4eo8AZajyYUP0qhyQUS1cz1Onn
         BWnq+7qu7n0iwqvMgLtW0ABUymHnFimjnYntVw9mP+rdT4ngGZ5mPNTXHoSbzzSY4H
         jZCVPbIOEVQ78tne0ksu7UWAvO9ZReNdXyzzGeOk=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5AE8A60907;
        Wed,  3 Apr 2019 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554318890;
        bh=hwc/VgIgt7FPpAu/bqVDY/ps7DpRquLbBSsRru4IreA=;
        h=From:To:Cc:Subject:Date:From;
        b=RpnABW9nT9PvXqE4Ga+zecWj3dmbD4+/4GuAW/i4eo8AZajyYUP0qhyQUS1cz1Onn
         BWnq+7qu7n0iwqvMgLtW0ABUymHnFimjnYntVw9mP+rdT4ngGZ5mPNTXHoSbzzSY4H
         jZCVPbIOEVQ78tne0ksu7UWAvO9ZReNdXyzzGeOk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5AE8A60907
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Wed, 03 Apr 2019 12:14:48 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v3 0/3] wireless: Add support to probe unexercised mesh link
Date:   Wed,  3 Apr 2019 12:14:41 -0700
Message-Id: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Consider below mesh topology.

        MP1
       /    \
      /      \
     MP2 --- MP3

Assume that even though MP1 & MP3 have direct mesh links, the path was
established via MP2. (MP1 <-> MP2 <-> MP3). The 1-hop mesh link MP1 <-> MP3
never be excercised till the current path is terminated. As of now, there
is no option to send data frame to pick other than primary path. So mesh
link metric between MP1 & MP3 never be updated. This series allows user
to send data to 1-hop mesh peers through unexercised mesh path.

-Rajkumar

v3: Rebased the changes on TOT
 
Rajkumar Manoharan (3):
  cfg80211: add support to probe unexercised mesh link
  mac80211: add option for setting control flags
  mac80211: probe unexercised mesh links

 include/net/cfg80211.h       |  6 +++++
 include/net/mac80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 16 +++++++++++++
 net/mac80211/cfg.c           |  1 +
 net/mac80211/ieee80211_i.h   |  5 +++-
 net/mac80211/mesh_hwmp.c     |  4 ++++
 net/mac80211/tdls.c          |  2 +-
 net/mac80211/tx.c            | 54 ++++++++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 +++++++++++
 net/wireless/trace.h         | 19 ++++++++++++++++
 11 files changed, 167 insertions(+), 9 deletions(-)

-- 
1.9.1

