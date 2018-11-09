Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8900C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E6420827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8E6420827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbeKIUAZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbeKIUAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:00:25 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CDB880516;
        Fri,  9 Nov 2018 10:20:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A8385C219;
        Fri,  9 Nov 2018 10:20:23 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 0/5] mt76x02: bssid setup corrections for STA
Date:   Fri,  9 Nov 2018 11:20:09 +0100
Message-Id: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 09 Nov 2018 10:20:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Minor MBSS and beaconing fixups. On top of:
"mt76x2u: init: remove mt76x2u_init_beacon_offsets routine"

Stanislaw Gruszka (5):
  mt76x02: correct set bssid for STA
  mt76x02: initalize mutli bss mode by default
  mt76x2u: use common mt76x02_add_interface
  mt76x02: minor beaconing init changes
  mt76x02: remove no longer actuall comment

 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  7 ++++
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 29 +++++++++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 39 ++++++----------------
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   | 12 +++++--
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   | 15 +--------
 9 files changed, 54 insertions(+), 56 deletions(-)

-- 
1.9.3

