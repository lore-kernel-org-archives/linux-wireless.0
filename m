Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CD9C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E9920645
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73E9920645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbeJJQfu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:35:50 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:54522 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJJQft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 12:35:49 -0400
Received: by mail-wm1-f43.google.com with SMTP id r63-v6so4627137wma.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 02:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jcjpa4sgs1TxBglug2E/D9Rl6hQ5IHAPC0hrCQINSFw=;
        b=Kqeb0+P8XdRmXyq3wdgeR+Hz3gS3OO12v6cwsdyKdNdUGjoOLVM2scRAB78kELgl47
         evD81Vo1Hd0cEQ3H2BefiSLhUmnHnIADwoBY7/nyUG5M/CgTNUI3FYEILwPLUODVzF8+
         ubkvZXXI/6aKvhJ8yIwk8uZHq3a21orKeyjnismT2vM49gg2TFnzUdb6tSl1olgVtlge
         bog+QpIabHWDPVubIrGoidwBBMr3L+wM8ZAowMjs/YyJrxUHIhq1NKoJ15Qp+wEgHVi6
         jbSGqAMqe8hNJG+9cbaRll3c7ybylNdxtEJQ9vTZCysDkDCEmZVHXhwpC9fovycgATch
         xrAw==
X-Gm-Message-State: ABuFfohtvJ6d/nu6b20sbNg2rABzYd84BvHaajp2FQFeuyMIEyA6FSVK
        0cgj/PsEL0tLA+0O+EKROY+NgPZgtN0=
X-Google-Smtp-Source: ACcGV60QDJoTvEJ1V40Vssy/4NMaS4N3Q5dQMa+IVU8PfOw+8dJlJ98qLpjz/76Q9b0EeUVANqeHYw==
X-Received: by 2002:a1c:2ec2:: with SMTP id u185-v6mr113971wmu.125.1539162873580;
        Wed, 10 Oct 2018 02:14:33 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 65-v6sm17715106wmm.36.2018.10.10.02.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Oct 2018 02:14:33 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] fix temperature compensation for mt76x0
Date:   Wed, 10 Oct 2018 11:14:20 +0200
Message-Id: <cover.1539162246.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix register configuration during temperature measurements
for mt76x0 devices. Moreover do not run temperature compensation
if tssi is enabled

Lorenzo Bianconi (2):
  mt76x0: eeprom: introduce mt76x0_tssi_enabled routine
  mt76x0: phy: fix mt76x0_temp_sensor routine

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  2 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  6 +++
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 43 +++++++++----------
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 21 ---------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  4 +-
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    | 21 +++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 8 files changed, 53 insertions(+), 50 deletions(-)

-- 
2.17.1

