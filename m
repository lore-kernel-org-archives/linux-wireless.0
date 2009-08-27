Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50835 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZH0VAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 00/13] wl1271: patch set with various improvements
Date: Thu, 27 Aug 2009 23:59:54 +0300
Message-Id: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a bunch of patches with some improvements to the wl1271 driver.  A few
of them fix some issues with TX, some workaround for problems we have
identified and other general improvements.  I'm also adding Juuso Oikarinen as
one of the module authors, since he's one of the main wl1271 developers as
well.

Cheers,
Luca.

Juuso Oikarinen (11):
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

Luciano Coelho (2):
  wl1271: remove unecessary qual parameter from rx status
  wl1271: added Juuso Oikarinen as module author

 drivers/net/wireless/wl12xx/wl1271.h       |   35 +++++++++-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |    4 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h   |    3 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   31 +++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    6 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 +
 drivers/net/wireless/wl12xx/wl1271_init.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |  105 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_ps.c    |   46 +++++++++----
 drivers/net/wireless/wl12xx/wl1271_ps.h    |    2 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |    6 --
 drivers/net/wireless/wl12xx/wl1271_spi.c   |   69 ++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   48 +++++++++----
 13 files changed, 275 insertions(+), 86 deletions(-)

