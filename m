Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DB7C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88DD2087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcRqoOyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfAaFxa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:30 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34434 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:30 -0500
Received: by mail-pf1-f176.google.com with SMTP id h3so1008033pfg.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MrAISwE4okyWYrZpaIGwYWxJI5SaXrch4Kr/+u18qXg=;
        b=lcRqoOyxItOJ7KY8FVkMW8zD4tPI+sj3O3MZ/JZchS4WddN1kA1JG4fwNHgq5JErHs
         wkPDiyPIaUB2ea98u8YEbmbJiOqSBquD0L4jUVfz/h8YzRZfEy8AQ0SSpgcqcpUNNGSE
         Ea/h1gj9WLYNyl2b3n52toLTNoCzNvlHinuXUwYUCFgRt0cxKo5w5GhxslZGJkSGPKs0
         erVr1VWsGGEXeHkzei1gdY6mY9dd1No0956l8X3oPkmnugSDDNvNcOD1uKgju9VGGS+2
         JWNqC25I8Ug3uThvWGx56znec82IOFIEsceUo4fAQ580D2DI7xRvMdlHDoB8Nk71KpXv
         6eQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MrAISwE4okyWYrZpaIGwYWxJI5SaXrch4Kr/+u18qXg=;
        b=epN78sdJO6an1oIBqVY7p05j62SPc+HTp40OfyDeuzfbS/qggKTRY33MdSOddxgTXS
         en7E9FBhNp/KnTnsF4+4lRpNpqhSulb2rWb26ceBkpmx6lo00t9AHXaRvd0rsVQ8MHSi
         xKR+0cP56g281qKQ7tCC2mSbPwe/+wEPfOnCwfBVa5kxk6qqOG3SEpVcQjjyKIl6jX4s
         TyaBj9o0TSvoAUiNDFzp/YTZQSCm8l6uMNkRVk1wTWNho9WLUSy4urD+NmOT+DHbKN2P
         u1XLBlph3F1582MGpQiblQr8FJ93X84mPS3vLeL8hq7xWM4lNkP4A1gHQizLzRgSVnOL
         1zyA==
X-Gm-Message-State: AJcUukdsVrSwlv2yCS8PfUblrQagiQXbprZYxrYOYzE4s9g0y53p8PNH
        vtJO+f4Rq/w/rvICK2AIPx6Xo2p7Y44HSQ==
X-Google-Smtp-Source: ALg8bN5sDhVD2i8jWcakrAQ4ojASB1l81vB0zwTVlCuZKGYXzHO071MZw8ln7dlnOhz2wppVrF556g==
X-Received: by 2002:a62:4886:: with SMTP id q6mr34424481pfi.182.1548914009496;
        Wed, 30 Jan 2019 21:53:29 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:28 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 0/5] rsi: wowlan debig support and fixes
Date:   Thu, 31 Jan 2019 11:23:00 +0530
Message-Id: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This set of patches consists wowlan debug support and common fixes
for redpine wireless driver.

Changes in v2:
	02/05: removed ifdefs [Kvalo].

Siva Rebbagondla (5):
  rsi: Add debug support for wowlan wakeup confirmation
  rsi: add hci detach for hibernation and poweroff
  rsi: fix wowlan wakeup issue for hibernate(S4)
  rsi: resolve power save issue after S4 resume
  rsi: fix for wowlan wakeup failure

 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 21 ++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 17 ++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  6 ++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 5 files changed, 70 insertions(+), 4 deletions(-)

-- 
2.5.5

