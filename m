Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:42896 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeBXPyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 10:54:21 -0500
Received: by mail-wr0-f194.google.com with SMTP id k9so16950829wre.9
        for <linux-wireless@vger.kernel.org>; Sat, 24 Feb 2018 07:54:21 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] add {set,get}_antenna callbacks
Date: Sat, 24 Feb 2018 16:54:11 +0100
Message-Id: <20180224155414.31063-1-lorenzo.bianconi@redhat.com> (sfid-20180224_165425_428639_80FA8E07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce mac80211 {set,get}_antenna callbacks to configure
{tx,rx} antennas used by the device. Possible values are:
- 1: to use only the primary antenna
- 2: to use only the secondary antenna
- 3: to use both of them

Lorenzo Bianconi (3):
  mt76: initialize available_antennas_{tx,rx} info
  mt76: add mt76_init_stream_cap routine
  mt76x2: add mac80211 {set,get}_antenna callbacks

 drivers/net/wireless/mediatek/mt76/mac80211.c    | 68 ++++++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt76.h        |  3 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  3 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 36 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c  | 55 +++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h |  2 +
 7 files changed, 135 insertions(+), 33 deletions(-)

-- 
2.16.2
