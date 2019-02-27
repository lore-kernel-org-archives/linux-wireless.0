Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3226BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBA972147C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="deyGKZ4y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dAZkozjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfB0LWb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:22:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LWb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 06:22:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2573560A05; Wed, 27 Feb 2019 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266550;
        bh=y5MlngsRDW++83iJdBWo/y02hB00i/alRjC1Z0Zw7Wk=;
        h=From:To:Cc:Subject:Date:From;
        b=deyGKZ4y5qQOGvWAD8ECFhdZ2Q2SPEUylzdKSoZb2T0MceoTnDsvgIODeaX8rGtcM
         Cn+sFGIudCmgy5q9he0p+yBewJif3xnMTP48ZYWDHIWdfpQis8S6YU0BBBx9+ZO1UU
         t7htUbfm+aQ/wPj1/Fd0+OBd1TUfQg4N9qWgD930=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mkenna@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E97A960A05;
        Wed, 27 Feb 2019 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551266549;
        bh=y5MlngsRDW++83iJdBWo/y02hB00i/alRjC1Z0Zw7Wk=;
        h=From:To:Cc:Subject:Date:From;
        b=dAZkozjMiHmzN0NKS2wx7bIMtfoHyIokgwWOWgCAkFRleCmKofdwyg9t7r8DXcNtQ
         XOBHynIIwxAJYvWVVSA7Wi1gp7X59u0rPWZ+10f9komkyXbw5LRtVLQa0Lr/lknG/x
         1n8SysSGWDcRpnGcoEprMdgXTsvOGuZHTY6q9rMk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E97A960A05
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mkenna@codeaurora.org
From:   Maharaja Kennadyrajan <mkenna@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, vikpatel@codeaurora.org,
        arnagara@codeaurora.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH 0/2] Exdented HTT stats support and provide debugfs
Date:   Wed, 27 Feb 2019 16:53:41 +0530
Message-Id: <1551266621-31981-1-git-send-email-mkenna@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extended the bit mask value for the HTT stats (Mu-MIMO related)
which are retrieved via tracing.

Provided debugfs provision to reset the HTT stats which helps to
get the aggregated stats via tracing. Before that we could not get
the accumulated stats.

Maharaja Kennadyrajan (2):
  ath10k: Extended the HTT stats support to retrieve Mu-MIMO related
    stats
  ath10k: Added support to reset HTT stats in debugfs

 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/debug.c  | 47 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/htt.h    |  4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  9 +++--
 4 files changed, 53 insertions(+), 8 deletions(-)

-- 
2.20.1

