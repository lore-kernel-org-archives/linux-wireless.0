Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36081 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZJMJtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:40 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/22] Third batch of patches for wl1271
Date: Tue, 13 Oct 2009 12:47:37 +0300
Message-Id: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is the third batch of patches to be included in wireless-testing, the
final batch of this series.  The last patch in this patch fixes the filter
configuration as proposed by Johannes.  There are some sparse errors in the
code (also reported by Johannes), which I'll fix next.

Currently the driver cannot associate correctly.  The reason for this is that
the wl1271 firmware requires the BSSID when "joining".  From the current
mac80211 API, we only get the BSSID after the association has succeeded and we
need the join command to change channels.  Anyway, I'll continue discussing
this issue in a separate thread.

Cheers,
Luca.

Juuso Oikarinen (16):
  wl1271: Workaround for reference clock setting on boot.
  wl1271: Add structure for firmware configuration values
  wl1271: Add config structure for RX path parameters
  wl1271: Add config structure for TX path parameters
  wl1271: Add config structure for connection management parameters
  wl1271: Add config structure for FW init parameters
  wl1271: Move default FW config struct away from stack
  wl1271: Fix IRQ enable handling on FW init failure
  wl1271: Implement beacon early termination support
  wl1271: Remove busy-word checking
  wl1271: Fix multicast list handling
  wl1271: Fix event handling mechanism
  wl1271: Support for IPv4 ARP filtering
  wl1271: Remove unnecessary rx_descriptor memory allocation
  wl1271: Correct memory handling for FW boot
  wl1271: Fix filter configuration

Luciano Coelho (1):
  wl1271: make sure PS is disabled in PLT

Teemu Paasikivi (5):
  wl1271: Added 5 GHz parameters for wl1273
  wl1271: Scan only enabled channels
  wl1271: Added support to scan on 5 GHz band
  wl1271: Added 5 GHz support to join and rx
  wl1271: Checking of rx descriptor status fixed

 drivers/net/wireless/wl12xx/wl1271.h       |   44 ++-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |  284 ++++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h   |  269 ++-------
 drivers/net/wireless/wl12xx/wl1271_boot.c  |   17 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  172 ++++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   14 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |  911 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.c |   43 +-
 drivers/net/wireless/wl12xx/wl1271_event.h |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c  |  139 +++--
 drivers/net/wireless/wl12xx/wl1271_init.h  |   51 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |  783 +++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_ps.c    |   10 +
 drivers/net/wireless/wl12xx/wl1271_reg.h   |   44 --
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   53 ++-
 drivers/net/wireless/wl12xx/wl1271_spi.c   |    6 +-
 16 files changed, 2114 insertions(+), 728 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_conf.h

