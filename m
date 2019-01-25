Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA34C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F72F218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQCFnKCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfAYGaR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40780 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGaR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id i12so4262972pfo.7
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tD8js/aTEoCwyVBqEDbdfiP895jL1WMlcYC2LKhdHYQ=;
        b=gQCFnKCMQxYSnL271IcwwbqSMI8Daud65Qrth2gO0jfVwpzUoQI4J/jelSJKifnsEa
         lF9J3I4cArELWTJrHcbtOMKcZR5vvPFS64CXi5TWoZYMi1LThhDlIb8qNwLbGBbXZw9w
         nRBgQA17Krl1xCor3pDnmpCV/XGpi1UchVKZrgzOCQL1YhgvKHtbsfKZ3YapwpoSQG8Y
         gRtIdf1axEqOCN+QU0feZmvjIQAu70XAjfcwaIqaV4a1U0FrtElQzdWNZKCLT+4p1iyf
         eKpKs8gzNSNLpsZND5A8Kwef3gl2C0+02wJgmUBfqNYAdhSgKbSWA8oyZo3tfxVm7nwQ
         /yQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tD8js/aTEoCwyVBqEDbdfiP895jL1WMlcYC2LKhdHYQ=;
        b=iLPM+FlYVwgGuHWjRpiP3dCUeSUXutfcuJPlej/P4fWTxUhDMacVdCfhTLzZ14EpcW
         sa8+XEP1TBHUD5JZcc7d5VP6fHfXWOX+VaECdjr1Vb6eKDAG7MErFu3Z89w1wbi2beBM
         zlumwhm+a5z/71rvm1uwmAl6sU5nty/a3DOfbksng2ZjXVqgSd3uYp5Xv8SIMoTp7DiJ
         4hMkHwV/b6Ezg24GeAvinSyAS4Hx+qaRcDih1RXo2j9z+dpCgG6mIBLI8ICMYIRfk2+S
         /xnty2MMecQ+i8BifG5jItQMA1AFmYO7NL/XP+7fMa3XGfOXtrobBiInYfmvWb2Qx24x
         cK9Q==
X-Gm-Message-State: AJcUukcpX0Fy5XuM+ytgRkAMTnZGuHoHBXA0k0Z4PIS6XDbmVZR6lbqX
        oMohTnF++hdu9K+QoVpNcGQ=
X-Google-Smtp-Source: ALg8bN6BG2k4VXnCQNNwavl6g9KKcQphyXOrII5jCNoiKJqIPdr9kFUo5ApSg6bUBI+7+a1RRtBloQ==
X-Received: by 2002:a62:5f07:: with SMTP id t7mr9652846pfb.108.1548397816474;
        Thu, 24 Jan 2019 22:30:16 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:16 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 0/5] rsi: wowlan debug support and fixes
Date:   Fri, 25 Jan 2019 11:59:57 +0530
Message-Id: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

This set of patches consists wowlan debug support and common fixes
for redpine wireless driver

Siva Rebbagondla (5):
  rsi: Add debug support for wowlan wakeup confirmation
  rsi: add hci detach for hibernation and poweroff
  rsi: fix wowlan wakeup issue for hibernate(S4)
  rsi: resolve power save issue after S4 resume
  rsi: fix for wowlan wakeup failure

 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 21 ++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 23 ++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  6 ++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 5 files changed, 74 insertions(+), 6 deletions(-)

-- 
2.5.5

