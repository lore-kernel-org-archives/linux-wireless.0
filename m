Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42283 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab2FWGl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:41:56 -0400
Received: by lbbgm6 with SMTP id gm6so4535866lbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:53 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 00/18] wlcore: improvements in SDIO error handling
Date: Sat, 23 Jun 2012 09:41:11 +0300
Message-Id: <1340433689-24320-1-git-send-email-coelho@ti.com> (sfid-20120623_084200_788861_709F926E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series with patches from Ido and Arik improve the driver's
handling of SDIO errors.  Ido's series propagates the errors up for
better handling and Arik's series ensures that suspend/resume don't
get messed up when such errors occur.

There is also one patch by Arkady (welcome!) that allows the userspace
to read/write to the chip's memory directly for firmware debugging
purposes.

Please review.

Cheers,
Luca.


Arik Nemtsov (6):
  wlcore: cancel suspend when recovery is pending
  wlcore: don't allow SDIO read/writes after failure
  wlcore: force recovery on resume if suspended without recovering
  wlcore: check Rx-filter functions in the suspend path
  wlcore: refactor threaded IRQ routine
  wlcore: prevent recovery in the middle of resume

Arkady Miasnikov (1):
  wlcore: access the firmware memory via debugfs

Ido Yariv (11):
  wlcore: Fix sdio out-of-sync power state
  wlcore: Disable interrupts while recovering
  wlcore: Change read/write ops to return errors
  wlcore: Change raw io functions to return errors
  wlcore: Propagate errors from wlcore_raw_*_data functions
  wlcore: Propagate errors from wl1271_read
  wlcore: Propagate errors from wl1271_write
  wlcore: Propagate errors from wl1271_raw_read32
  wlcore: Propagate errors from wl1271_raw_write32
  wlcore: Propagate errors from wl1271_read_hwaddr
  wlcore: Force checking of io functions' return values

 drivers/net/wireless/ti/wl12xx/main.c     |  343 +++++++++++++++++++++--------
 drivers/net/wireless/ti/wl18xx/io.c       |   39 +++-
 drivers/net/wireless/ti/wl18xx/io.h       |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  219 ++++++++++++------
 drivers/net/wireless/ti/wlcore/boot.c     |   84 +++++--
 drivers/net/wireless/ti/wlcore/cmd.c      |   47 +++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |  192 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/event.c    |   15 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   12 +-
 drivers/net/wireless/ti/wlcore/io.c       |   55 +++--
 drivers/net/wireless/ti/wlcore/io.h       |  144 +++++++-----
 drivers/net/wireless/ti/wlcore/main.c     |  240 +++++++++++++++-----
 drivers/net/wireless/ti/wlcore/ps.c       |   14 +-
 drivers/net/wireless/ti/wlcore/rx.c       |   37 +++-
 drivers/net/wireless/ti/wlcore/rx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |   50 +++--
 drivers/net/wireless/ti/wlcore/spi.c      |   14 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   61 +++--
 drivers/net/wireless/ti/wlcore/tx.h       |    4 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   14 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 +-
 21 files changed, 1196 insertions(+), 405 deletions(-)

-- 
1.7.10

