Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36760 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1JGF7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 01:59:51 -0400
Received: by bkbc12 with SMTP id c12so206180bkb.29
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 22:59:48 -0700 (PDT)
Subject: pull request: wl12xx 2011-10-07
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 08:59:45 +0300
Message-ID: <1317967185.3549.74.camel@cumari> (sfid-20111007_080000_220081_CBE655EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

One more pull-request intended for 3.2.  I hope it makes it in time for
the merge window.  Just a few small things.  First, we use HW-offloaded
channel switch, which solves some FW problems in specific cases.  Then
one missing value in the sched_scan configuration.  One of Eliad's patch
removes an AP-mode quirk, which is not used anymore with the latest FW
we published and one fix to make sure that P2P packets are sent with
OFDM rates. 

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks! 

The following changes since commit d6222fb0d669307a49e2a96aad86c156a9bb9551:

  Merge branch 'master' of git://github.com/padovan/bluetooth-next (2011-10-04 14:06:47 -0400)

are available in the git repository at:

  git://github.com/lucacoelho/wl12xx.git for-linville

Eliad Peller (2):
      wl12xx: configure rate policy for p2p operations
      wl12xx: disable AP-mode-specific quirks

Luciano Coelho (1):
      wl12xx: set max_sched_scan_ie_len correctly

Shahar Levi (1):
      wl12xx: Add support for HW channel switch

 drivers/net/wireless/wl12xx/acx.c    |   16 ++++++++
 drivers/net/wireless/wl12xx/acx.h    |    1 +
 drivers/net/wireless/wl12xx/boot.c   |    6 +--
 drivers/net/wireless/wl12xx/cmd.c    |   63 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/cmd.h    |   20 +++++++++++
 drivers/net/wireless/wl12xx/conf.h   |    6 +++-
 drivers/net/wireless/wl12xx/event.c  |   15 ++++++++
 drivers/net/wireless/wl12xx/main.c   |   48 +++++++++++++++++++++----
 drivers/net/wireless/wl12xx/wl12xx.h |    7 +---
 9 files changed, 158 insertions(+), 24 deletions(-)

-- 
Cheers,
Luca.

