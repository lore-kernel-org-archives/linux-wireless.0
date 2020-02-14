Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EF5C2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 09:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 360932086A
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 09:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LRRqaaA3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgBNJOg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 04:14:36 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:49290 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728422AbgBNJOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 04:14:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581671675; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=AsDt1N/J1En5U8PS2kP07ps4Z84XLY3P+4N/lQq6UF8=; b=LRRqaaA30TTBPJeWigYwafuEl7MugZYHZJV0f7i/CF5X25DKA/J9K9YiFXNjYcLwKTd0Sva6
 YwADjxIGSVGnuIZ54oXhmhFKzMKwYAeqNx8wN6SDSC4gT9cj7os3q8UejdjQoAu1McD2Y8hk
 +kl21bR0ovflNREr638qkXe6sdk=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4664f4.7f54d1372c70-smtp-out-n01;
 Fri, 14 Feb 2020 09:14:28 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC0FCC433A2; Fri, 14 Feb 2020 09:14:28 +0000 (UTC)
Received: from vnaralas-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mpubbise)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08D89C43383;
        Fri, 14 Feb 2020 09:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08D89C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=mpubbise@codeaurora.org
From:   Manikanta Pubbisetty <mpubbise@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH 0/2] ath11k: offload PN verification to the HW
Date:   Fri, 14 Feb 2020 14:44:10 +0530
Message-Id: <1581671652-8115-1-git-send-email-mpubbise@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series enables PN validation in the HW thereby
reducing CPU cycles spent in the host CPU. It also is the
basis for other performance improvement patches that follow
this series.

TSC (TKIP sequence counter) validation is also offloaded.

Hardware validates PN/TSC only for unicast packets;
for group addressed packets, PN validation is done
in mac80211.

This patchset is dependent on the following patch:
"ath11k: config reorder queue for all tids during peer setup"

Manikanta Pubbisetty (2):
  ath11k: handle RX fragments
  ath11k: enable PN offload

 drivers/net/wireless/ath/ath11k/Kconfig   |   1 +
 drivers/net/wireless/ath/ath11k/core.h    |   2 +
 drivers/net/wireless/ath/ath11k/dp.c      |  12 +-
 drivers/net/wireless/ath/ath11k/dp.h      |  12 +
 drivers/net/wireless/ath/ath11k/dp_rx.c   | 870 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath11k/dp_rx.h   |   8 +-
 drivers/net/wireless/ath/ath11k/hal.h     |   2 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c  |  14 +-
 drivers/net/wireless/ath/ath11k/mac.c     |  41 +-
 drivers/net/wireless/ath/ath11k/peer.h    |   7 +
 drivers/net/wireless/ath/ath11k/rx_desc.h |   2 +-
 11 files changed, 865 insertions(+), 106 deletions(-)

-- 
2.7.4
