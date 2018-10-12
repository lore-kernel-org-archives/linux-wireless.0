Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753BFC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 412D320868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 412D320868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbeJLRsY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:24 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:35133 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbeJLRsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:24 -0400
Received: by mail-wm1-f45.google.com with SMTP id e187-v6so12435125wmf.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DdsYjZ1cRgI9ek1R8EMjsa/99PbvPhMD1hl8O9NSqXQ=;
        b=fc/zLRfJYZMd/aW3zlmy2mFn5wWFHWCM/cw9RZnvqPDQ0OFyaPEKArzTd883t2aPMx
         HCsYbYFVJa/wBzNnHjGs52KM7b0Z71rF3ESaUpd4ODa5E0Yr5B0/TFU7at4pfM/DVZpQ
         WHeoPU7/UQ2nHCZV/gE/Qpe/HXzU4QiwBI8pyxYljKwq8mtNkg8YcOVTGIgJwR7CCGOg
         wO53IxMJnhk4LGWp6r8JA8+akE7dPi7XBXZQhub2XcHK9ZAdPYVALE3sUHvT+dkX6UwH
         tZOAJPWaZiJ46yjrlEPqOZvETFyM04lHD93N7L/nYY6sH+xzbXjacjcwPV4EPRs+2rBk
         UrSQ==
X-Gm-Message-State: ABuFfojont1hpRp1oPMiWwlJ5NCdxfyUF4BjHY5SM4htOn5HxhgUiqlG
        xjJ1Nxa6Hf4esBX8ZiDTwZJZ5d9BAKw=
X-Google-Smtp-Source: ACcGV63Iy/k6VJjEFt0O4S0SXJkauzJRBknvSA2QkNHfOmlCMVqdJRw3+Vt05hvh+cS0yEopQUTHRQ==
X-Received: by 2002:a7b:c150:: with SMTP id z16-v6mr4794801wmi.25.1539339401692;
        Fri, 12 Oct 2018 03:16:41 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:41 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] add calibration logics for mt76x0e driver
Date:   Fri, 12 Oct 2018 12:16:16 +0200
Message-Id: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce vga, temperature and phy calibration routines for
mt76x0e driver. Move phy shared code in mt76x02-lib module.
Moreover do not run calibration during channel switch

Changes since rfc:
- run vco calibration during freq scanning
- use mt76x0_phy as prefix for phy routines

Lorenzo Bianconi (13):
  mt76: move mt76x02_phy_set_bw in mt76x02-lib module
  mt76: move mt76x02_phy_set_band in mt76x02-lib module
  mt76x0: pci: rename mt76x0_phy_calibrate
  mt76x0: pci: introduce mt76x0_phy_calirate routine
  mt76x0: phy: update set_channel for mt76x0e devices
  mt76x0: eeprom: introduce mt76x0_tssi_enabled routine
  mt76x0: phy: add phy/vco temperature compensation
  mt76: move rssi_gain_thresh routines in mt76x02-lib module
  mt76: move mt76x02_phy_adjust_vga_gain in mt76/mt76x02_phy.c
  mt76: introduce mt76x02_init_agc_gain routine
  mt76x0: phy: align channel gain logic to mt76x2 one
  mt76x0: phy: do not run calibration during channel switch
  mt76x0: phy: use proper name convetion

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |   2 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |   6 +
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  22 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   3 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   5 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 449 ++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   5 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  21 -
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  78 +++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  31 ++
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |   4 +-
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |  21 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  72 +--
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  44 --
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |   6 +-
 18 files changed, 415 insertions(+), 359 deletions(-)

-- 
2.17.2

