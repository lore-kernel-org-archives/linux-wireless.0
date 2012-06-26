Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52698 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab2FZUDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:03:15 -0400
Received: by lban1 with SMTP id n1so500548lba.38
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:03:09 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 0/5] wlcore/wl18xx: fixes and HW deprecation
Date: Tue, 26 Jun 2012 23:02:55 +0300
Message-Id: <1340740980-22284-1-git-send-email-coelho@ti.com> (sfid-20120626_220320_521615_3984F172)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are a few more patches for wlcore and wl18xx.  Three patches by
Eyal to fix a couple of bugs we found in the IO changes patchset and
improve the recovery traces.

Also two patches of my own that deprecate an old HW version of the
wl18xx chips (a sample PG1).  The reason to deprecate this is that
these chips will never be used outside TI and removing support for it
avoids some blunt caused by workarounds and other things that were
fixed in the hardware (PG2).

Please review.

Luca.

Eyal Shapira (3):
  wlcore: fix broken TX due to wrong queuing of recovery
  wlcore: queue recovery in case of bus errors during cmd_remove_peer
  wlcore: print stack trace in every recovery

Luciano Coelho (2):
  wl18xx: deprecate PG1 support
  wlcore: fix some failure cases in wlcore_probe()

 drivers/net/wireless/ti/wl18xx/acx.h  |   34 +++++++++++--------------
 drivers/net/wireless/ti/wl18xx/main.c |   45 +++++----------------------------
 drivers/net/wireless/ti/wlcore/cmd.c  |   30 ++++++++++++++--------
 drivers/net/wireless/ti/wlcore/main.c |   11 +++++---
 drivers/net/wireless/ti/wlcore/tx.c   |   35 +++++++++++++++++--------
 5 files changed, 73 insertions(+), 82 deletions(-)

-- 
1.7.10

