Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562A4C4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2462A20863
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534480;
	bh=B24Nt92pyh1aVEZsXH8+rOt3glWFNPI1faXeLglIbwU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=LtyA7qH0iFdI3lXHXTKRA2qvqsIxJPVNJx55Vns7xNT3xCiKhu6ywnM8d/v6VEOnD
	 jbfI0kmZAcDvnvVw7FiMy+FCivY4SiB5yw5H+qURycwex5JzGEPui/Tkwa8cQBTc9b
	 rRGDiGW4OR09xwRulF5cWFcZa28GpoSm0LiyGoho=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfCBNrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfCBNrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:47:51 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE43520838;
        Sat,  2 Mar 2019 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534471;
        bh=B24Nt92pyh1aVEZsXH8+rOt3glWFNPI1faXeLglIbwU=;
        h=From:To:Cc:Subject:Date:From;
        b=q3PkYHXalW+vGprKA5XWz6BLoIvkXrDAa0a19yIMHhlGbIX06yhsgzua+PB7fwB83
         O0Lp3lUAG/w4q0gdwCLSgO3/XV/TEaNOwllrNz46Bj6K5FgiDIWsJTUWvtHi4DHKMm
         xGouZrn6OZiwE4G75lIVbDGnickSIQRmcNFXpwFk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 0/5] introduce mt76_sw_queue data structure
Date:   Sat,  2 Mar 2019 14:47:37 +0100
Message-Id: <cover.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76_sw_queue data structure in order to support new
chipsets (e.g. mt7615) that have a shared hardware queue for all traffic
identifiers. mt76_sw_queue is used to track outstanding packets.
Add mt76_txq_id field to mt76_queue_entry in order to properly
track outstanding frames

Lorenzo Bianconi (5):
  mt76: remove mt76_queue dependency from tx_queue_skb function pointer
  mt76: remove mt76_queue dependency from tx_prepare_skb function
    pointer
  mt76: remove mt76_queue dependency from tx_complete_skb function
    pointer
  mt76: introduce mt76_sw_queue data structure
  mt76: introduce mt76_txq_id field in mt76_queue_entry

 drivers/net/wireless/mediatek/mt76/debugfs.c  |  7 +-
 drivers/net/wireless/mediatek/mt76/dma.c      | 19 +++---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     | 27 ++++----
 .../wireless/mediatek/mt76/mt7603/beacon.c    | 14 ++--
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 13 +++-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 19 +++---
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 23 ++++---
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  6 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 11 ++--
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       | 66 ++++++++++---------
 drivers/net/wireless/mediatek/mt76/usb.c      | 28 +++++---
 19 files changed, 149 insertions(+), 112 deletions(-)

-- 
2.20.1

