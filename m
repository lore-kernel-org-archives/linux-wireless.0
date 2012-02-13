Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61339 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2BMThX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 14:37:23 -0500
Received: by ggnh1 with SMTP id h1so2590704ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 11:37:22 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/5] Firmware load change for various wireless drivers
Date: Mon, 13 Feb 2012 13:37:01 -0600
Message-Id: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120213_203726_939695_C63C1EE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches change 5 drivers that are now loading firmware from the probe
routine. As each of them has the possibility of loading more than one
file, the method of using request_firmware_nowait() has some difficulty,
as it gets duplicate names in sysfs when the requests are launched in
parallel. When the callback routine is used to launch a second request,
the structure gets messy, particularly with b43legacy, which loads 4
firmware files for some hardware. My solution is to create a delayed work
queue that is started in the probe routine with a delay of one second. The
routine that is triggered does the normal request_firmware() calls
and starts mac80211 when the firmware is available.

The patches for b43legacy, b43, and p54usb have been tested. Those for
p54pci and p54spi are only compile tested.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry Finger (5):
  b43legacy: Load firmware from work queue instead of from probe
    routine
  b43: Load firmware from a work queue and not from the probe routine
  p54usb: Load firmware from work queue and not from probe routine
  p54pci: Load firmware from work queue and not from probe routine
  p54spi: Load firmware from work queue and not from probe routine

 drivers/net/wireless/b43/b43.h             |    3 +
 drivers/net/wireless/b43/main.c            |   38 +++++----
 drivers/net/wireless/b43legacy/b43legacy.h |    3 +
 drivers/net/wireless/b43legacy/main.c      |   32 +++++---
 drivers/net/wireless/p54/p54pci.c          |   66 +++++++++------
 drivers/net/wireless/p54/p54pci.h          |    1 +
 drivers/net/wireless/p54/p54spi.c          |   38 ++++++---
 drivers/net/wireless/p54/p54spi.h          |    1 +
 drivers/net/wireless/p54/p54usb.c          |  120 +++++++++++++---------------
 drivers/net/wireless/p54/p54usb.h          |    1 +
 10 files changed, 174 insertions(+), 129 deletions(-)

-- 
1.7.7

