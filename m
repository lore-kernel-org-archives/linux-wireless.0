Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35964 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbeF2LlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:41:02 -0400
Received: by mail-wr0-f193.google.com with SMTP id f16-v6so8545760wrm.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 04:41:02 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: [PATCH v2 0/4] add dfs sw pattern detector to mt76x2 driver
Date: Fri, 29 Jun 2018 13:40:51 +0200
Message-Id: <cover.1530260731.git.lorenzo.bianconi@redhat.com> (sfid-20180629_134106_879712_793BC194)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sw DFS pattern detector support for mt76x2 based devices.
Dfs pattern supported:
- short pulse radar patterns
- staggered radar patterns

Changes since v1:
- improve code readability of mt76x2_dfs_fetch_event()
  adding macros for event fields

Lorenzo Bianconi (4):
  mt76: introduce mt76_{incr,decr} utility routines
  mt76x2: dfs: add sw event ring buffer
  mt76x2: dfs: add sw pattern detector
  mt76x2: debugfs: add sw pulse statistics to dfs debugfs

 drivers/net/wireless/mediatek/mt76/mt76.h     |  12 +
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   |   8 +
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   | 377 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.h   |  64 +++
 4 files changed, 458 insertions(+), 3 deletions(-)

-- 
2.17.1
