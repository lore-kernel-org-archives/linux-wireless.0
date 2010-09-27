Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55994 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab0I0IiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:08 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwH023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:06 +0300
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bogu022566
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:37:50 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/25] wl1271: pending patches
Date: Mon, 27 Sep 2010 11:37:24 +0300
Message-Id: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These patches have been pending on our internal tree (for way too long, I have
to admit).  The reason was that I couldn't test these patches before submitting
them upstream.

I have applied all these patches to the new wl12xx git tree [1].  I'll send a
pull request to John shortly.

John, no need to apply this, as I'll send them as part of a pull request.

Cheers,
Luca.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git

Juuso Oikarinen (22):
  wl1271: Implement CMD_SET_STA_STATE to indicate connection completion
    to FW
  wl1271: Add trigger to net_device oper_state to change BT coex
    priority
  wl1271: Fix scan race condition
  wl1271: Change supported channel order for a more optimal scan
  wl1271: Remove outdated FIXME's
  wl1271: Move setting of wake-up conditions to ps.c from cmd.c
  wl1271: Remove acx_fw_version function
  wl1271: Release interrupt *after* releasing the driver context
  wl1271: Remove function cmd_read_memory
  wl1271: Enable/disable 11a support based on INI configuration
  wl1271: Reduce rate used for last PSM entry attempt
  wl1271: Enable 11a support always, prevent scanning for unsupporting
    chips
  wl1271: Add support for hardware GEM cipher
  wl1271: Fix tid-configuration of TX frames
  wl1271: Fix AC/TID default configuration
  wl1271: Move scan complete invocation into work function
  wl1271: Fix work cancelling when shutting down the driver
  wl1271: Separate interface removal to another function
  wl1271: Add hardware recovery mechanism
  wl1271: Add handling for failing hardware scan command
  wl1271: Optimize scan duration
  wl1271: Increase connection reliability

Luciano Coelho (3):
  wl1271: remove deprecated ACX definition
  wl1271: remove useless 11a check when scanning
  wl1271: fix forced passive scan

 drivers/net/wireless/wl12xx/wl1271.h          |   24 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c      |   34 ---
 drivers/net/wireless/wl12xx/wl1271_acx.h      |   31 ---
 drivers/net/wireless/wl12xx/wl1271_boot.c     |   39 ++-
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |   89 +++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h      |   49 +---
 drivers/net/wireless/wl12xx/wl1271_conf.h     |   57 ++++-
 drivers/net/wireless/wl12xx/wl1271_event.c    |   15 +-
 drivers/net/wireless/wl12xx/wl1271_init.c     |   35 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c     |  358 ++++++++++++++++---------
 drivers/net/wireless/wl12xx/wl1271_ps.c       |   20 ++-
 drivers/net/wireless/wl12xx/wl1271_ps.h       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c     |   79 +++++-
 drivers/net/wireless/wl12xx/wl1271_scan.h     |    6 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c     |    3 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c      |    3 +-
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   14 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c       |    6 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h       |   17 --
 19 files changed, 486 insertions(+), 395 deletions(-)

