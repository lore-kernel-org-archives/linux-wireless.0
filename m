Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CFDC43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4925206B8
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4925206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbeI3AO2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 20:14:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34923 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbeI3AO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 20:14:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id o18-v6so4986592wmc.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 10:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w575vywsZR2kgOo9j60KOvs8o8J+rkSrdABCYN9sfBc=;
        b=bYpULvkT6upCsvXr7KSc+Vz/RrFwonUSD6ABoJH0ZLY0o+wtsUBIwSL5i5m59wbAX1
         6N5MI0eEWCvJ3U/g1lF4z2itsFNKUc1tFW4a7k1jbQ2hOJTSSmePHgY94McXapWgQsm5
         Zh4ZfLARdWYVrTGoYdE4oqSZjx2MVwuBPaiIqIN6va9vETyDFi4wXOuQ+ImBPOsJXuL+
         jt2ykbUtAtI9MLB9xfF/3oAiE25z8IPfryIlX2tq/G+W3/pGO0AGhcok0bT7NlfNDok4
         7bB0LdCZydA380Gd1ntQpj/CPSsEFB2CgDEPTuKvWk77Mu3HkjjzZvSl1Jrtz0ZyZKn1
         q2ZQ==
X-Gm-Message-State: ABuFfogiQOLGE1/fTBztiHE7FjOEUp7h28DIt1zKzwolAQzTPe23ZV45
        2Hn0HwVXQDRKvBpLtNPACM78aA==
X-Google-Smtp-Source: ACcGV61ViA2zh0cjgvSg/eZ9ME/26RkVAx0c5vmnec8NYNAJY82iirHEGGYutWBQRCJR+L7JpZhKBQ==
X-Received: by 2002:a1c:aacd:: with SMTP id t196-v6mr4643120wme.121.1538243109661;
        Sat, 29 Sep 2018 10:45:09 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e14-v6sm10845021wrs.69.2018.09.29.10.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 10:45:09 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/5] unify txwi parsing between mt76x0 and mt76x2 drivers
Date:   Sat, 29 Sep 2018 19:44:51 +0200
Message-Id: <20180929174456.995-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_write_txwi routine in mt76x02-lib module in order to
unify txwi parsing between mt76x0 and mt76x2 drivers.
rxwi unification is currently in progress since we need to unify
mt76x2_dev and mt76x0_dev in mt76x02_dev and remove duplicated code

Lorenzo Bianconi (5):
  mt76: introduce is_mt76x2 routine
  mt76: move mt76x02_tx_get_max_txpwr_adj in mt76x02_util.c
  mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
  mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
  mt76: usb: use mt76x02u_tx_prepare_skb to fill txwi

 drivers/net/wireless/mediatek/mt76/mt76.h     | 17 ++++-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  5 --
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    | 38 ----------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 17 +----
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 72 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  8 +--
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  5 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 38 +++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 45 +++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  2 +
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 60 ----------------
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  3 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  9 +--
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  4 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    | 46 +-----------
 .../wireless/mediatek/mt76/mt76x2/usb_core.c  | 53 --------------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  2 +-
 24 files changed, 184 insertions(+), 257 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c

-- 
2.19.0

