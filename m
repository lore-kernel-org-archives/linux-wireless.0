Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9E8C5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4914C2098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mXncuHN+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mXncuHN+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4914C2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbeJQCeh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCeh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 926B261307; Tue, 16 Oct 2018 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715371;
        bh=NpCic/qNg8tTgXTuA/PgbLuALohIxY22N8gRUenRdDw=;
        h=From:To:Cc:Subject:Date:From;
        b=mXncuHN+2HENRuTVFkXa1ovrqOioWrIb+vtlV6XlP8yF1KCkwjUpvZOp0xbTbsjFY
         dXp8hdN2RPNXPyLqXLFG6Itt9Q7ynZfgpQeLVymrPzfKiirWYYSnkDHD0KiZqH30K9
         MJzQEfInos9H+rfTrnf6hKdHulC1dwFb266Ay/Ug=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 107DD6021C;
        Tue, 16 Oct 2018 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715371;
        bh=NpCic/qNg8tTgXTuA/PgbLuALohIxY22N8gRUenRdDw=;
        h=From:To:Cc:Subject:Date:From;
        b=mXncuHN+2HENRuTVFkXa1ovrqOioWrIb+vtlV6XlP8yF1KCkwjUpvZOp0xbTbsjFY
         dXp8hdN2RPNXPyLqXLFG6Itt9Q7ynZfgpQeLVymrPzfKiirWYYSnkDHD0KiZqH30K9
         MJzQEfInos9H+rfTrnf6hKdHulC1dwFb266Ay/Ug=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 107DD6021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/6] wireless: Per-sta NoAck and offload support
Date:   Wed, 17 Oct 2018 00:11:05 +0530
Message-Id: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adds infrastructure for driver to offload NoAck functionality,
driver like ath10k could make use of it. Also extends the
current ndev wide NoAck policy to per-station, with sta level
NoAck policy configuration userspace could selectively turn off/on
Noack based on various connection parameters of the station.

Tamizh chelvam (2):
  ath10k: Add wmi command support for station specific TID config
  ath10k: Add support for station specific noack TID policy

Vasanthakumar Thiagarajan (4):
  mac80211: Add NoAck policy functionality offload infrastructure
  nl80211/mac80211: Extend NoAck policy command with peer MAC address
  mac80211: Apply per-peer NoAck tid bitmap configuration
  mac80211: Advertise per-peer NoAck policy support

 include/net/cfg80211.h       |   12 +++++++++--
 include/net/mac80211.h       |   13 ++++++++++++
 include/uapi/linux/nl80211.h |   16 +++++++++++++-
 net/mac80211/cfg.c           |   48 ++++++++++++++++++++++++++++++++++++++----
 net/mac80211/driver-ops.h    |   22 +++++++++++++++++++
 net/mac80211/ieee80211_i.h   |    2 +-
 net/mac80211/iface.c         |    4 ++++
 net/mac80211/main.c          |    4 ++++
 net/mac80211/sta_info.c      |    2 ++
 net/mac80211/sta_info.h      |    3 +++
 net/mac80211/trace.h         |   25 ++++++++++++++++++++++
 net/mac80211/tx.c            |    4 +++-
 net/mac80211/wme.c           |   35 +++++++++++++++++++++++++++++-
 net/wireless/nl80211.c       |   22 ++++++++++++++-----
 net/wireless/rdev-ops.h      |    7 +++---
 net/wireless/trace.h         |   15 +++++++------
 16 files changed, 210 insertions(+), 24 deletions(-)

-- 
1.7.9.5

