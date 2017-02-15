Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJ31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:29:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 00/10] rt2x00 patches 14.02.2017
Date: Wed, 15 Feb 2017 10:24:31 +0100
Message-Id: <1487150671-3447-1-git-send-email-sgruszka@redhat.com> (sfid-20170215_102930_674375_1C6521DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patches for rt2x00. Most important is txdone functions rework to use
ieee80211_tx_status_noskb() if can not match sent skb with status
from TX_STAT_FIFO. Currently used only for rt2800usb.

v1 -> v2:
Fix skbdesc->sta and TXDONE_ACK_REQ issues pointed by Felix.
Add changelog to patch 6, pointed by Kalle.

Gabor Juhos (1):
  rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h

Stanislaw Gruszka (9):
  rt2800: identify station based on status WCID
  rt2x00: separte filling tx status from rt2x00lib_txdone
  rt2x00: separte clearing entry from rt2x00lib_txdone
  rt2x00: add txdone nomatch function
  rt2x00: fixup fill_tx_status for nomatch case
  rt2x00: use txdone_nomatch on rt2800usb
  rt2800: status based rate flags for nomatch case
  rt2800: use TXOP_BACKOFF for probe frames
  rt2x00: fix rt2x00debug_dump_frame comment

 drivers/net/wireless/ralink/rt2x00/rt2800.h      |  27 +--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   |  67 ++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h   |  27 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c   |  18 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   | 232 +++++++++++++++--------
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h |   4 +-
 9 files changed, 260 insertions(+), 128 deletions(-)

-- 
1.8.3.1
