Return-Path: <SRS0=g1I5=CU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0E3C43461
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 00:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5492087D
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Sep 2020 00:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eyQvmHPb";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KtT0baCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgIKAF3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 20:05:29 -0400
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:38598
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbgIKAF1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 20:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599782726;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=vtEBgfXJQK2BxsCQVDjwymuCRc0puuUGn3I/AVCRbw8=;
        b=eyQvmHPblBAUKNxpIdKuU0ZJagk+oVMvc0BaBVVb+5xpbeQJ9AyTQqhMP4XTKvU+
        9yuoLnPLeDq4iFCVCHjMrgJa9Kh4ZxKdMtKNMReNpjgpXSQ2DRlKDnWt6zvX8v62wAM
        4+bQnJvLXlCAwxUG1/JMOClPctglVTX9nN6HYi/Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599782726;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
        bh=vtEBgfXJQK2BxsCQVDjwymuCRc0puuUGn3I/AVCRbw8=;
        b=KtT0baCyLqkIB1lSKhPSjBxTufAny+ReQEUmTK22E/XRRTDEnERUd4QdbKFn38Ub
        7ta5AAppBItLZrVYUKQVXaWsqc2vZAZvm1whioH/CAuNsJhZ+SjB/U1/uBHLhpbbyp9
        /ETVQ1RS/IBIRkAwA9Go+9mpOeSMpcPiCjGHvhEk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5FFC2C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=alokad@codeaurora.org
From:   Aloka Dixit <alokad@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Aloka Dixit <alokad@codeaurora.org>
Subject: [PATCH v6 0/2] Add FILS discovery support
Date:   Fri, 11 Sep 2020 00:05:26 +0000
Message-ID: <010101747a7b2b09-e208dc39-48f6-4d49-bd4d-7b7af4931505-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2020.09.11-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset adds support for FILS discovery transmission as per
IEEE Std 802.11ai-2016.

v6: Addressed review comments from v5.

Aloka Dixit (2):
  nl80211: Add FILS discovery support
  mac80211: Add FILS discovery support

 include/net/cfg80211.h       | 19 +++++++++++++
 include/net/mac80211.h       | 27 ++++++++++++++++++
 include/uapi/linux/nl80211.h | 44 +++++++++++++++++++++++++++++
 net/mac80211/cfg.c           | 54 ++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h   |  7 +++++
 net/mac80211/tx.c            | 28 +++++++++++++++++++
 net/wireless/nl80211.c       | 50 +++++++++++++++++++++++++++++++++
 7 files changed, 223 insertions(+), 6 deletions(-)

-- 
2.25.0

