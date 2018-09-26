Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992E4C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C03E214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C03E214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbeIZQhO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:14 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E51B4300294C;
        Wed, 26 Sep 2018 10:24:58 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F99CDB561;
        Wed, 26 Sep 2018 10:24:58 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
Date:   Wed, 26 Sep 2018 12:24:52 +0200
Message-Id: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.27
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 26 Sep 2018 10:24:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset make rt2800mmio txdone routines the same as rt2800usb.
It should address problems with TX status interrupt handling and
doing txdone for cases when we miss TX statuses from HW. We assume
that for PCIe/SOC we always read TX status in IRQ routine, but this
can be not true for example when CPU is busy with other interrupts.  

It was tested by  with positive feedback, some users report that
patches make MT7620 routers workable for them. This is documented
here: https://bugzilla.kernel.org/show_bug.cgi?id=82751

Stanislaw Gruszka (5):
  rt2800: move usb specific txdone/txstatus routines to rt2800lib
  rt2800mmio: use txdone/txstatus routines from lib
  rt2x00: do not check for txstatus timeout every time on tasklet
  rt2x00: use different txstatus timeouts when flushing
  rt2800: flush and txstatus rework for rt2800mmio

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 154 +++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h   |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  | 277 +++++++----------------
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h  |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c   |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c   | 143 +-----------
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c   |   4 +
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   2 +
 9 files changed, 259 insertions(+), 330 deletions(-)

-- 
2.7.5

