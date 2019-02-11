Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54D0C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9320B222A7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gtv0/VYc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SLYCQ7ET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403925AbfBKPKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:10:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403911AbfBKPJ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:09:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 77BCC619E3; Mon, 11 Feb 2019 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897798;
        bh=MZEcwysdfdD/1wpOHcY3EIBmucsz7ud7wY2EzfG1424=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtv0/VYcTPWkJCZsJFyXJEiKRGuncP7G8y9UAaddzLxDwPSvWSiNKiPWNt2T9eBwb
         Bxg30jor0XSDxwhkR+5mCytGRDrnrbGcVvgi4wqjfodLkRoxaU7KTKOzaDfIA7jQA5
         qA1xc1PwMH3AapDL9vvnSGzpT/xLkxE2PnwYb2jc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 792696198C;
        Mon, 11 Feb 2019 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897797;
        bh=MZEcwysdfdD/1wpOHcY3EIBmucsz7ud7wY2EzfG1424=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLYCQ7ETpttouTmUnJv6pvfujY92qS5/m1wA0lOi5lKBNbA3jVRpeszYKdYz/ZVYj
         4QPZSogaks3CRNjBUN4KSQJ88V04WKurn9sknbOGG6mC9pvKaKCWLhILd9WCYs0Vcq
         /0hvMOBhArwlimGgopbAK+p0THEIUyYV2KXistzY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 792696198C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath10k: align ath10k_htt_txbuf structures
Date:   Mon, 11 Feb 2019 17:09:45 +0200
Message-Id: <1549897787-28537-4-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With W=1 GCC warns:

drivers/net/wireless/ath/ath10k/htt.h:1746:1: warning: alignment 1 of 'struct ath10k_htt_txbuf_32' is less than 4 [-Wpacked-not-aligned]
drivers/net/wireless/ath/ath10k/htt.h:1753:1: warning: alignment 1 of 'struct ath10k_htt_txbuf_64' is less than 4 [-Wpacked-not-aligned]

Fix that by using __align(4). Compile tested only.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 005fad94edad..d194bbe18fc3 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1743,14 +1743,14 @@ struct ath10k_htt_txbuf_32 {
 	struct ath10k_htc_hdr htc_hdr;
 	struct htt_cmd_hdr cmd_hdr;
 	struct htt_data_tx_desc cmd_tx;
-} __packed;
+} __packed __aligned(4);
 
 struct ath10k_htt_txbuf_64 {
 	struct htt_data_tx_desc_frag frags[2];
 	struct ath10k_htc_hdr htc_hdr;
 	struct htt_cmd_hdr cmd_hdr;
 	struct htt_data_tx_desc_64 cmd_tx;
-} __packed;
+} __packed __aligned(4);
 
 struct ath10k_htt {
 	struct ath10k *ar;
-- 
2.7.4

