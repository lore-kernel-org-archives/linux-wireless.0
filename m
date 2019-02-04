Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA2CC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2181A2177E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdSQUVHY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfBDGds (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:33:48 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43812 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGdr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:33:47 -0500
Received: by mail-pg1-f178.google.com with SMTP id v28so5836174pgk.10
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=evbDDDUq6nnqNpGt6rc4ktpvBJm638HmGnooJXOvDf8=;
        b=SdSQUVHYAs0SlR6u2ZcgOdWHeGvdBZqEjQM1di1hfPVDVPvBxq61FInld+DgdKWNt9
         1IAchK6Y0euiFAu8/WYTAyj6lMIm3sQzdDBrlYlRBxrm81AzPWmBU+aIGjBtGz4LtlS0
         M6HxMtG78xzv68xKpJHBygSFXKfikZDyFdV7cWozAxvZIlB6ZEo0nCk39z9KLWI5bkW6
         LCTp5PJ/WRLCKxlVCEczmVM/ancWydM2zRPsZWsEZJ5rmnyJe8njOzkDZM51c9j6fbOl
         tFV0jhjNJnZ0k3nOqJeisLSPeVaWr0dqmirRi74Yspl6gzDPvziw6XFRdXFDCEUwz9CV
         WEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=evbDDDUq6nnqNpGt6rc4ktpvBJm638HmGnooJXOvDf8=;
        b=Iioxug4Vxop3byaVUQcgZgRFDjbxlxyRtRkS9EF3Kd/2xU4NjZxI68ML7Ft2CpNeen
         b/XGSNDON0UL2gbl2DBWjXro6lD5+EQLiAwJw8oVCHxvQVeFwjgnM8tZ96qLtkGjQ6Yb
         B/QphgJH1mwf+5wItLvbAvwqyqWqcf/s+EbLEA00OBKpsNCKEmR/sdQkVWy9+BjEbrwa
         3oSQfjENfltXIAd4vvHVD/v8EVR4CIkRz2iLHdyqsH0eWeElAgrq2ogwu0o3xm6pVr4p
         MyH3pBGp8b4bvN7F0eQKniCOo50EtIgvjs7U4wbK4ZRKAXKuWTHpZSfOEjtVWGm8jK/A
         02tQ==
X-Gm-Message-State: AHQUAuZmEb7U2896ochRGmd0JhrmjjG4mYrpWSmaJVFJzUZyYtTNA1QP
        9DU4mGEyZobAdW13nTRZFo8=
X-Google-Smtp-Source: AHgI3IZ/0wzxKaFIkjtd082hhS+JA7+JR7gwvfCbKYHNizOSryw5GdlcY4a9FjLnGwQz13s830cCQQ==
X-Received: by 2002:a63:dc54:: with SMTP id f20mr11986588pgj.410.1549262026895;
        Sun, 03 Feb 2019 22:33:46 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.33.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:33:46 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 0/5] wowlan debug support and fixes
Date:   Mon,  4 Feb 2019 12:03:24 +0530
Message-Id: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This set of patches consists wowlan debug support and common fixes
for redpine wireless driver.

Changes in v3:
	Patch [02/05]: Addressed kbuild test failure by adding
		       IS_ENABLED(CONFIG_RSI_COEX).
Changes in v2:
	Patch [02/05]: Removed ifdef's [KValo].

Siva Rebbagondla (5):
  rsi: Add debug support for wowlan wakeup confirmation
  rsi: add hci detach for hibernation and poweroff
  rsi: fix wowlan wakeup issue for hibernate(S4)
  rsi: resolve power save issue after S4 resume
  rsi: fix for wowlan wakeup failure

 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 21 ++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 20 +++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  7 +++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 5 files changed, 74 insertions(+), 4 deletions(-)

-- 
2.5.5

