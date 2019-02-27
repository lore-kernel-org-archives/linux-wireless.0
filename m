Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D420C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF02C218D0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iQ7cwCmq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bc5e/RO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfB0HNK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:13:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45057 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 02:13:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0EE6960AA3; Wed, 27 Feb 2019 07:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251589;
        bh=jMSTB891BGiQPsZwNirO71sWe9kv0OkFQmBIGi4Ws+k=;
        h=From:To:Cc:Subject:Date:From;
        b=iQ7cwCmqSTk6bACWr4i6ZnIvGE2ye6BYmhPnXlE3Y//OQ3eHQ0d1jmFAKqP1eMvqg
         qxUPqcRt7PqUavM9b0fX305fJaFwGNRbNY6s/XJcp9zabd2yCptJddX7lfT0NFP5+6
         q2gMxmj0NlzNmttOmG7yATX++OOPOVjcLXhogoyw=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6544E60A0A;
        Wed, 27 Feb 2019 07:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251588;
        bh=jMSTB891BGiQPsZwNirO71sWe9kv0OkFQmBIGi4Ws+k=;
        h=From:To:Cc:Subject:Date:From;
        b=Bc5e/RO3sbW8t24oAgPWeaQG1k0GGF4wFxh3vQDvXcweaZuYzIt963sz2QB1dSdAu
         VmhOSIJLGTKnrLuLXUHHy+jvKUHwoe4AFZx1RG/sGc8QyPhWeCwlbVrICvNYhu25/b
         X3FDYrLfXtUplh//1WarV55ItfZsEl+gAUrmnE70=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6544E60A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 0/2] Add support for per peer HTT tx stats for WCN3990 
Date:   Wed, 27 Feb 2019 12:42:59 +0530
Message-Id: <1551251581-21193-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 firmware sends the HTT_TLV_T2H_MSG_TYPE_PEER_STATS in tlv
format so the handling of this message has to be done in different
manner.

This patchset adds support to attach rx_ops based on htt version
and adds the handling of HTT_TLV_T2H_MSG_TYPE_PEER_STATS message
based on HTT version.

Surabhi Vishnoi (2):
  ath10k: Add support for adding htt_rx_ops based on htt_version
  ath10k: Add support for per peer HTT tx stats for WCN3990

 drivers/net/wireless/ath/ath10k/htt.c     |   2 +
 drivers/net/wireless/ath/ath10k/htt.h     |  67 +++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 165 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/hw.c      |  45 +++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |  34 ++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   3 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  33 ++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   3 -
 8 files changed, 340 insertions(+), 12 deletions(-)

-- 
1.9.1

