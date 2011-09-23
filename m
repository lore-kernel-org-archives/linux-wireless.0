Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59396 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753616Ab1IWN0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 09:26:21 -0400
Received: by mail-gx0-f174.google.com with SMTP id 6so3502626gxk.33
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 06:26:18 -0700 (PDT)
Subject: pull request: wl12xx 2011-09-23
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 16:26:14 +0300
Message-ID: <1316784374.4051.13.camel@cumari> (sfid-20110923_152625_033337_767D1147)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Yet another pull request for 3.2, most likely the last (unless it takes
longer than normal for the merge window to open).  We have some fixes,
including an out-of-bounds array read and some P2P stuff, a fix in the
scanning code (where passive scans were not working properly) and some
other small things, like support for hidden SSID in AP mode.

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks! 


The following changes since commit ed46fdfc54d2d4523fdd727708fe0b9e2be993cc:

  nfc: NFC_WILINK depends on NFC_NCI (2011-09-21 16:19:44 -0400)

are available in the git repository at:
  git://github.com/lucacoelho/wl12xx.git for-linville

Arik Nemtsov (3):
      wl12xx: AP mode - support hidden SSID
      wl12xx: correct fw_status structure for 8 sta support in AP-mode
      wl12xx: report the stop_ba event to all STAs in AP-mode

Eliad Peller (5):
      wl12xx: remove TIM ie from probe response
      wl12xx: remove P2P ie from probe response
      wl12xx: send all pending packets on channel change
      wl12xx: Use dev_hlid for auth and assoc req
      wl12xx: implement set_bitrate_mask callback

Luciano Coelho (1):
      wl12xx: fix forced passive scans

Shahar Levi (2):
      wl12xx: fix sdio_test module functionality
      wl12xx: Include OFDM rates in IBSS mode

 drivers/net/wireless/wl12xx/Makefile    |    6 +-
 drivers/net/wireless/wl12xx/cmd.c       |   43 ++++---
 drivers/net/wireless/wl12xx/conf.h      |    6 +-
 drivers/net/wireless/wl12xx/event.c     |    2 +-
 drivers/net/wireless/wl12xx/init.c      |   17 ++-
 drivers/net/wireless/wl12xx/main.c      |  201 ++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/scan.c      |   42 +++++--
 drivers/net/wireless/wl12xx/sdio_test.c |   15 ++-
 drivers/net/wireless/wl12xx/tx.c        |   38 +++----
 drivers/net/wireless/wl12xx/tx.h        |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h    |    5 +-
 11 files changed, 274 insertions(+), 106 deletions(-)


-- 
Cheers,
Luca.




