Return-Path: <SRS0=wsxy=YN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE96CA9EAD
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 10:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65243222BD
	for <linux-wireless@archiver.kernel.org>; Sun, 20 Oct 2019 10:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jdSnaovO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FPlLaQnv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfJTKGR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 20 Oct 2019 06:06:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfJTKGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 Oct 2019 06:06:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3AEF961494; Sun, 20 Oct 2019 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571565976;
        bh=7yr0h2lx+YiXkiqw/19KA0wgyqVjlnuYE49SnKa4coI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdSnaovOHcR+j5eSTSartTNi/ykFyDvhe4rbkEVOFNrQgXVV1gGbufzA3VC7cLyYc
         GRH9UfFuSedRSWaDR42VWGdnOE2swLWHrcsqGvv8t06GAJe7WqQIc2hhGYvXCLfa23
         lM6NHiUD6VEwhAKRtokpC33p0CIaHNVNFbolTt0U=
Received: from x230.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C921612D1;
        Sun, 20 Oct 2019 10:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571565966;
        bh=7yr0h2lx+YiXkiqw/19KA0wgyqVjlnuYE49SnKa4coI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPlLaQnvWicPWnIdaClMVVISAldMfrsoFrUou4xjGkGEoMOOjXN7c6XVEZzUJ4GgW
         GtmrbFsxoXrJGpoFZLC8IQ7Mk47iN52GqKoke1b0Dkz3EZaI7/rgjbv2iW1cqqKR+V
         HP30mPFIlMfvHP3eX17u8CkMx+DuOgjFZFqqUNMI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C921612D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH v2 47/49] ath: add ath11k to Makefile
Date:   Sun, 20 Oct 2019 13:04:05 +0300
Message-Id: <1571565847-10338-48-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571565847-10338-1-git-send-email-kvalo@codeaurora.org>
References: <1571565847-10338-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(patches split for easier review, see the cover letter for more)

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index e4e460b5498e..72f8e3a24c67 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_AR5523)		+= ar5523/
 obj-$(CONFIG_WIL6210)		+= wil6210/
 obj-$(CONFIG_ATH10K)		+= ath10k/
 obj-$(CONFIG_WCN36XX)		+= wcn36xx/
+obj-$(CONFIG_ATH11K)		+= ath11k/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 

