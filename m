Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D320C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA0E218AE
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551432140;
	bh=hQ2R2atuFQsWgPRPT6uN6wlVvxGx8W6rLwnfvtCDDCM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qfWFvPxEYkzvBodXM6lcWFgPihhkvOUR8/k+90iKWA2sGfPy/Sx+yZ4EmlYkZcKSw
	 NXoRFLdAX4zKI3T/5DrCcD9wOUZYP/0F9XEBOzXlU9WFmjdaN9ARcZ9YtsWeKtIs1C
	 l5H+ZKepeCSmmUK/luJqJgrG+lOYX+HZ/o4jO4iU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfCAJWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfCAJWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 04:22:19 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F6C2085A;
        Fri,  1 Mar 2019 09:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551432139;
        bh=hQ2R2atuFQsWgPRPT6uN6wlVvxGx8W6rLwnfvtCDDCM=;
        h=From:To:Cc:Subject:Date:From;
        b=r+2pvDVsU1aYY++duo4R0a8qxjvO8Apktcvuv3DSEp8j9+p4GwYFjqPe5TVXEZc+f
         Z/Akrs8H0AGhxnAwSw9JQRnN0wUPujRDC0bCk0EpThqKu/pvSrMNm9BezKrA5Hauw6
         GOxDPk/I23JqpBnmQQzSO3YkacsmcFiRwvUSbSro=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
        roychl666@gmail.com, lorenzo.bianconi@redhat.com
Subject: [RFC 0/2] introduce mt76_hw_queue data structure
Date:   Fri,  1 Mar 2019 10:22:02 +0100
Message-Id: <cover.1551431791.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76_hw_queue data structure since new chipsets (e.g 7615) rely on
a different tx queue enumeration scheme.
This series implements the approach suggested by Felix in
https://patchwork.kernel.org/cover/10816521/

Lorenzo Bianconi (2):
  mt76: rename mt76_queue pointer occurrences from hwq to q
  mt76: introduce mt76_hw_queue data structure

 drivers/net/wireless/mediatek/mt76/debugfs.c  |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c      | 249 +++++++++---------
 drivers/net/wireless/mediatek/mt76/mac80211.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  36 ++-
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  26 +-
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |  21 +-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  12 +-
 .../net/wireless/mediatek/mt76/mt7603/main.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  38 +--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       |  79 +++---
 drivers/net/wireless/mediatek/mt76/usb.c      | 222 +++++++++-------
 13 files changed, 377 insertions(+), 323 deletions(-)

-- 
2.20.1

