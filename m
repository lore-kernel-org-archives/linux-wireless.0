Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F900C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F415920663
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YVfMrhVi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HCWnPlA5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F415920663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbeJWCPt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:15:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbeJWCPt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 22:15:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EFFFA60C48; Mon, 22 Oct 2018 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230978;
        bh=BGe1veOJBXBXnexvDisE5gZeXmcTeuyqwGUcGatVxoc=;
        h=From:To:Cc:Subject:Date:From;
        b=YVfMrhVip51yajmca8/tS4oSpUSLBdkOeB86WxzNOwu3v6HXuuKzhJu2E3SUyw2Vr
         h0qBIfTg2uR8iEVfwHGowcO9zRxz8P0UqvFPOD0GebRpSoj9yBPArS5c2FmxvHD/Gi
         Lc4VB5ifnKvHMuBRb9p8quD4N+l8KHGoM6x8jtyA=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 330A06085C;
        Mon, 22 Oct 2018 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230977;
        bh=BGe1veOJBXBXnexvDisE5gZeXmcTeuyqwGUcGatVxoc=;
        h=From:To:Cc:Subject:Date:From;
        b=HCWnPlA5I2KWd061VVwbQZftI6r6lbNvIiFlyR7O74qgL+E1ncNMVsgSaWpgdHATJ
         ePT6bbSlJo4Tq7fgcsoi32SthmxcHN8zusaCltKnMT74Ld9dFWGNR7B48y1YwheRhY
         gLKrB/7y51WO/A3Ax823E5Za/aF0IfryuP/XMBGE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 330A06085C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific configuration
Date:   Mon, 22 Oct 2018 23:25:14 +0530
Message-Id: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add infrastructure for per TID aggregation/retry count configurations
such as retry count and AMPDU aggregation control(disable/enable).
In some scenario reducing the number of retry count for a specific data
traffic can reduce the latency by proceeding with the next packet
instead of retrying the same packet more time. This will be useful
where the next packet can resume the operation without an issue.
Here added NL80211_CMD_SET_TID_CONFIG to support this operation by
accepting retry count and AMPDU aggregation control.
This command can accept STA mac addreess to make the configuration
station specific rather than applying to all the connected stations
to the netdev.

Tamizh chelvam (3):
  nl80211: Add netlink attribute for AMPDU aggregation enable/disable
  tid conf 3
  ath10k: Add support to configure TID specific configuration

Vasanthakumar Thiagarajan (1):
  New netlink command for TID specific configuration

Note:
 * This patchset rebased on top of [PATCH 0/6] wireless: Per-sta NoAck and offload support

 drivers/net/wireless/ath/ath10k/core.h |  23 ++++
 drivers/net/wireless/ath/ath10k/mac.c  | 240 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.c  |   6 +-
 drivers/net/wireless/ath/ath10k/wmi.h  |   1 +
 include/net/cfg80211.h                 |  20 +++
 include/net/mac80211.h                 |  36 +++++
 include/uapi/linux/nl80211.h           |  90 +++++++++++++
 net/mac80211/cfg.c                     |  71 ++++++++++
 net/mac80211/driver-ops.h              |  16 +++
 net/mac80211/trace.h                   |  34 +++++
 net/wireless/nl80211.c                 | 103 ++++++++++++++
 net/wireless/rdev-ops.h                |  30 +++++
 net/wireless/trace.h                   |  50 +++++++
 13 files changed, 695 insertions(+), 25 deletions(-)

-- 
1.9.1

