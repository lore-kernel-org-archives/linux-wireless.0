Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBEBC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4B32082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 21:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A4B32082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbeJ3GWC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:22:02 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51976 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbeJ3GWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 02:22:02 -0400
Received: by mail-wm1-f53.google.com with SMTP id 143-v6so9697546wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2018 14:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lc5woJAhc4ZiWupJU7/sDp4/LfIwlM2icwrL+U0HDO4=;
        b=oY4JKIR1aS7jHgQHmEDAIYstNg0+aarcvO75/JcIB21C3/dUH4Y0dmVBaCwaJrNFOD
         NnSeGp6go8nLwVvk499ZGtTWEdDIyKRzGV64hOL7AZGxmlPlVx3lj3QaHF9NrCqvNZpg
         CRO03Cf911KnDiA0DrJgwJxB9zD1MPRX65rUtV7aBMQHhixZTITqxEYa0UMWT25cQ18M
         rbDFANDbFlXYm15hv/ohqd82zTSXWUspwTe7vyHM0kTLjZE3GEaYBncjLed38EiQ+dnr
         J2nrQ4igVr52HgK0CurJhfuMdbMydFu5tj00QcjZezON2MXNNGeqSnyuLVkV90Dtak6+
         Enow==
X-Gm-Message-State: AGRZ1gJUyss1fM8Bcab9Y7pyz/lOCBN80EKZxHbvJFzisDIuW5i8C8gn
        LEDiZXMDTfK3AjR4L85mNq0xHw==
X-Google-Smtp-Source: AJdET5dfAKuC/8i2iy1+rBk6vzGztXn+hQ7IhBWYPkEeBpC8Gsk+U3J95t536NVeJUvcPEImdrGK4A==
X-Received: by 2002:a1c:90cc:: with SMTP id s195-v6mr14386555wmd.53.1540848691395;
        Mon, 29 Oct 2018 14:31:31 -0700 (PDT)
Received: from localhost.localdomain ([151.66.3.112])
        by smtp.gmail.com with ESMTPSA id c18-v6sm14814981wrr.74.2018.10.29.14.31.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 14:31:30 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mt76x0: add tssi calibration support
Date:   Mon, 29 Oct 2018 22:31:22 +0100
Message-Id: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce tssi calibration support in mt76x0 driver.
Configure tx power gain according to tssi calibrated value
if available

Lorenzo Bianconi (3):
  mt76: move mt76x02_eeprom_copy in mt76x02-lib module
  mt76x0: phy: introduce tssi calibration support
  mt76x0: phy: use tssi reported value to configure tx power if
    available

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  20 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 357 +++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   3 +
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   |  12 +
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   5 +
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  15 +-
 6 files changed, 391 insertions(+), 21 deletions(-)

-- 
2.19.1

