Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762B5C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2416620868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TbubuvBJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YjfbLKC6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2416620868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbeJLRBs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:01:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbeJLRBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:01:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 43BD8605A4; Fri, 12 Oct 2018 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539336616;
        bh=NL7VTn5Xfum+T2OIvZq7rJTHc3ko1v7S3RrfBFeYluM=;
        h=From:To:Cc:Subject:Date:From;
        b=TbubuvBJGoVsvlXqMlqO2KE1Vor9/FzddwEuqyUR0u7kE6a+eikNwVPUAns6INiqA
         dY9JLfkOYHGJRLp5abtom2s0ZMMoQlrXQ1UkqH4qJpFBh/3Sag22j3G8VTUE+rLipx
         lD1KDJsa9Aq+A9QLhl0J02vVXMQAKJQ772LihMFw=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E6E9605A4;
        Fri, 12 Oct 2018 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539336615;
        bh=NL7VTn5Xfum+T2OIvZq7rJTHc3ko1v7S3RrfBFeYluM=;
        h=From:To:Cc:Subject:Date:From;
        b=YjfbLKC6z8J8FXVfh347jrJa8TiUakLNuJ1ojgiUC7vo21zzq+bv/t4FAFxhreNwv
         SoyyDUNYc5vYlQUHpICigo25velv6wen0YHWnlOCOASBvBjFeU6llDlYzDDQcVpXAb
         a7daz2CnpuYzyUlaAItYQRg6nJK1sbaum9yaIqPE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7E6E9605A4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 0/3] Add support for suspend/resume and WOW for WCN3990 chipset
Date:   Fri, 12 Oct 2018 15:00:00 +0530
Message-Id: <20181012093003.11932-1-govinds@codeaurora.org>
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

