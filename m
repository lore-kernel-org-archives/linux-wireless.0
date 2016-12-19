Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757691AbcLSKy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:54:59 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 00/11] rt2800 patches 19.12.2016
Date: Mon, 19 Dec 2016 11:52:46 +0100
Message-Id: <1482144777-16760-1-git-send-email-sgruszka@redhat.com> (sfid-20161219_115556_324768_F9416C4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Random fixes for rt2800 driver.

Stanislaw Gruszka (11):
  rt2800: make rx ampdu_factor depend on number of rx chains
  rt2800: don't set ht parameters for non-aggregated frames
  rt2800: set minimum MPDU and PSDU lengths to sane values
  rt2800: set MAX_PSDU len according to remote STAs capabilities
  rt2800: rename adjust_freq_offset function
  rt2800: warn if doing VCO recalibration for unknow RF chip
  rt2800: perform VCO recalibration for RF5592 chip
  rt2x00: merge agc and vco works with link tuner
  rt2800: replace mdelay by usleep on vco calibration.
  rt2800: replace msleep() with usleep_range() on channel switch
  rt2x00: add mutex to synchronize config and link tuner

 drivers/net/wireless/ralink/rt2x00/rt2800.h      |    2 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   |   79 ++++++++++---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h   |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00lib.h   |   31 +-----
 drivers/net/wireless/ralink/rt2x00/rt2x00link.c  |  132 ++++++----------------
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c   |    8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   12 +-
 9 files changed, 124 insertions(+), 155 deletions(-)
