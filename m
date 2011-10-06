Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50451 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759084Ab1JFTLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:11 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so5079556bkb.33
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] wl12xx: forward ported Balbi's bus driver refactor
Date: Thu,  6 Oct 2011 22:10:51 +0300
Message-Id: <1317928259-26437-1-git-send-email-coelho@ti.com> (sfid-20111006_211114_811950_63057E48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Felipe sent this series of patches a long time ago with very good
suggestion on how to avoid the duplicate code we have in the sdio and
spi drivers.

With this, we create a platform device that is handled by a platform
driver.  The bus-specific module, creates a platform device and the
core module implements the driver that supports both platform devices
(namely "wl12xx-sdio" and "wl12xx-spi").

I didn't apply this earlier because I had concerns about the change in
the platform data, but now I'm convinced it's not a real problem.  It
may affect compat-wireless, but it's easy to solve.

I have now forward-ported the patches, fixed some bugs, removed some
style changes and moved some other things around.  For the changes I
made, see the commit message of each patch.  Some changes are not in
the commit message, but are explained in the patch emails, after the
Signed-off-by area.

I'm keeping Felipe as the author, since most of the work is his.  I
have just tested and fixed it up.

Cheers,
Luca.

Felipe Balbi (8):
  wl12xx: add an sdio glue struct to keep wl and device side-by-side
  wl12xx: add an spi glue struct to keep wl and device side-by-side
  wl12xx: add a platform device to the sdio module
  wl12xx: add a platform device to the spi module
  wl12xx: add platform driver to the core module
  wl12xx: move common init code from bus modules to main
  wl12xx: mark some symbols static
  wl12xx: drop unneeded plat_dev

 drivers/net/wireless/wl12xx/io.c                   |   11 +-
 drivers/net/wireless/wl12xx/io.h                   |   23 +--
 drivers/net/wireless/wl12xx/main.c                 |  271 +++++++++++++-------
 drivers/net/wireless/wl12xx/sdio.c                 |  217 +++++++----------
 drivers/net/wireless/wl12xx/spi.c                  |  194 ++++++---------
 drivers/net/wireless/wl12xx/wl12xx.h               |   18 +-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |    4 +-
 include/linux/wl12xx.h                             |    5 +-
 8 files changed, 370 insertions(+), 373 deletions(-)

