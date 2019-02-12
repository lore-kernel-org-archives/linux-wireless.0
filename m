Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612BBC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC9221773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549978982;
	bh=f9tz5jiPqwIaqLZQ97BQs61AwNU3SPljmTO9KbQZ8Qs=;
	h=From:To:Subject:Date:List-ID:From;
	b=K+kX3NyLX3ISoALHrupjcNoRXww7Lqf5WbW0gmROeb2AQyAEEnY+gK9pjEcpiXDP2
	 xuDNCBGlMc8rIIqkJWONQkB3Wai92wS6yFyFTDtOWqPadu19qeV0JkdgpVpBpks0dY
	 /APwvwdPbHmf3o7Dn6RscZl+Xu+lii70IL9QaheA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfBLNnB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLNnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:43:01 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E2E21773
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549978980;
        bh=f9tz5jiPqwIaqLZQ97BQs61AwNU3SPljmTO9KbQZ8Qs=;
        h=From:To:Subject:Date:From;
        b=ceq332HTK7RIjBBORmNhsRo6xRYkuVTeCaqhYgFmXMYz0xKT32ZWstJkPG+5/73qa
         GcqxoujeA4tfr+XrkYuIJ3xSk/aJG+izlbKmQLFU45vfs6s6WidKALjJ+nqTH6E4H+
         HFIdrwLjVow0ulvhNbJk2v02KTUnZOc6wDqrtI2Y=
From:   lorenzo@kernel.org
To:     linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 0/4] do not use sg if not properly supported by usb controller
Date:   Tue, 12 Feb 2019 14:42:38 +0100
Message-Id: <cover.1549977282.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Use linear fragment and not a single usb scatter-gather buffer in mt76u
{tx,rx} datapath if the usb controller has sg data length constraints.
Moreover add disable_usb_sg module parameter in order to explicitly
disable scatter-gather. SG I/O is not supported by all host drivers and
some users have reported sg issues on AMD IOMMU.
This series has been tested on AMD IOMMU cpus/motherboards and on rpi3+

Changes since RFC:
- rebased on top of 'fix multiple issues in mt76u error path'
  https://patchwork.kernel.org/cover/10804919/

I am resending the series since the first attempt seems to be rejected by
the ML

Lorenzo Bianconi (4):
  mt76: usb: move mt76u_check_sg in usb.c
  mt76: usb: do not use sg buffers for mcu messages
  mt76: usb: use a linear buffer for tx/rx datapath if sg is not
    supported
  mt76: usb: introduce disable_usb_sg parameter

 drivers/net/wireless/mediatek/mt76/mt76.h     |  14 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |   3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 133 +++++++++++++-----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  |   5 +-
 6 files changed, 105 insertions(+), 54 deletions(-)

-- 
2.20.1

