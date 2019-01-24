Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767F2C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396BA21872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gz6ivUcG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yzp6CSZf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfAXOVt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:21:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbfAXOVt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 09:21:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E6F57607DD; Thu, 24 Jan 2019 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339708;
        bh=lHCLseRg06IP8EXc04vWqzRWDozSv1IKhCCDdMSOlj8=;
        h=From:To:Cc:Subject:Date:From;
        b=gz6ivUcGqkgtHXyyS2zhM+c1gWNQ/n2cZrNPuoK+y2sWEQi2jPsqWd43xgyjjHTez
         ddfmz9lKwi+PfolnJwykefDBEg7+26orTDPFP61/n4tpKPEDppHjmn41oge5tDm3R6
         9KP4ULuQMRvIkq+5hmPLBXjGyjGYIokP6x0N9b/Q=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B988607DD;
        Thu, 24 Jan 2019 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339706;
        bh=lHCLseRg06IP8EXc04vWqzRWDozSv1IKhCCDdMSOlj8=;
        h=From:To:Cc:Subject:Date:From;
        b=Yzp6CSZfUdtJlLy6ARZImiRKOsFTVCNpgHM5uwoGEiBBXNDqCu8xpiFUlRTzR/Zy/
         pl+sFasR670/ejONfU2pBbwnP7SncFdf5fTHffuRI0dqSFfGLofsT0XBLV4IqU4HFh
         I7z6R4tDpx4TaleMooOo/ewX87uJ2Z9eKFu+yYxk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B988607DD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH 0/2] Enable WPA3 cipher suites in WCN3990 firmware
Date:   Thu, 24 Jan 2019 19:51:35 +0530
Message-Id: <1548339697-17766-1-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset brings changes to enable CCMP, GCMP & GCMP-256 cipher suites to run WPA3 security protocol in WCN3990. TLV based firmwares ex. QCA6174,
WCN3990 and non-TLV based firmwares have differnet mapping for GCMP &
GCMP-256 cipher suites.
Cipher suites mapping in host driver is done according to wmi tlv and non-tlv versions of firmware.

Abhishek Ambure (2):
  ath10k: Assign 'n_cipher_suites = 11' for WCN3990 to enable WPA3
  ath10k: Update GCMP & GCMP-256 cipher suite number for WCN3990

 drivers/net/wireless/ath/ath10k/core.c    |  1 +
 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 12 +++++------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/wmi.c     | 30 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 33 ++++++++++++++++++++++---------
 6 files changed, 66 insertions(+), 17 deletions(-)

-- 
1.9.1

