Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:58100 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab2AXJGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:41 -0500
Received: by laho5 with SMTP id o5so750123lah.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:38 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/8] wl12xx: some fixes and improvements for PLT mode
Date: Tue, 24 Jan 2012 11:06:21 +0200
Message-Id: <1327395989-29663-1-git-send-email-coelho@ti.com> (sfid-20120124_100649_553080_F51E9933)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset fixes some bugs in PLT mode and adds support for 2 MAC
addresses based on the NVS file or in the device's fuse ROM.

This two patches I sent as part of the "wl12xx: read MAC from fuse
rom" series are superseded by this set.

Cheers,
Luca.
 

Ido Yariv (3):
  wl12xx: Acquire lock before stopping plt
  wl12xx: Power off after flushing work
  wl12xx: Fix potential interrupt storm

Luciano Coelho (5):
  wl12xx: cancel delayed elp work and clear flags when stopping PLT
  wl12xx: move partition table definition to io.c
  wl12xx: read chip ID and HW PG version during probe
  wl12xx: use two MAC addresses based on the NVS or from fuse ROM
  wl12xx: add testmode operation to read the BD_ADDR from Fuse ROM

 drivers/net/wireless/wl12xx/boot.c     |  102 ++-------------
 drivers/net/wireless/wl12xx/boot.h     |   10 --
 drivers/net/wireless/wl12xx/debug.h    |    1 +
 drivers/net/wireless/wl12xx/io.c       |   59 +++++++++
 drivers/net/wireless/wl12xx/io.h       |    2 +
 drivers/net/wireless/wl12xx/main.c     |  216 ++++++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/reg.h      |   27 ++++
 drivers/net/wireless/wl12xx/testmode.c |   50 ++++++++
 drivers/net/wireless/wl12xx/wl12xx.h   |    7 +-
 9 files changed, 335 insertions(+), 139 deletions(-)

-- 
1.7.4.1

