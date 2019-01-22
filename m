Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3309FC41518
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C55320870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfAVMik (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29083 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:38:40 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 153CF7D0F4;
        Tue, 22 Jan 2019 12:38:40 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BD815D6A9;
        Tue, 22 Jan 2019 12:38:39 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
Date:   Tue, 22 Jan 2019 13:38:30 +0100
Message-Id: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 22 Jan 2019 12:38:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There ware several bugs introduced in 4.20 development cycle
for mt76x0 driver, that were fixed later but missed 4.20 
release. This patche set fixes issues for MT7610U and
MT7630E.

Bug reference:
https://bugzilla.kernel.org/show_bug.cgi?id=202243

Lorenzo Bianconi (1):
  mt76x0: phy: unify calibration between mt76x0u and mt76x0e

Stanislaw Gruszka (6):
  mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
  mt76x0: use band parameter for LC calibration
  mt76x02: run calibration after scanning
  mt76x02: assure we update gain after scan
  mt76x0: do not perform MCU calibration for MT7630
  mt76x0: antenna select corrections

 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |   5 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 170 +++++++--------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |   1 +
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |   1 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   3 +
 9 files changed, 76 insertions(+), 125 deletions(-)

-- 
1.9.3

