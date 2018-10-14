Return-Path: <SRS0=Y2GN=M2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACF6C71122
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8FA82064E
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Oct 2018 18:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8FA82064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbeJOCJc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 22:09:32 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:54024 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbeJOCJc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 22:09:32 -0400
Received: by mail-wm1-f54.google.com with SMTP id y11-v6so16673987wma.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2018 11:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VoWNQLuVDHYgGCkNtB02NqObwjVJQ2/uJFwksLVPHeY=;
        b=bdASSju2VEUqbrN9XbLlSdcPI74gI9MViEejKJwE2yrgCMb1XBzwKzeIXveMt2sFPu
         YVPWZp7/Td8bPHb4tXbv7LBv9xFNqhLbERoPJi4m1JALa1DaYfjylKIVseGYP04d2z/E
         RiYiG/kVeF+2/gvmrmXax3cZDk2nD8NcXHSNlRlL4fV7/aQc8PtjEs+9KSqA3EdN17Eq
         d1f+F1/Cr6TnYyVMNzIpDj3MJ7SRi/HMeDM9PC3L5cvWbcW7cYwAAUSWGMbRMSvYrXPT
         yrtu9YeWaFmiq16ArRMa/PxlkcXo7Nw0y0UMCHDDoGEKsEGBXGw3vhbj8rKUUcOPHet4
         84Fw==
X-Gm-Message-State: ABuFfojrZ4aqdvinwBNvnFEhai2inEKNnpvZ5na/Zwb6HlD6m1xl2RK8
        uKrQnxXXcRlG7cb4KxldW/FYcw==
X-Google-Smtp-Source: ACcGV61M/vYyObr6lg3Wa+6UV1jpwc+oBLUQpJFqY6vKkQRQ2AaY8+FlPJwo13O/ZLUSqfNEesCDOQ==
X-Received: by 2002:a1c:a794:: with SMTP id q142-v6mr11597809wme.77.1539541657844;
        Sun, 14 Oct 2018 11:27:37 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id s7-v6sm15439321wmd.0.2018.10.14.11.27.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Oct 2018 11:27:37 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] update firmware used on mt76x2u driver
Date:   Sun, 14 Oct 2018 20:27:26 +0200
Message-Id: <cover.1539541196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Align mt76x2 pcie/usb firmware.
Update vga logic on mt76x2u driver

Changes since v1:
- remove mt76x2u_mcu_set_dynamic_vga routine

Lorenzo Bianconi (2):
  mt76x2: align mt76x2 and mt76x2u firmware
  mt76x2u: align channel gain logic to mt76x2 one

 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   |   1 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   |  21 ----
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  90 --------------
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 111 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  28 +----
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  41 +------
 9 files changed, 118 insertions(+), 184 deletions(-)

-- 
2.19.0

