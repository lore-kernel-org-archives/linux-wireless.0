Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA799C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8312082A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A8312082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbeJAXhI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:37:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36609 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXhI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 19:37:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id n23-v6so9500071wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 09:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wQdeBFTgUY8+AnbMaTtA7GeDqasGiXiIffOKPzBoyTc=;
        b=AOxlIINNwNN1mTk537AuqgjYAtesX6IU9vsHi1R+0cSkG1rVgdogdApfuL+QXTOeDU
         5LPIOG8aFhQlnvsczVw2SeekR/QeQ29SlZW2uZALjijjDEZpK1BH7D8nvCXNhw0Ycoe2
         pWvePyK7XitB2mdg6c+dlyc4C+rmOOEzflYBLCVTAqyT6UC4UFmVyBE/wsygL9oQQF2X
         dFyG6PfhRQOcOfuKmjTELgn7k9Jx6rJrvmBHtJUq2D/zAbc57uu/On4GS7DT1yNhK69f
         nelce4Phl0/4aNLWS2kLvl51zyF4qTA0d3oxHUhGHO/ozmPXWl8JxKEcTLPBAqgpPcjb
         PlLA==
X-Gm-Message-State: ABuFfohqqp35rBl5JHuPHpfa0nrWvH2iWzgVRGRV8aRxuemCuXgFUkG/
        rdbAdrEjdc2ibukkkAE1iN4m0g==
X-Google-Smtp-Source: ACcGV63B2nu1oCP67c7cTgt57ejbktS05BHQjgVE+9YxtoF325aiIQTwM92qkTTk794niarg8X/yeQ==
X-Received: by 2002:a1c:f313:: with SMTP id q19-v6mr4077915wmq.87.1538413104334;
        Mon, 01 Oct 2018 09:58:24 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b2-v6sm5057600wru.51.2018.10.01.09.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 09:58:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] unify txwi parsing between mt76x0 and mt76x2 drivers
Date:   Mon,  1 Oct 2018 18:58:16 +0200
Message-Id: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_write_txwi routine in mt76x02-lib module in order to
unify txwi parsing between mt76x0 and mt76x2 drivers.
For rxwi unification we need to merge mt76x2_dev and mt76x0_dev in
mt76x02_dev and remove duplicated code

Changes since RFC:
- drop patch 1/5 ("mt76: introduce is_mt76x2 routine")
- use chainmask in mt76x02_mac_write_txwi instead of is_mt76x2
  routine

Lorenzo Bianconi (4):
  mt76: move mt76x02_tx_get_max_txpwr_adj in mt76x02_util.c
  mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
  mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
  mt76: usb: use mt76x02u_tx_prepare_skb to fill txwi

 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 +-
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
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  4 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    | 46 +-----------
 .../wireless/mediatek/mt76/mt76x2/usb_core.c  | 53 --------------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  3 +-
 21 files changed, 167 insertions(+), 248 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c

-- 
2.17.1

