Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5E7C282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF626222B0
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I2hujBnl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I2hujBnl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403933AbfBKPKB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:10:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403922AbfBKPKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:10:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E45E56191A; Mon, 11 Feb 2019 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897799;
        bh=rDSLenA25ynzc50KNH0/wVklbe2LQZhxsEtz3RTN0RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2hujBnlAEYHNHE3r6vVkHVvMm6wrrgA8rOQNvKVuEpHPp9ilK2yUaSS4kEQxytIl
         8ZafJsHbeJLEZlDR/Cw6WgRpQ9rLpciPDLZicWaFymYWJMp1VcT5WjkyufFmqthIJx
         MWUmbKulIGkz8VU/Nek2joz2jhOoYTbI0kwkTFlw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35BC5619D7;
        Mon, 11 Feb 2019 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549897799;
        bh=rDSLenA25ynzc50KNH0/wVklbe2LQZhxsEtz3RTN0RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2hujBnlAEYHNHE3r6vVkHVvMm6wrrgA8rOQNvKVuEpHPp9ilK2yUaSS4kEQxytIl
         8ZafJsHbeJLEZlDR/Cw6WgRpQ9rLpciPDLZicWaFymYWJMp1VcT5WjkyufFmqthIJx
         MWUmbKulIGkz8VU/Nek2joz2jhOoYTbI0kwkTFlw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35BC5619D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath10k: fix documentation in ath10k_wow_convert_8023_to_80211()
Date:   Mon, 11 Feb 2019 17:09:46 +0200
Message-Id: <1549897787-28537-5-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
References: <1549897787-28537-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With W=1 there's a warning:

drivers/net/wireless/ath/ath10k/wow.c:93: warning: Function parameter or member 'new' not described in 'ath10k_wow_convert_8023_to_80211'
drivers/net/wireless/ath/ath10k/wow.c:93: warning: Function parameter or member 'old' not described in 'ath10k_wow_convert_8023_to_80211'

Fix it by changing the documentation marker '/**' to a normal code comment.
While at it, clean up the line wrapping.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wow.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index 36d4245c308e..b36fa0f8892e 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -77,7 +77,7 @@ static int ath10k_wow_cleanup(struct ath10k *ar)
 	return 0;
 }
 
-/**
+/*
  * Convert a 802.3 format to a 802.11 format.
  *         +------------+-----------+--------+----------------+
  * 802.3:  |dest mac(6B)|src mac(6B)|type(2B)|     body...    |
@@ -88,9 +88,8 @@ static int ath10k_wow_cleanup(struct ath10k *ar)
  * 802.11: |4B|dest mac(6B)| 6B |src mac(6B)|  8B  |type(2B)|  body...  |
  *         +--+------------+----+-----------+---------------+-----------+
  */
-static void ath10k_wow_convert_8023_to_80211
-					(struct cfg80211_pkt_pattern *new,
-					const struct cfg80211_pkt_pattern *old)
+static void ath10k_wow_convert_8023_to_80211(struct cfg80211_pkt_pattern *new,
+					     const struct cfg80211_pkt_pattern *old)
 {
 	u8 hdr_8023_pattern[ETH_HLEN] = {};
 	u8 hdr_8023_bit_mask[ETH_HLEN] = {};
-- 
2.7.4

