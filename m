Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:36493 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761141Ab2DKTxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:51 -0400
Received: by lbbgi11 with SMTP id gi11so1204919lbb.24
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 00/24] wl12xx/wl1251/wlcore: reorganize drivers part 2
Date: Wed, 11 Apr 2012 22:53:16 +0300
Message-Id: <1334174020-18957-1-git-send-email-coelho@ti.com> (sfid-20120411_215409_452520_8A2DDADF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

This is the second part of the reorganization we're doing.  After this set, we
can publish the wl18xx driver, which I hope I'll send tomorrow.

The same work as before follows with this series.

Please review.

Cheers,
Luca.

Arik Nemtsov (18):
  wlcore/wl12xx: set the number of Tx descriptors per chip family
  wlcore/wl12xx: change GEM Tx-spare blocks per-vif
  wlcore/wl12xx: add hw op for calculating hw block count per packet
  wlcore/wl12xx: add hw op for setting blocks in hw_tx_desc
  wlcore/wl12xx: add hw op for setting frame length in tx_hw_desc
  wlcore/wl12xx: add global elements to convert hw-rates to standard
    rates
  wlcore: introduce Rx block-size alignment HW quirk
  wlcore/wl12xx: add hw op for getting rx buffer data alignment
  wlcore/wl12xx: add hw op for getting rx packet data length
  wlcore/wl12xx: split Tx completion to immediate/delayed
  wlcore/wl12xx: turn no-Tx-align quirk into Tx-align
  wlcore/wl12xx: add hw op for vif init
  wlcore/wl12xx: expand functionality of cmd_trigger HW op
  wlcore/wl12xx: add hw op to get rate-mask for AP-link in STA mode
  wlcore/wl12xx: set HT capabilities per chip-family
  wlcore: set max_rx_agg_subframes in mac80211 according to HT conf
  wlcore: add module param to prevent HW recovery
  wlcore/wl12xx: adapt FW status for multiple families

Luciano Coelho (6):
  wlcore/wl12xx: add prepare_read hw op for Rx data
  wlcore/wl12xx: add hw_init operation
  wlcore/wl12xx: move runtime configuration struct to the lower driver
  wlcore/wl12xx: move extended radio configuration parameters to wl12xx
  wlcore/wl12xx: use a single memory config and reset if using wl127x
  wlcore/wl12xx: move identify firmware function to a lower driver op

 drivers/net/wireless/ti/wl12xx/Makefile  |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.c     |   53 +++
 drivers/net/wireless/ti/wl12xx/acx.h     |   36 ++
 drivers/net/wireless/ti/wl12xx/cmd.c     |  254 +++++++++++
 drivers/net/wireless/ti/wl12xx/cmd.h     |  112 +++++
 drivers/net/wireless/ti/wl12xx/conf.h    |   50 +++
 drivers/net/wireless/ti/wl12xx/main.c    |  698 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl12xx/wl12xx.h  |   31 ++
 drivers/net/wireless/ti/wlcore/acx.c     |   39 +--
 drivers/net/wireless/ti/wlcore/acx.h     |    8 +-
 drivers/net/wireless/ti/wlcore/boot.c    |   48 +--
 drivers/net/wireless/ti/wlcore/cmd.c     |  230 +----------
 drivers/net/wireless/ti/wlcore/cmd.h     |   82 ----
 drivers/net/wireless/ti/wlcore/conf.h    |   57 +---
 drivers/net/wireless/ti/wlcore/debugfs.c |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h  |  123 ++++++
 drivers/net/wireless/ti/wlcore/init.c    |   48 +--
 drivers/net/wireless/ti/wlcore/main.c    |  551 +++---------------------
 drivers/net/wireless/ti/wlcore/rx.c      |  112 +++---
 drivers/net/wireless/ti/wlcore/rx.h      |   12 +-
 drivers/net/wireless/ti/wlcore/tx.c      |  104 ++---
 drivers/net/wireless/ti/wlcore/tx.h      |    7 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h  |   32 +-
 drivers/net/wireless/ti/wlcore/wlcore.h  |   67 +++-
 24 files changed, 1630 insertions(+), 1127 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/wl12xx.h
 create mode 100644 drivers/net/wireless/ti/wlcore/hw_ops.h

-- 
1.7.5.4

