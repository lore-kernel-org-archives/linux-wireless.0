Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295C8C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEEC1218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBILIl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:08:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:08:40 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB93F637E2;
        Sat,  9 Feb 2019 11:08:40 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A11710021B6;
        Sat,  9 Feb 2019 11:08:39 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [RFC/RFT 0/8] rt2x00: performance fixes for mmio
Date:   Sat,  9 Feb 2019 12:08:30 +0100
Message-Id: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 09 Feb 2019 11:08:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Patch series should fix performance regriession and do not reintroduce
tx queue hungs.

Stanislaw Gruszka (8):
  rt2800: partially restore old mmio txstatus behaviour
  rt2800: new flush implementation for SoC devices
  rt2800: move txstatus pending routine
  rt2800mmio: fetch tx status changes
  rt2800mmio: use timer and work for handling tx statuses timeouts
  rt2x00: remove last_nostatus_check
  rt2x00: remove not used entry field
  rt2x00mmio: remove legacy comment

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   |  30 ++++--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h   |   3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  | 124 ++++++++++++++++-------
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h  |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c   |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c   |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c   |  24 +----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |   2 -
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   |   4 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h  |   2 -
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h |   3 -
 12 files changed, 123 insertions(+), 77 deletions(-)

-- 
2.7.5

