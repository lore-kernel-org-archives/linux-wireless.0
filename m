Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289CDC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1174222A7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LR8EZ+cC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YlzktFib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbfBKPJ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:09:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403802AbfBKPJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:09:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AC05A618E2; Mon, 11 Feb 2019 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897796;
        bh=DxSPw5Ltq7ijmgi6nY3/Z8HDO8TMd5USROHJvM8lWO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LR8EZ+cCUVYb2+9wqJAYsJZJItFAstnvC+b/oxtqnPiDtyVYeLnKouw80dMDzzaMn
         ItONUqVK9X+rE42TIz1yXeopeTCOLrQa5WVthrgLkQtAgBnae7paoFbDsnlWlvgCpW
         HEWSktR+3WfkZQJPZECzuehz+HkyWAFHoTGtBODM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA8C1618E2;
        Mon, 11 Feb 2019 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897795;
        bh=DxSPw5Ltq7ijmgi6nY3/Z8HDO8TMd5USROHJvM8lWO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlzktFibHMVE8/tTvw83GC4qDafG5m72pler4aTjNVlSR0zdonctkJ7cIhGhnpL8P
         kDyfv0R/zHKmzofq+vNjcisyHw6JuTZTedNQHo/da7gHKKswyreiADf8ahPfxz4fS/
         1ZfpbUiEGJFUWyPGrl6Up2mwQvCxWR6CHOLMGA3k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA8C1618E2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] ath10k: change wmi.h to include only ieee80211.h
Date:   Mon, 11 Feb 2019 17:09:44 +0200
Message-Id: <1549897787-28537-3-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

wmi.h does not use anything from mac80211.h so change it to include only
ieee80211.h.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 74ce1a4c0e8f..23fe482834b4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -20,7 +20,7 @@
 #define _WMI_H_
 
 #include <linux/types.h>
-#include <net/mac80211.h>
+#include <linux/ieee80211.h>
 
 /*
  * This file specifies the WMI interface for the Unified Software
-- 
2.7.4

