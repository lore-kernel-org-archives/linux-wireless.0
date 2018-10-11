Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A482C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C842085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33C842085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbeJKQSn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:43 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51717 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:43 -0400
Received: by mail-wm1-f48.google.com with SMTP id 143-v6so8079995wmf.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aPZEwzz4K1JE0pIYYEAxxAV8w0aSurK06gKmfwbNgp4=;
        b=LUgvrIlnpMX+eU2O8d9uTxH2k2LoWWXH32356uLGRt0CZf34NF1GfKFYM2B8DRUSIE
         diEtghavycjvshU6rezQq4AXXb/3pKcMqRuO8Me3ym/AlxocVoqpN0rXZXBG4ek+SNU7
         hqgXqzkizwmThtTy/K6L23m5d1q4JWC2OEF2i5kka/N0N5nDh3aYR0AL5lZ+sGq+kOj/
         SnckH+7xydBwVTtRZZsFT9r/V0h2L4c0J9tH8gQC9d3PMcmH0a9qjC/+0jAK2BiV5NEq
         KDpC1vvRbYsuZyDm0T7IiH2vUY9aNMZW2le3+7HNBrHEbS8gcESn+oecechMgTRVVpYx
         oHWg==
X-Gm-Message-State: ABuFfohfIf6kTJ5KaiwihxEYCSkAkay0uO5pYttkWruxxaD+/rnjXmv9
        9ilIDL/9MDWOiCjf3Cuwox5Izw==
X-Google-Smtp-Source: ACcGV62XfjzcJv2CeoVTp2NgbVJGJ5rZng1ZLQPVuYCaolA3u9oKZ85lse2q+Vggj381X7hynToi/g==
X-Received: by 2002:a1c:af07:: with SMTP id y7-v6mr905343wme.12.1539247942784;
        Thu, 11 Oct 2018 01:52:22 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:22 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 00/12] add calibration logics for mt76x0e driver
Date:   Thu, 11 Oct 2018 10:51:57 +0200
Message-Id: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce vga, temperature and phy calibration routines for
mt76x0e driver. Move phy shared code in mt76x02-lib module.
Moreover do not run calibration during channel switch

Lorenzo Bianconi (12):
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

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |   2 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |   6 +
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  22 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   3 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 238 ++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   5 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  21 --
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  78 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  31 +++
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |   4 +-
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |  21 ++
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  72 +-----
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  44 ----
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |   6 +-
 17 files changed, 306 insertions(+), 253 deletions(-)

-- 
2.17.2

