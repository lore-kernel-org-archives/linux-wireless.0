Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19F7C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 05:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 947CC20882
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 05:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OI6Bi52D";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OI6Bi52D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfCBFGn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 00:06:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbfCBFGn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 00:06:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D2A7560CF0; Sat,  2 Mar 2019 05:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551503202;
        bh=a+bHHmTnOO2+xMd0ZeIKrBUaiosfZ497iwrKfgXNow4=;
        h=From:To:Cc:Subject:Date:From;
        b=OI6Bi52D6HpTHgQyEI0DltAAYzsO3di4o+9nWRThvuMiJ9i1tRyA8gA5mV/tUlS4s
         629uHxHjIGi5t320kAeg4UGi/TfyUTtbcjHuLYcw+/GUjwNUHMubzrWbLwkjDsqtnL
         XPrcAcdpuuvL3qiP1MtL/K0QtyGd3/HZuQ0soEMM=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CEEAF60744;
        Sat,  2 Mar 2019 05:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551503202;
        bh=a+bHHmTnOO2+xMd0ZeIKrBUaiosfZ497iwrKfgXNow4=;
        h=From:To:Cc:Subject:Date:From;
        b=OI6Bi52D6HpTHgQyEI0DltAAYzsO3di4o+9nWRThvuMiJ9i1tRyA8gA5mV/tUlS4s
         629uHxHjIGi5t320kAeg4UGi/TfyUTtbcjHuLYcw+/GUjwNUHMubzrWbLwkjDsqtnL
         XPrcAcdpuuvL3qiP1MtL/K0QtyGd3/HZuQ0soEMM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CEEAF60744
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 0/2] Add xo calibration support for wifi rf clock
Date:   Sat,  2 Mar 2019 10:36:33 +0530
Message-Id: <20190302050635.17694-1-govinds@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PMIC XO is the clock source for wifi rf clock in integrated wifi
chipset ex: WCN3990. Due to board layout errors XO frequency drifts
can cause wifi rf clock inaccuracy.
XO calibration test tree in Factory Test Mode is used to find the
best frequency offset(for example +/-2KHz )by programming XO trim
register. This ensure system clock stays within required 20 ppm
WLAN rf clock.

Retrieve the xo trim offset via system firmware (e.g., device tree),
especially in the case where the device doesn't have a useful EEPROM
on which to store the calibrated XO offset (e.g., for integrated Wifi).
Calibrated XO offset is sent to fw, which compensate the clock drift
by programing the XO trim register.

Testing:
        Tested on QCS404 platform(WCN3990 HW)
        Tested FW: WLAN.HL.3.1-00959-QCAHLSWMTPLZ-1

Govind Singh (2):
  dt: bindings: add dt entry for XO calibration support
  ath10k: Add xo calibration support for wifi rf clock

 .../devicetree/bindings/net/wireless/qcom,ath10k.txt |  1 +
 drivers/net/wireless/ath/ath10k/qmi.c                | 12 ++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.c               | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h               |  2 ++
 4 files changed, 25 insertions(+)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

