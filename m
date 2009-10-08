Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56752 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097AbZJHS67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:59 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/20] First batch of new patches for wl1271
Date: Thu,  8 Oct 2009 21:56:16 +0300
Message-Id: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John et al,

We have finally upgraded our internal kernel to 2.6.32, so I now had the time
to continue working on forward porting the patches we have been working on
internally, on top of 2.6.28.  There are 61 patches in total, so I decided to
break them down into separate patch sets, so that it's a bit easier to review.

Here's the first batch.  There are multiple fixes, improvements and updates for
a new firmware release (which has some API changes).

I'll wait until these patches cook a little bit before I send the next bunch.

Cheers,
Luca.

Juuso Oikarinen (17):
  wl1271: Correction to TX block allocation calculation
  wl1271: Security sequence number handling for TX (for WPA)
  wl1271: Correct TKIP header space handling in TX path
  wl1271: Implement delayed entry into ELP
  wl1271: mask aid bits 14 and 15 in ps-poll template
  wl1271: Implementation for SPI busy word checking
  wl1271: Configure rate policies based on AP rates
  wl1271: Update join usage
  wl1271: Corrections to TX path
  wl1271: use workqueue provided by mac80211 instead of the default
  wl1271: Clear probe-request template after scan
  wl1271: Multicast filtering configuration
  wl1271: Use vmalloc to allocate memory for firmware
  wl1271: Add connection monitoring configuration
  wl1271: Enable beacon filtering with the stack
  wl1271: Configure beacon filtering on if PSM used
  wl1271: Mask unneeded events from firmware to conserve power

Luciano Coelho (3):
  wl1271: remove unecessary qual parameter from rx status
  wl1271: added Juuso Oikarinen as module author
  wl1271: hack to disable filters

 drivers/net/wireless/wl12xx/wl1271.h       |   42 +++++-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   54 +++++--
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   29 +++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |   21 ++-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   40 +++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    6 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |   18 ++-
 drivers/net/wireless/wl12xx/wl1271_init.c  |   13 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c  |  244 +++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_ps.c    |   57 +++++--
 drivers/net/wireless/wl12xx/wl1271_ps.h    |    2 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |    6 -
 drivers/net/wireless/wl12xx/wl1271_spi.c   |   69 ++++++++-
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   48 ++++--
 14 files changed, 517 insertions(+), 132 deletions(-)

