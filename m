Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B781FC6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80D792084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80D792084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbeJZUhk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeJZUhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:37:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19E6730BCCC6;
        Fri, 26 Oct 2018 12:00:51 +0000 (UTC)
Received: from localhost (unknown [10.40.205.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1576860BC6;
        Fri, 26 Oct 2018 12:00:29 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mt76: mcu api clenups
Date:   Fri, 26 Oct 2018 14:00:25 +0200
Message-Id: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 26 Oct 2018 12:00:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simplify mcu api and wait for response for mcu commands the same
as vendor driver.

This is on top of:
[PATCH] mt76x0: use band parameter for LC calibration

Stanislaw Gruszka (4):
  mt76: remove mcu_msg_alloc
  mt76: remove wait argument from mt76x02_mcu_calibrate
  mt76: remove wait argument from mt76x02_mcu_function_select
  mt76: remove wait argument from mt76x02_mcu_set_radio_state

 drivers/net/wireless/mediatek/mt76/mt76.h          |  6 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 16 ++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   | 43 ++++++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   | 16 +++-----
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 18 +++++----
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    | 22 ++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |  3 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    | 24 ++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |  4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mcu.c    |  4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    | 20 +++++-----
 16 files changed, 85 insertions(+), 100 deletions(-)

-- 
2.7.5

