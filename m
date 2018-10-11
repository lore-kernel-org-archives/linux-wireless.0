Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9A8C4161D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D73A2064A
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 12:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KiGpBCPX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KiGpBCPX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D73A2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbeJKUIz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:08:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJKUIy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 16:08:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 59C0F602D7; Thu, 11 Oct 2018 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539261712;
        bh=bedbhoXQNZW7+MjDblF4RAxHASoa3LHWNvs41s3qtLM=;
        h=From:To:Cc:Subject:Date:From;
        b=KiGpBCPX9qlE49qZD+1BE0HvqzE+VCjm95XydTmXuBO5cZuqxFXaZKKe2byDSZE+m
         vq0hXrRIuNjFz5KqH9Fq970lQPeqNezdB/nEW8dOWJu3xuuavGArbQXnWhekut6iuv
         eH7P+YfmTHg5Sy7K6fso4evxqc8yDArMalKYyReI=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47FF66072E;
        Thu, 11 Oct 2018 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539261712;
        bh=bedbhoXQNZW7+MjDblF4RAxHASoa3LHWNvs41s3qtLM=;
        h=From:To:Cc:Subject:Date:From;
        b=KiGpBCPX9qlE49qZD+1BE0HvqzE+VCjm95XydTmXuBO5cZuqxFXaZKKe2byDSZE+m
         vq0hXrRIuNjFz5KqH9Fq970lQPeqNezdB/nEW8dOWJu3xuuavGArbQXnWhekut6iuv
         eH7P+YfmTHg5Sy7K6fso4evxqc8yDArMalKYyReI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47FF66072E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 0/2] ath10k: Add support to update tx rate to mac80211
Date:   Thu, 11 Oct 2018 18:15:02 +0530
Message-Id: <1539261904-9016-1-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tx rate was updated to nl80211/user using sta_statistics callback.
This rate can not be used for mac80211 mesh and ATF.

This patch adds support to update tx rate to mac80211

Anilkumar Kolli (2):
  mac80211: implement ieee80211_tx_rate_update to update rate
  ath10k: report tx rate using ieee80211_tx_rate_update()

 drivers/net/wireless/ath/ath10k/core.h   |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |   70 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h    |    1 +
 include/net/mac80211.h                   |   15 +++++++
 net/mac80211/status.c                    |   22 ++++++++++
 5 files changed, 103 insertions(+), 6 deletions(-)

-- 
1.7.9.5

