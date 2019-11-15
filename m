Return-Path: <SRS0=1RAM=ZH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC65C33C9B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 09:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D07DC206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 09:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QJUUVYlt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oiXY/f3/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfKOJbk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:31:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKOJbj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Nov 2019 04:31:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C621C616DE; Fri, 15 Nov 2019 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573810298;
        bh=1v6TLeEtmhwNqEaAwzgjYBDH5RMoH2RrcEvrvQrbMK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJUUVYltGfAX4syws5ZEeNvTtd1icMO+FZ9P9apmmgV6EVtbOZ4PyacoUnOihOu2N
         s5JH0h+2BnXUYjJ7i/YPMlzzYykJAklxso37y2SRmLBFaEAhmLzsVl3hRkYaisn1QO
         YVYsTN6vm4V41W6tl7jTOSHs+xN7+uu1ynkl5Wkw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2A626169E;
        Fri, 15 Nov 2019 09:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573810283;
        bh=1v6TLeEtmhwNqEaAwzgjYBDH5RMoH2RrcEvrvQrbMK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiXY/f3/ftxINMUuwyTZvlyPkyKWE1kGeH6HldFgqdRTqAvdaoTaJEDwYV/RSVqpe
         66XfaIXX+Ho8X4CtBg7l+2dD0gKyu9W7ufsGnt9l/H4hq8cPkMUmOFoJLtDf3ZdZwF
         578Xzg+mYOuJc6oFIIfetBFjxswqZxWfISR5xJRo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2A626169E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH v3 48/49] ath: add ath11k to Kconfig
Date:   Fri, 15 Nov 2019 11:29:12 +0200
Message-Id: <1573810153-29623-49-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573810153-29623-1-git-send-email-kvalo@codeaurora.org>
References: <1573810153-29623-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(patches split for easier review, see the cover letter for more)

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 82ab7c33cf97..88473bcdd196 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -61,5 +61,6 @@ source "drivers/net/wireless/ath/ar5523/Kconfig"
 source "drivers/net/wireless/ath/wil6210/Kconfig"
 source "drivers/net/wireless/ath/ath10k/Kconfig"
 source "drivers/net/wireless/ath/wcn36xx/Kconfig"
+source "drivers/net/wireless/ath/ath11k/Kconfig"
 
 endif

