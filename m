Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748B1C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F65420684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 18:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nWQNikw3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nWQNikw3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F65420684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbeJCAs2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 20:48:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbeJCAs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 20:48:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AFE2B60C67; Tue,  2 Oct 2018 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503431;
        bh=jvRFIAxjE+pXeJhZRJ5NXAaGScus1FLCOR1wg4GcVdU=;
        h=From:To:Cc:Subject:Date:From;
        b=nWQNikw372DFyS+fzmgMb9IUEKNqdG/djjWsZwr40CiGFR1e7efUy/e8flxX09VtR
         erFGfW98bV0wJqKJrJo1Z/Sl1VbfhmEuax/h+vXLBf9tIk5rccb+oqk5k+PY19/sZ0
         DeTPthep3RZxDp9DwIEDHBjB0MHZ8MUH9m51M1b0=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E07C760C4D;
        Tue,  2 Oct 2018 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538503431;
        bh=jvRFIAxjE+pXeJhZRJ5NXAaGScus1FLCOR1wg4GcVdU=;
        h=From:To:Cc:Subject:Date:From;
        b=nWQNikw372DFyS+fzmgMb9IUEKNqdG/djjWsZwr40CiGFR1e7efUy/e8flxX09VtR
         erFGfW98bV0wJqKJrJo1Z/Sl1VbfhmEuax/h+vXLBf9tIk5rccb+oqk5k+PY19/sZ0
         DeTPthep3RZxDp9DwIEDHBjB0MHZ8MUH9m51M1b0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E07C760C4D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 0/2] ath10k: Handle bundle tx completion for management pkts
Date:   Tue,  2 Oct 2018 23:33:39 +0530
Message-Id: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 sends the tx completion for management frames via wmi.
The tx completion for the multiple management frames can also
be bundled in a single wmi event and sent to the host driver.
This reduces the number of WMI events sent to the host driver
by the target.

Enable the support in firmware to send tx completion for
management frames, bundled in a single event, by setting the
proper flag in wmi init command.
Handle the bundled management tx completion event in host driver.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Rakesh Pillai (2):
  ath10k: Handle bundled tx completion for managenent frames
  ath10k: Enable bundle tx compl for management frames in WCN3990

 drivers/net/wireless/ath/ath10k/wmi-ops.h | 13 +++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 65 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  3 ++
 drivers/net/wireless/ath/ath10k/wmi.c     | 26 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 ++++
 5 files changed, 113 insertions(+), 1 deletion(-)

-- 
2.7.4

