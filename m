Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B872EC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 20:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C5A2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556312145;
	bh=Y/y5xgWyJ80bHHEijlL7N77Ejy0iuAqIvuKaL1wlHfk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ZUbemZRfmKhdaunlJSuQa3/N+jg8m4Ox/3wz+zNbLt0FSYWpTTVxFKmGBx09LsyMM
	 qNbR33YJbERffmUMrqQ62xHx2Zs1hJSR6QmGKusXbA9S5pmJlYI4eYwQ7y7wdt9mm3
	 cLcMH5yaxBCPR6ACAPx4ajvTKCqYT0Iesp2z3UgY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfDZUzo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfDZUzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 16:55:44 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 955C720679;
        Fri, 26 Apr 2019 20:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556312143;
        bh=Y/y5xgWyJ80bHHEijlL7N77Ejy0iuAqIvuKaL1wlHfk=;
        h=From:To:Cc:Subject:Date:From;
        b=c1yKyGeriuN3RkdL4tlsu/a/+/4cOJ8wm7yK7EtHMYNcriCSpvrlRKIBy/N/tbnEP
         2aeOh5x4ZIrEbYrA4u9SHzZZ3Ryr6KhH3nNwEG4JnDCGVCYREIGLhEWQE10ARbCih9
         gS03hFhJEs6u6WNvgtBkpOw4SeQ/eIt7NLKn6qCM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Subject: [PATCH 0/3] mt76: move common beacon code in mt76 module
Date:   Fri, 26 Apr 2019 22:55:29 +0200
Message-Id: <cover.1556310998.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move beacon data structures shared between mt76x02 and mt7603 drivers
in mt76_dev.
This patch is based on 'mt7603: wait for pre_tbtt_tasklet before scanning'
https://patchwork.kernel.org/patch/10919099/

Lorenzo Bianconi (3):
  mt76: move beacon_int in mt76_dev
  mt76: move beacon_mask in mt76_dev
  mt76: move pre_tbtt_tasklet in mt76_dev

 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 ++++
 .../wireless/mediatek/mt76/mt7603/beacon.c    | 19 ++++++++++---------
 .../net/wireless/mediatek/mt76/mt7603/core.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  4 ++--
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  6 +++---
 .../net/wireless/mediatek/mt76/mt7603/main.c  | 10 +++++-----
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  5 -----
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 ---
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 18 +++++++++---------
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 18 +++++++++---------
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 11 ++++++-----
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  6 +++---
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  4 ++--
 16 files changed, 57 insertions(+), 59 deletions(-)

-- 
2.20.1

