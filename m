Return-Path: <SRS0=74Mc=2M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0A1C2D0C0
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A60620733
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577010817;
	bh=w1tnrpgtpkbsqyfTD5u4m/FzCOENslSHWXFVCL8GOgw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=z3K7LNvxJJ2kqnvZCwtqEeWcYUobS7HJQm7vbA+ZfXXx/kecQ7wGlfRP4TvXZwhCi
	 tuSz4lAfi/yJ61swSOrLMVV+UW+jL9Wcxffk8KFmX+t5DE0pWfuEH5exbYQmNzGz+O
	 GYZ0GDP79AYkMPMsepL0MK3KcQ/zRYlrRnddL+nI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfLVKdf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Dec 2019 05:33:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfLVKdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Dec 2019 05:33:35 -0500
Received: from lore-desk-wlan.lan (unknown [151.66.53.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA7F52070A;
        Sun, 22 Dec 2019 10:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577010814;
        bh=w1tnrpgtpkbsqyfTD5u4m/FzCOENslSHWXFVCL8GOgw=;
        h=From:To:Cc:Subject:Date:From;
        b=x1W9cZHktkE2zKndPvREXT+4tSjXPEMBwfi6Cy1NcPxQXqfwH07ldkWKS2usL9J2W
         ApjS4koVsHwv/fvoGrEYqDS8qgaYv94amNWAe4QzCn0YvKvNt0I+NncJDcj4eBAVVu
         6f7uOjqM3ikgZ39l54TDgs224NcjAp7WrU2s80Yc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH 00/18] rework mt76u layer to support new devices
Date:   Sun, 22 Dec 2019 11:33:02 +0100
Message-Id: <cover.1577010183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rework mt76u layer to support new devices (e.g. 7663u).
The main difference between mt7663u and previous mt76u dongles
(e.g. mt76x2u) is mt7663u reports fw events through a dedicated
mcu hw queue. Moreover, mt7663u relies on full usb 32bit address
space to configure the usb dongle.
This series is based on "mt76: channel switch support for USB devices"
https://patchwork.kernel.org/cover/11301193/

Lorenzo Bianconi (18):
  mt76: mt76u: check tx_status_data pointer in mt76u_tx_tasklet
  mt76: mt76u: add mt76u_process_rx_queue utility routine
  mt76: mt76u: add mt76_queue to mt76u_get_next_rx_entry signature
  mt76: mt76u: add mt76_queue to mt76u_refill_rx signature
  mt76: mt76u: use mt76_queue as mt76u_complete_rx context
  mt76: mt76u: add queue id parameter to mt76u_submit_rx_buffers
  mt76: mt76u: move mcu buffer allocation in mt76x02u drivers
  mt76: mt76u: introduce mt76u_free_rx_queue utility routine
  mt76: mt76u: stop/free all possible rx queues
  mt76: mt76u: add mt76u_alloc_rx_queue utility routine
  mt76: mt76u: add queue parameter to mt76u_rx_urb_alloc
  mt76: mt76u: resume all rx queue in mt76u_resume_rx
  mt76: mt76u: introduce mt76u_alloc_mcu_queue utility routine
  mt76: mt76u: add {read/write}_extended utility routines
  mt76: mt76u: take into account different queue mapping for 7663
  mt76: mt76u: introduce mt76u_skb_dma_info routine
  mt76: mt76u: add endpoint to mt76u_bulk_msg signature
  mt76: mt76u: introduce MT_DRV_RX_DMA_HDR flag

 drivers/net/wireless/mediatek/mt76/mt76.h     |  15 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   8 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  25 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |   9 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   6 +
 drivers/net/wireless/mediatek/mt76/usb.c      | 370 +++++++++++++-----
 7 files changed, 309 insertions(+), 126 deletions(-)

-- 
2.24.1

