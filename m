Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38498 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab2FUONX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:23 -0400
Received: by eaae11 with SMTP id e11so297832eaa.23
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:20 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 00/12] wlcore/wl18xx: patches for 3.6
Date: Thu, 21 Jun 2012 17:12:59 +0300
Message-Id: <1340287991-15241-1-git-send-email-coelho@ti.com> (sfid-20120621_161400_943484_70D4CA1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are some patches for 3.6.  Just a few bugfixes and improvements
here and there, nothing really major.

I'll push this into my tree soon, unless I get some comments pretty
soon. :)

Cheers,
Luca.

Arik Nemtsov (8):
  wlcore: suppress error message on Rx BA session removal
  wlcore: allow setting sleep_auth before interface init
  wlcore: reconfigure sleep_auth when removing interfaces
  wl18xx: increase Rx descriptors for PG2
  wl18xx: set Tx align quirk for PG2
  wl18xx: explicitly remove the 5Ghz MIMO HT cap
  wl18xx: sane defaults for HT capabilities
  wl18xx: split siso40 HT cap between 2Ghz and 5Ghz

Igal Chernobelsky (1):
  wlcore: read FW logs from FW memory on watchdog recovery

Luciano Coelho (2):
  wlcore: add a debugfs entry to allow changing the sleep mode by hand
  wl18xx: use %zu for size_t arguments in printk calls

Yoni Divinsky (1):
  wlcore: do not report noise level in get survey op

 drivers/net/wireless/ti/wl12xx/main.c    |    7 +-
 drivers/net/wireless/ti/wl18xx/main.c    |  106 +++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/acx.c     |    8 ++-
 drivers/net/wireless/ti/wlcore/acx.h     |    5 ++
 drivers/net/wireless/ti/wlcore/conf.h    |    8 ++-
 drivers/net/wireless/ti/wlcore/debugfs.c |   63 ++++++++++++++++++
 drivers/net/wireless/ti/wlcore/init.c    |   43 ++++++------
 drivers/net/wireless/ti/wlcore/main.c    |   68 +++++++++++++------
 drivers/net/wireless/ti/wlcore/ps.c      |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h  |   10 +++
 10 files changed, 227 insertions(+), 93 deletions(-)

-- 
1.7.10

