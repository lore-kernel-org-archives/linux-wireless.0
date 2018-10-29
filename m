Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F26C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 06:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFA22054F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 06:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rwe7yaNc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rwe7yaNc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DFA22054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbeJ2PJE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 11:09:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729058AbeJ2PJE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 11:09:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8C8EA605A4; Mon, 29 Oct 2018 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540794109;
        bh=pLgnJc9v6uIxHMmz/iDB8yA7HKGdR6Qic74+wuD4ChI=;
        h=From:To:Cc:Subject:Date:From;
        b=Rwe7yaNcxxi0qbT7nisLi5SvW8n+LtOIHk3cTZRvoS5ClZA6N/wnvFXWzTatprilo
         EW2WNUwHhyl9sC4XzbVNou0UkLmOLeUg2buqEtx1AOnixQXWv0IA1Yne2NADwZFO7J
         aPZz8Eby6FVCgZfnd5sOsE2hAc1B86i9lUL5a5ME=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yyuwang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 696DA6030F;
        Mon, 29 Oct 2018 06:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540794109;
        bh=pLgnJc9v6uIxHMmz/iDB8yA7HKGdR6Qic74+wuD4ChI=;
        h=From:To:Cc:Subject:Date:From;
        b=Rwe7yaNcxxi0qbT7nisLi5SvW8n+LtOIHk3cTZRvoS5ClZA6N/wnvFXWzTatprilo
         EW2WNUwHhyl9sC4XzbVNou0UkLmOLeUg2buqEtx1AOnixQXWv0IA1Yne2NADwZFO7J
         aPZz8Eby6FVCgZfnd5sOsE2hAc1B86i9lUL5a5ME=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 696DA6030F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yyuwang@codeaurora.org
From:   Yu Wang <yyuwang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add amsdu support for monitor mode
Date:   Mon, 29 Oct 2018 14:21:43 +0800
Message-Id: <1540794104-30957-1-git-send-email-yyuwang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When processing HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND,
if the length of a msdu is larger than the tailroom
of the rx skb, skb_over_panic issue will happen when
calling skb_put.
In monitor mode, amsdu will be handled in this path,
and msdu_len of the first msdu_desc is the length of
the entire amsdu, which might be larger than the
maximum length of a skb, in such case, it will hit
the issue upon.
To fix this issue, processing msdu list separately
for monitor mode.

Successfully tested with:
QCA6174 (FW version: RM.4.4.1.c2-00057-QCARMSWP-1).

Yu Wang (1):
  ath10k: add amsdu support for monitor mode

 drivers/net/wireless/ath/ath10k/htt_rx.c | 187 +++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)

-- 
1.9.1

