Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828E4C65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B60320882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B60320882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbeJGREL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:04:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36911 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeJGREL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 13:04:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id 185-v6so5561865wmt.2
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZoRNIZckWv/9IotfIBko4UU6B7m9RTptof5nkBBYdhg=;
        b=U1clSipyVVRl6aHb4kq4lEAZlHs8w6vw1kenJnuwR5HOs2RC12YESxlBKZpq2F/JRB
         d2mt4zxoK5BygYLNyHNOu3/NzJ0UteYwS8GqdpS8nd0iTcOo9ZOXkogIIPcyUWWzD1NJ
         2punbJv135vGIvtTxyalcLbgPdGhvRPXOls/Edqc+yISxlseexV35jdnvPbJhuOhy0Tq
         jKOToQddvUX7YeNLlies6CpSt4gEb8FNGckv1Jszm/4l6l9G5F5VuvroAqQ9mT7tFG4y
         CfAizQuYD4sPexO2YqQ/CpIzYbxKt5xxQQ0/tHM0KjE/hurr/nqOBoCV6gGB6I2lEx57
         RvdQ==
X-Gm-Message-State: ABuFfogu0gmiC7brvqmcB2V1aMRY881xi/CKDz/i9BoXnKIIIEPqBgLy
        4ouo+gSQ5aOtv3qBvpPlBWTPcw==
X-Google-Smtp-Source: ACcGV62tEIXbu1rItLqafi2zzFpIxbw6J37QXHekbVgtEMQlMcX7n15A9ISe7jKwKLaKU0gBL6nMsA==
X-Received: by 2002:a7b:c00a:: with SMTP id c10-v6mr12006627wmb.73.1538906245267;
        Sun, 07 Oct 2018 02:57:25 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id a5-v6sm6404631wmh.8.2018.10.07.02.57.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:57:24 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] enable sta mode in mt76x0e driver
Date:   Sun,  7 Oct 2018 11:57:19 +0200
Message-Id: <20181007095722.13577-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable client mode in mt76x0e driver registering the device to the mac80211
layer. Moreover add missing mac80211 callbacks in mt76x0e_ops data structure.
Sta mode has been tested connecting to a 802.11ac AP on 5GHz band

Lorenzo Bianconi (3):
  mt76x0: pci: add missing mac80211 callbacks
  mt76: disable ldpc coding for mt76x0 devices
  mt76x0: pci: add mt76x0_register_device in mt76x0e_register_device

 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 31 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 77 ++++++++-----------
 3 files changed, 70 insertions(+), 45 deletions(-)

-- 
2.19.0

