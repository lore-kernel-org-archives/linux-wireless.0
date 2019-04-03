Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D06FC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385112084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2XBiHtC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfDCENX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35958 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfDCENX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck15so6155153plb.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=I8Y/85yS3Gq07h5Gy3WkHUo+WR3GAcABXtvfvXEVGAE=;
        b=N2XBiHtCqLT8nuZra4euQ/FEd/cK1VbfK+cc0FAvopwfIHiiT7xa9w1VXjfZn0AhWq
         kMN1edIhsNyIjT4xHTYDjctxlv14FYglsyH8k7CoLnyA/tyX/0wLK0+LtrKytT17Z1Tl
         +wo6M5YXSNRUMhgyVouGTuuw5qnduTMgoHJfanERedS9K0I9frzHCLn/vFGpjlGlW5cU
         GmKZz5m9ejlSiRoYuPvCDs0FcpXCTtITv5ftRS/mQKSXUWRoLHpBY3n+b+zxWaJLeZmU
         op4f38RRn5OMzU/ksF5NF/M/jCG/ryeGf2qx4w0bVpXpwEHs1r9M7edXpFd2f+vNBXoY
         N5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I8Y/85yS3Gq07h5Gy3WkHUo+WR3GAcABXtvfvXEVGAE=;
        b=s/4ln8r18bCVdOV1yCB9Es152qadro6SAhsBU8XB4HCzV8bYBkpNZWfpwh+87Z9RLH
         fHDDM9wNMvpOgAqut8Jmq/biKFNeH5Jbkcc0Q/hMK3i/EekYtInYoBAPvltvLxE2oGhN
         43erR+kYbu5hPTBqy7Wmkcm8AO1TEcmV9+mS61qIMKUP17grXY1eMGnxU4kRmXswnb/E
         ciuE96qJbRJ4UEsUVkf1aD3RFfiiKHrEapTfwtjs1gQvAT6wj/CXP0E+9wlDroXUicLM
         hR0kfbGLu1vkUSCW3J+l2q+OpaZm1V6xcXmOJ45/RPvuKOKuzJa+oPvpCWT7z+mDZCP1
         0Mzw==
X-Gm-Message-State: APjAAAXcRZ8ao0E6400Lo2Gv7EydRW5rblr0R151nzZOlsFa9qZW/4hb
        Vj+23qg+RpuAX4fJY4CWPEc=
X-Google-Smtp-Source: APXvYqy3crTGG0bKymT2f9RLhKxyG1cnmTxi2N5sok6eXLs3xGUg+oQnt4y/7Ondr7PhR9WCp5M98g==
X-Received: by 2002:a17:902:248:: with SMTP id 66mr75370550plc.286.1554264802326;
        Tue, 02 Apr 2019 21:13:22 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:21 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 0/8] rsi: driver changes for new 9116 chipset.
Date:   Wed,  3 Apr 2019 09:43:01 +0530
Message-Id: <20190403041309.12829-1-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series of patches consists driver changes for new redpine
9116 chipset and some miscallaneous changes.

Siva Rebbagondla (8):
  rsi: add new device model for 9116
  rsi: move common part of firmware load to separate function
  rsi: add firmware loading for 9116 device
  rsi: change in device init frame sequence for 9116
  rsi: new bootup parameters for 9116
  rsi: send new tx command frame wlan9116 features
  rsi: reset device changes for 9116
  rsi: miscallaneous changes for 9116 and common

 drivers/net/wireless/rsi/rsi_91x_hal.c     | 199 ++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 232 +++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c    | 129 ++++++++++--
 drivers/net/wireless/rsi/rsi_91x_usb.c     |  96 ++++++---
 drivers/net/wireless/rsi/rsi_boot_params.h |  63 ++++++
 drivers/net/wireless/rsi/rsi_hal.h         |  44 +++-
 drivers/net/wireless/rsi/rsi_main.h        |  21 +-
 drivers/net/wireless/rsi/rsi_mgmt.h        |  26 +++
 drivers/net/wireless/rsi/rsi_sdio.h        |   5 +-
 drivers/net/wireless/rsi/rsi_usb.h         |   3 +-
 10 files changed, 732 insertions(+), 86 deletions(-)

-- 
2.17.1

