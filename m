Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFFFC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09F86214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDWKhN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:37:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfDWKhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 06:37:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 21B0E307C941;
        Tue, 23 Apr 2019 10:37:13 +0000 (UTC)
Received: from localhost (ovpn-204-59.brq.redhat.com [10.40.204.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A08260C64;
        Tue, 23 Apr 2019 10:37:10 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 0/3] mt76: suspend/stop/removal fixes
Date:   Tue, 23 Apr 2019 12:37:06 +0200
Message-Id: <20190423103709.7272-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 23 Apr 2019 10:37:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes for some coroner cases during suspend/stop/removal intended to
-next since problems are not reproducible in practice and changes
relay on -next patches.

Stanislaw Gruszka (3):
  mt76x02u: remove bogus stop on suspend
  mt76usb: fix tx/rx stop
  mt76x02: remove bogus mutex usage

RFC -> v1:
- remove uneeded goto
- fix comments and changelog
v1 -> v2
- actually sent updated patches

 drivers/net/wireless/mediatek/mt76/mac80211.c |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  7 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  6 --
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 33 ++------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  5 --
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   | 10 +--
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  1 -
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 11 +--
 drivers/net/wireless/mediatek/mt76/usb.c      | 78 +++++++++++++------
 9 files changed, 74 insertions(+), 80 deletions(-)

-- 
2.20.1

