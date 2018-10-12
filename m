Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1580C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB322075B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iw5kcUIL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Iw5kcUIL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB322075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbeJLRVT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:21:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeJLRVT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:21:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ABE1A600C1; Fri, 12 Oct 2018 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539337783;
        bh=kosiqQP5ZhPuyPP0Wv9udxq3beaKzze6/4RiWO0zWOI=;
        h=From:To:Cc:Subject:Date:From;
        b=Iw5kcUILUmjyLS6K1NdJnn97W8iCcfWUhBodbg6J6+zSYhtnhy+J9SNDwUoTd+L8l
         ymPt5j4xihPgKzj/3brDrsbe4w7Y2XkLIxMEee9KFvtxamIjXsSkWgVNxr+NsgOzzB
         nBnbt1N3A4PZEJrCSCMNMj9OPEXcceGiD8fPFQjI=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CF35F600C1;
        Fri, 12 Oct 2018 09:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539337783;
        bh=kosiqQP5ZhPuyPP0Wv9udxq3beaKzze6/4RiWO0zWOI=;
        h=From:To:Cc:Subject:Date:From;
        b=Iw5kcUILUmjyLS6K1NdJnn97W8iCcfWUhBodbg6J6+zSYhtnhy+J9SNDwUoTd+L8l
         ymPt5j4xihPgKzj/3brDrsbe4w7Y2XkLIxMEee9KFvtxamIjXsSkWgVNxr+NsgOzzB
         nBnbt1N3A4PZEJrCSCMNMj9OPEXcceGiD8fPFQjI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CF35F600C1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 0/3] Add support for suspend/resume and WOW for WCN3990 chipset
Date:   Fri, 12 Oct 2018 15:19:35 +0530
Message-Id: <20181012094938.14734-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series adds support for driver suspend/resume and wake over wlan support
for WCN3990 chipset. CE2 is configured as wakeup source before driver suspend
and FW can wake up application processor on Magic packet/Deauth/AP lost.

change since v1:
  Log enhancement in "ath10k: Enable bus layer suspend/resume for WCN3990" patch.

Govind Singh (3):
  ath10k: Enable bus layer suspend/resume for WCN3990
  ath10k: Disable interface pause wow config for integrated chipset
  ath10k: Request credit report if flow control enabled on ep

 drivers/net/wireless/ath/ath10k/htc.c     |  3 +-
 drivers/net/wireless/ath/ath10k/snoc.c    | 45 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  7 ++++
 4 files changed, 56 insertions(+), 1 deletion(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

