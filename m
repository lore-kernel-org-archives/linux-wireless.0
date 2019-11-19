Return-Path: <SRS0=eo9X=ZL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F9FC432C0
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 07:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04972208CE
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 07:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UzY00hxZ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="a3teyMfw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSHTt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:19:49 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:43218
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfKSHTs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Nov 2019 02:19:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574147988;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=b6tZszgWPMp4h4WZCQENZl91ooWFo3rBa4JdJzv2Jc4=;
        b=UzY00hxZ6K7wM68r13xL0xcQsaJShjuthQ/NMY2oQbieWMTNv25A0RvX8uT9YfsX
        D7a1HE/ZVBTsXyktEw/Nq9X688V3j1dD0UB2mY/z2NLMoMckhh0naS8ZXyVi6LXwYVP
        HQA+6MnU9HdJLoGbDEj/wGNQAzd2/uhpVlSE7X04=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574147988;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=b6tZszgWPMp4h4WZCQENZl91ooWFo3rBa4JdJzv2Jc4=;
        b=a3teyMfwfZEsK/9MsjDTTMeSw1g4dKDUKeh+RgMZleV1V5wEVx6OV8Jqecw+C9T9
        8451TZmjwuC+bp7LXbqETtC1txvyK3olnSIOZqBhmVG5aciSgF+xC1LSq5U+d0eV6X2
        Nbh++YrKVFTe+RBYR35XumCGwGU7H7UkzH9XvN2k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 040D7C4479F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=yyuwang@codeaurora.org
From:   Yu Wang <yyuwang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] ath10k: correct tx bitrate for QCA6174/QCA9377/QCA9888
Date:   Tue, 19 Nov 2019 07:19:48 +0000
Message-ID: <0101016e82881a59-7429a45b-fae7-4499-8834-e9dfff0babb7-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.7.4
X-SES-Outgoing: 2019.11.19-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tx bitrate got by command 'iw wlan0 link' is incorrect.
These 2 patches will fix the issue.

Changes from v1:
[PATCH v2] ath10k: correct legacy rate in tx stats
Remove wmi ops for getting legacy rate, instead, update the ratecode got from
PPDU stats, to align with the existing tx rate processing.

Yu Wang (2):
  ath10k: add ppdu stats support for QCA6174/QCA9377
  ath10k: correct legacy rate in tx stats

 drivers/net/wireless/ath/ath10k/htt.c     |   2 +
 drivers/net/wireless/ath/ath10k/htt.h     |  30 ++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 146 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.c     |   2 +-
 drivers/net/wireless/ath/ath10k/mac.h     |   1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   4 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   3 +
 7 files changed, 186 insertions(+), 2 deletions(-)

-- 
2.7.4

