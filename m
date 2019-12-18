Return-Path: <SRS0=gBLi=2I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C25C43603
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 15:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA8820684
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Dec 2019 15:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="O8NkgSvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLRPsi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Dec 2019 10:48:38 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:58046 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbfLRPsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Dec 2019 10:48:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576684117; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=3XuAEDloRVK23m2ic5Oe8G0vXeXlaOQXqVMsLND1wYo=; b=O8NkgSvSHyNV95qE78Gu7KgMDexj0IHppWjNT2Y3v1VCm47gv8an+i0Htqv00D0u0lCmmLZk
 5IdMSxmsW+7bUAa6PYj3n6teVtp+2Mr2+04GPBqq5Y8KcN8CSl2usEllwlEUFfjvxPxxV7Ev
 rHTbPJ0HFnNUtRx3EJasXITxjcw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa4a52.7fd7d9039bc8-smtp-out-n02;
 Wed, 18 Dec 2019 15:48:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30DCAC43383; Wed, 18 Dec 2019 15:48:33 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 273A6C433CB;
        Wed, 18 Dec 2019 15:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 273A6C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ath10k: SAR power limit vendor command
Date:   Wed, 18 Dec 2019 17:48:26 +0200
Message-Id: <1576684108-30177-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

here's a patchset adding dynamic SAR power limit vendor command to
ath10k. This follows the new process documented in the wiki:

https://wireless.wiki.kernel.org/en/developers/documentation/nl80211#vendor-specific_api

Please review.

Kalle

Wen Gong (2):
  nl80211: vendor-cmd: qca: add dynamic SAR power limits
  ath10k: allow dynamic SAR power limits to be configured

 drivers/net/wireless/ath/ath10k/Makefile |   1 +
 drivers/net/wireless/ath/ath10k/core.c   |   2 +
 drivers/net/wireless/ath/ath10k/core.h   |   2 +
 drivers/net/wireless/ath/ath10k/hw.h     |   3 +
 drivers/net/wireless/ath/ath10k/mac.c    |  64 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h    |   2 +-
 drivers/net/wireless/ath/ath10k/vendor.c | 114 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/vendor.h |  13 ++++
 drivers/net/wireless/ath/ath10k/wmi.h    |   6 ++
 include/uapi/nl80211-vnd-qca.h           |  68 ++++++++++++++++++
 10 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/vendor.c
 create mode 100644 drivers/net/wireless/ath/ath10k/vendor.h
 create mode 100644 include/uapi/nl80211-vnd-qca.h

-- 
2.7.4
