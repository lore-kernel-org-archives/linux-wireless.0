Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B640C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0CDE20883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfDILhX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:22 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64F6C307D96F;
        Tue,  9 Apr 2019 11:37:22 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CECB64285;
        Tue,  9 Apr 2019 11:37:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 00/21] RT3883 support from OpenWrt
Date:   Tue,  9 Apr 2019 13:36:47 +0200
Message-Id: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 09 Apr 2019 11:37:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Upstream RT3883 support patches cared by openwrt for quite
a while now.

Patches do not contain the changelog and generate this checkpatch.pl
warning:

WARNING: Missing commit description - Add an appropriate one

but I do not see much sense for fixing that.

Gabor Juhos (21):
  rt2x00: rt2800lib: enable support for RT3883
  rt2x00: rt2800lib: add rf_vals for RF3853
  rt2x00: rt2800lib: enable VCO calibration for RF3853
  rt2x00: rt2800lib: add channel configuration function for RF3853
  rt2x00: rt2800lib: enable RF3853 support
  rt2x00: rt2800lib: add MAC register initialization for RT3883
  rt2x00: rt2800soc: fix rt2800soc_disable_radio for RT3883
  rt2x00: rt2800lib: add BBP register initialization for RT3883
  rt2x00: rt2800lib: add RFCSR initialization for RT3883
  rt2x00: rt2800lib: use the extended EEPROM map for RT3883
  rt2x00: rt2800lib: force rf type to RF3853 on RT3883
  rt2x00: rt2800lib: add channel configuration code for RT3883
  rt2x00: rt2800lib: fix txpower_to_dev function for RT3883
  rt2x00: rt2800lib: use correct txpower calculation function for RT3883
  rt2x00: rt2800lib: hardcode txmixer gain values to zero for RT3883
  rt2x00: rt2800lib: use correct [RT]XWI size for RT3883
  rt2x00: rt2800lib: fix antenna configuration for RT3883
  rt2x00: rt2800lib: fix LNA gain configuration for RT3883
  rt2x00: rt2800lib: fix VGC setup for RT3883
  rt2x00: rt2800lib: fix EEPROM LNA validation for RT3883
  rt2x00: rt2800lib: fix txpower compensation for RT3883

 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  19 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 598 ++++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c |   9 +-
 3 files changed, 607 insertions(+), 19 deletions(-)

-- 
2.7.5

