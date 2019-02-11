Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EB5C4151A
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C388B222A8
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aFIK2guv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LsJdwas3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbfBKPKC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:10:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403932AbfBKPKB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:10:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 33922619D7; Mon, 11 Feb 2019 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897801;
        bh=5VXbjWri6vbZxqXQx6NTLrbB3AFtQpJll3z+Risvj1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFIK2guvunBgNVY7X8V/xSgdmykLXi09q07rfKegL7uASIGnOKXlEye5XB63vbhrk
         vk3hPeZDpRjlO7GNKclo6Z3U7W+YXBkt5wjKOs0gfjmstIUrr63fSChArtms9/xpap
         EnEIpLDc5GqBBwrz9suUrHyIlslBhqeih71/K7VY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B683B619EB;
        Mon, 11 Feb 2019 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897800;
        bh=5VXbjWri6vbZxqXQx6NTLrbB3AFtQpJll3z+Risvj1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsJdwas3e/HWY8Dv7+GsMEBb8a2a7iJD4HQ7cmob/KSUg6jaCtBkNgxdrjLzfia2p
         XJ80sw31Z4E7N+ko5ZLABrSr6FFzQNTcpm4A0tBHB9WWsg0CT5eagc8rhHbuyBY4wK
         nb8ZgLTvsPxf06AOPLQQNY1+kqthhUkE+ZOVKToY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B683B619EB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath10k: copy the whole struct ath10k_bus_params in ath10k_core_register()
Date:   Mon, 11 Feb 2019 17:09:47 +0200
Message-Id: <1549897787-28537-6-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Instead of copying fields one by one copy the whole structure. This way there's
no need to modify the function every time we add a new field to the struct.

Compile tested only.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6c1dd5f8d012..a1b2aea4a77f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2997,9 +2997,8 @@ static void ath10k_core_register_work(struct work_struct *work)
 int ath10k_core_register(struct ath10k *ar,
 			 const struct ath10k_bus_params *bus_params)
 {
-	ar->bus_param.chip_id = bus_params->chip_id;
-	ar->bus_param.dev_type = bus_params->dev_type;
-	ar->bus_param.link_can_suspend = bus_params->link_can_suspend;
+	ar->bus_param = *bus_params;
+
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
-- 
2.7.4

