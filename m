Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF2FC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6142084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC6142084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbeJEEso (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:48:44 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:54492 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbeJEEso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 00:48:44 -0400
Received: by mail-wm1-f50.google.com with SMTP id r63-v6so36644wma.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 14:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=if7BQhKCFPOIPV4AGppfrnFZvELCK/w1wYhfogf61MI=;
        b=E1mcs/F4ijNwtr1drssb4aeNRbJv3TtXaZ3Qnd3pNErMwxfCG2/VAqPre2kJ+78utS
         YKA52dIefjbjqres3TV7qDg9pl2C2QsaqMdnUymiXsY6xVjJ05Qg5FZbl2GGkoq/h24h
         /4TvQ8CO49fP66TX1BffyX8OMYZk1EW/u/xz3+n5heKGhgjHCM2Lucg8foL6YjR6nHPP
         M4HP8Kvr9/A0iBqjB4z7LxRE8Rartf7XL+g08qePYGGfMEeUj6pSHCSBjT82tG38p0kx
         beE93CNCApR6aKrPqP7UsD5KGPk8izApWqWnOvm5/Rl3KVuKL1MYi86/aIlu6u0fZUMu
         QbUg==
X-Gm-Message-State: ABuFfog8/QAnr30LYio/Xf/TkXVYPeq//DqNQ88bZOb5qxV4xvw12MNy
        uNrWkbfiVPJ/io/z71cM+YbeMDn5fmc=
X-Google-Smtp-Source: ACcGV63D3vm5U/UL1fhkXry71q8HzxUAZj0dBOQhRk4qPoPBSVANA/X47m2jTmb40UIsx2zBnKWuew==
X-Received: by 2002:a1c:1694:: with SMTP id 142-v6mr6083601wmw.113.1538690001946;
        Thu, 04 Oct 2018 14:53:21 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e6-v6sm5696189wrc.70.2018.10.04.14.53.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 14:53:21 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/10] unify rxwi parsing between mt76x0 and mt76x2 drivers
Date:   Thu,  4 Oct 2018 23:53:02 +0200
Message-Id: <20181004215312.3094-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Merge mt76x0_dev and mt76x2_dev in mt76x02_dev and remove duplicated code.
Move mt76x02_mac_process_rx routine in mt76x02-lib module in order to
unify rxwi parsing between mt76x0 and mt76x2 drivers.
Move mt76x02_tx in mt76x02-lib module and remove duplicated code

Changes since v1:
- make mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid inline

Lorenzo Bianconi (10):
  mt76: move mt76x02_phy_get_min_avg_rssi in mt76x02_phy.c
  mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in
    mt76x02_util.h
  mt76x0: mac: use sta ewma estimation for rssi tracking
  mt76x0: remove unused variable in mt76x0_dev
  mt76x0: remove hw_atomic_mutex mutex in mt76x0_dev
  mt76x2: move mt76x2_dev in mt76x02_util.h
  mt76x0: merge mt76x0_dev in mt76x02_dev
  mt76: move mt76x02_mac_process_rx in mt76x02-lib module
  mt76: unify rxwi parsing between mt76x2 and mt76x0 drivers
  mt76: move mt76x02_tx in mt76x02-lib module

 .../wireless/mediatek/mt76/mt76x0/Makefile    |   2 +-
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  28 ++--
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  18 +--
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  41 ++---
 .../wireless/mediatek/mt76/mt76x0/initvals.h  |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |  78 +---------
 .../net/wireless/mediatek/mt76/mt76x0/mac.h   |  20 ---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  16 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   8 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    | 127 +++------------
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  18 +--
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 112 +++++---------
 .../net/wireless/mediatek/mt76/mt76x0/trace.h |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |  63 --------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  24 +--
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76x02_dfs.h  | 140 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 104 +++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   4 +
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  48 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  53 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h | 119 ++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   3 +-
 .../wireless/mediatek/mt76/mt76x2/common.c    |  42 -----
 .../wireless/mediatek/mt76/mt76x2/debugfs.c   |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   | 134 +---------------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  40 ++---
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2/init.c  |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 126 +--------------
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  21 ++-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.h   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    | 145 +++++-------------
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  38 ++---
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   | 139 ++++++++---------
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  40 ++---
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  27 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  28 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  31 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  65 ++------
 .../net/wireless/mediatek/mt76/mt76x2/trace.h |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    |  33 +---
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   8 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  28 ++--
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   |  12 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  18 +--
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  16 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  13 +-
 57 files changed, 944 insertions(+), 1189 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/common.c

-- 
2.19.0

