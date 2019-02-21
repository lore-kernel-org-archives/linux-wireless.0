Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F4FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 135BF20836
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 16:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gnQN3vY8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LTzJ0Xsx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfBUQWE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:22:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58882 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfBUQWD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 11:22:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00BDA6099A; Thu, 21 Feb 2019 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766123;
        bh=P4dyHeClAVGPnb3aKwMMt9yo09WD/o2w4PQb0KO9KLc=;
        h=From:To:Cc:Subject:Date:From;
        b=gnQN3vY8fRUUN/xhdoqwTIRjm2e2qxea2yhxMUPxn/94vJRLqfB7dfVQldtY96EmD
         qlQ5PyB81xZtVm/2SZ5SvvjSqGKRd5lVdS/0elHxWXNiVtmOGqMTAABjf6q5++nbgv
         Lxpx+YJOr6UWs4dr+4HcSQC+4IiwUSfnms0IE9NY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 306D360C04;
        Thu, 21 Feb 2019 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550766122;
        bh=P4dyHeClAVGPnb3aKwMMt9yo09WD/o2w4PQb0KO9KLc=;
        h=From:To:Cc:Subject:Date:From;
        b=LTzJ0XsxnKywPTCwK5oV44fZ7qUzHqtkLKdNvpWFeJ34bRyxildLkajojcNJyMW86
         /8qRycCur+rZJ4//gCG46aI/HHh2BlrAJN9Ej7qwCIRRW+SmkvVz8BCnZ2ZSIdptwv
         wnXAz1IKnH4RMao9LbBY4Mfqby25CHjMRqVXDuJc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 306D360C04
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] ath10k: small fixes for SDIO support
Date:   Thu, 21 Feb 2019 18:21:54 +0200
Message-Id: <1550766118-31703-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen has refactored some of the Alagu's fixes and wrote one of his own. I then
cleaned up the commit logs.

Alagu Sankar (3):
  ath10k: sdio: set hi_acs_flags
  ath10k: sdio: disable fwlog prints
  ath10k: don't report unset rssi values to mac80211

Wen Gong (1):
  ath10k: sdio: reset chip on power_down()

 drivers/net/wireless/ath/ath10k/core.c   | 19 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 +++++++++---
 drivers/net/wireless/ath/ath10k/sdio.c   | 24 ++++++++++++++++--------
 3 files changed, 41 insertions(+), 14 deletions(-)

-- 
2.7.4

